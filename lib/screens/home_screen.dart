// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/account_bloc.dart';
import '../blocs/expense_bloc.dart';
import '../blocs/sync_bloc.dart';
import '../models/account.dart';
import '../widgets/account_dialog.dart';
import '../widgets/expense_dialog.dart';
import 'account_screen.dart';
import 'expense_screen.dart';
import 'report_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<SyncBloc>().add(GetLastSyncTime());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle()),
        actions: [
          BlocConsumer<SyncBloc, SyncState>(
            listener: (context, state) {
              if (state is SyncCompleted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Sync completed successfully')),
                );
              } else if (state is SyncError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            builder: (context, state) {
              return IconButton(
                onPressed: state is SyncLoading
                    ? null
                    : () => context.read<SyncBloc>().add(SyncData()),
                icon: state is SyncLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(Icons.sync),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [_buildAccountsTab(), _buildExpensesTab(), ReportScreen()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: 'Accounts',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.money), label: 'Expenses'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Reports',
          ),
        ],
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  String _getAppBarTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Accounts';
      case 1:
        return 'Expenses';
      case 2:
        return 'Reports';
      default:
        return 'Expense Tracker';
    }
  }

  Widget _buildAccountsTab() {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        if (state is AccountLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is AccountLoaded) {
          return _buildAccountsList(state.accounts);
        } else if (state is AccountError) {
          return Center(child: Text(state.message));
        }
        return Center(child: Text('No accounts found'));
      },
    );
  }

  Widget _buildAccountsList(List<Account> accounts) {
    if (accounts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance, size: 64, color: Colors.grey),
            Text('No accounts yet', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            Text('Tap + to add your first account'),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: accounts.length,
      itemBuilder: (context, index) {
        final account = accounts[index];
        return Card(
          margin: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(child: Icon(Icons.account_balance)),
            title: Text(account.name),
            subtitle: Text(
              '${account.type} • \$${account.balance.toStringAsFixed(2)}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (account.lastSyncTime != null)
                  Icon(Icons.cloud_done, color: Colors.green, size: 20),
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                  onSelected: (value) {
                    if (value == 'delete') {
                      _showDeleteDialog(context, account);
                    } else {
                      _showEditAccountDialog(account);
                    }
                  },
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExpenseScreen(accountId: account.id),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildExpensesTab() {
    return BlocBuilder<ExpenseBloc, ExpenseState>(
      builder: (context, state) {
        if (state is ExpenseLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ExpenseLoaded) {
          if (state.expenses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.money_off, size: 64, color: Colors.grey),
                  Text('No expenses yet', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 16),
                  Text('Tap + to add your first expense'),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: state.expenses.length,
            itemBuilder: (context, index) {
              final expense = state.expenses[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  leading: CircleAvatar(child: Icon(Icons.money)),
                  title: Text(expense.title),
                  subtitle: Text(
                    '${expense.category} • ${expense.date.day}/${expense.date.month}',
                  ),
                  trailing: Text('\$${expense.amount.toStringAsFixed(2)}'),
                ),
              );
            },
          );
        } else if (state is ExpenseError) {
          return Center(child: Text(state.message));
        }
        return Center(child: Text('No expenses found'));
      },
    );
  }

  Widget? _buildFAB() {
    switch (_currentIndex) {
      case 0:
        return FloatingActionButton(
          onPressed: () => _showAddAccountDialog(),
          child: Icon(Icons.add),
        );
      case 1:
        return FloatingActionButton(
          onPressed: () => _showAddExpenseDialog(),
          child: Icon(Icons.add),
        );
      default:
        return null;
    }
  }

  void _showAddAccountDialog() {
    showDialog(context: context, builder: (context) => AccountDialog());
  }

  void _showAddExpenseDialog() {
    showDialog(context: context, builder: (context) => ExpenseDialog());
  }

  void _showDeleteDialog(BuildContext context, Account account) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Account'),
        content: Text('Are you sure you want to delete ${account.name}?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AccountBloc>().add(DeleteAccount(account.id));
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showEditAccountDialog(Account? account) {
    showDialog(
      context: context,
      builder: (context) => AccountDialog(account: account),
    );
  }
}
