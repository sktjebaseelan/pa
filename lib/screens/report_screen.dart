// lib/screens/report_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../blocs/account_bloc.dart';
import '../blocs/expense_bloc.dart';
import '../models/account.dart';
import '../models/expense.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../blocs/account_bloc.dart';
import '../blocs/expense_bloc.dart';
import '../models/account.dart';
import '../models/expense.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  DateTimeRange? _selectedRange;
  String? _selectedAccountId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(child: _buildReportContent()),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: BlocBuilder<AccountBloc, AccountState>(
                    builder: (context, state) {
                      if (state is AccountLoaded) {
                        return DropdownButtonFormField<String>(
                          value: _selectedAccountId,
                          decoration: InputDecoration(labelText: 'Account'),
                          items: [
                            DropdownMenuItem(
                              value: null,
                              child: Text('All Accounts'),
                            ),
                            ...state.accounts
                                .map(
                                  (account) => DropdownMenuItem(
                                    value: account.id,
                                    child: Text(account.name),
                                  ),
                                )
                                .toList(),
                          ],
                          onChanged: (value) =>
                              setState(() => _selectedAccountId = value),
                        );
                      }
                      return Text('Loading accounts...');
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: _selectDateRange,
                    icon: Icon(Icons.date_range),
                    label: Text(
                      _selectedRange == null
                          ? 'Select Date Range'
                          : '${DateFormat('MMM dd').format(_selectedRange!.start)} - ${DateFormat('MMM dd').format(_selectedRange!.end)}',
                    ),
                  ),
                ),
                if (_selectedRange != null || _selectedAccountId != null)
                  TextButton(onPressed: _clearFilters, child: Text('Clear')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportContent() {
    return BlocBuilder<ExpenseBloc, ExpenseState>(
      builder: (context, expenseState) {
        return BlocBuilder<AccountBloc, AccountState>(
          builder: (context, accountState) {
            if (expenseState is ExpenseLoaded &&
                accountState is AccountLoaded) {
              final filteredExpenses = _getFilteredExpenses(
                expenseState.expenses,
              );
              final accounts = accountState.accounts;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    _buildSummaryCards(filteredExpenses, accounts),
                    _buildCategoryBreakdown(filteredExpenses),
                    _buildAccountBreakdown(filteredExpenses, accounts),
                    _buildWhatsAppButton(filteredExpenses, accounts),
                  ],
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        );
      },
    );
  }

  List<Expense> _getFilteredExpenses(List<Expense> expenses) {
    var filtered = expenses;

    if (_selectedAccountId != null) {
      filtered = filtered
          .where((e) => e.accountId == _selectedAccountId)
          .toList();
    }

    if (_selectedRange != null) {
      filtered = filtered
          .where(
            (e) =>
                e.date.isAfter(
                  _selectedRange!.start.subtract(Duration(days: 1)),
                ) &&
                e.date.isBefore(_selectedRange!.end.add(Duration(days: 1))),
          )
          .toList();
    }

    return filtered;
  }

  Widget _buildSummaryCards(List<Expense> expenses, List<Account> accounts) {
    final totalExpenses = expenses.fold(
      0.0,
      (sum, expense) => sum + expense.amount,
    );
    final totalBalance = accounts.fold(
      0.0,
      (sum, account) => sum + account.balance,
    );

    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Total Expenses',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    '${totalExpenses.toStringAsFixed(2)}',
                    style: Theme.of(
                      context,
                    ).textTheme.headlineMedium?.copyWith(color: Colors.red),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Total Balance',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    '${totalBalance.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: totalBalance >= 0 ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryBreakdown(List<Expense> expenses) {
    final categoryTotals = <String, double>{};
    for (final expense in expenses) {
      categoryTotals[expense.category] =
          (categoryTotals[expense.category] ?? 0) + expense.amount;
    }

    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Expenses by Category',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            ...categoryTotals.entries
                .map(
                  (entry) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(entry.key),
                        Text('${entry.value.toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountBreakdown(
    List<Expense> expenses,
    List<Account> accounts,
  ) {
    final accountExpenses = <String, double>{};
    final accountNames = <String, String>{};

    for (final account in accounts) {
      accountNames[account.id] = account.name;
      accountExpenses[account.id] = 0.0;
    }

    for (final expense in expenses) {
      accountExpenses[expense.accountId] =
          (accountExpenses[expense.accountId] ?? 0) + expense.amount;
    }

    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Expenses by Account',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            ...accountExpenses.entries
                .where((entry) => entry.value > 0)
                .map(
                  (entry) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(accountNames[entry.key] ?? 'Unknown'),
                        Text('${entry.value.toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildWhatsAppButton(List<Expense> expenses, List<Account> accounts) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Share Report', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _shareToWhatsApp(expenses, accounts),
              icon: Icon(Icons.share),
              label: Text('Send to Manager via WhatsApp'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDateRange() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _selectedRange,
    );
    if (range != null) {
      setState(() => _selectedRange = range);
    }
  }

  void _clearFilters() {
    setState(() {
      _selectedRange = null;
      _selectedAccountId = null;
    });
  }

  void _shareToWhatsApp(List<Expense> expenses, List<Account> accounts) async {
    final report = _generateReport(expenses, accounts);
    final encodedText = Uri.encodeComponent(report);
    final whatsappUrl = 'https://wa.me/?text=$encodedText';

    try {
      if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
        await launchUrl(Uri.parse(whatsappUrl));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('WhatsApp not available')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error sharing report: $e')));
    }
  }

  String _generateReport(List<Expense> expenses, List<Account> accounts) {
    final buffer = StringBuffer();
    buffer.writeln('📊 EXPENSE REPORT');
    buffer.writeln(
      'Generated on: ${DateFormat('MMM dd, yyyy HH:mm').format(DateTime.now())}',
    );
    buffer.writeln();

    if (_selectedRange != null) {
      buffer.writeln(
        '📅 Period: ${DateFormat('MMM dd').format(_selectedRange!.start)} - ${DateFormat('MMM dd').format(_selectedRange!.end)}',
      );
      buffer.writeln();
    }

    final totalExpenses = expenses.fold(
      0.0,
      (sum, expense) => sum + expense.amount,
    );
    final totalBalance = accounts.fold(
      0.0,
      (sum, account) => sum + account.balance,
    );

    buffer.writeln('💰 SUMMARY');
    buffer.writeln('Total Expenses: ${totalExpenses.toStringAsFixed(2)}');
    buffer.writeln('Total Balance: ${totalBalance.toStringAsFixed(2)}');
    buffer.writeln();

    // Category breakdown
    final categoryTotals = <String, double>{};
    for (final expense in expenses) {
      categoryTotals[expense.category] =
          (categoryTotals[expense.category] ?? 0) + expense.amount;
    }

    if (categoryTotals.isNotEmpty) {
      buffer.writeln('📋 BY CATEGORY');
      categoryTotals.entries.forEach((entry) {
        buffer.writeln('• ${entry.key}: ${entry.value.toStringAsFixed(2)}');
      });
      buffer.writeln();
    }

    // Recent expenses
    final recentExpenses = expenses.take(5).toList();
    if (recentExpenses.isNotEmpty) {
      buffer.writeln('📝 RECENT EXPENSES');
      recentExpenses.forEach((expense) {
        buffer.writeln(
          '• ${expense.title} - ${expense.amount.toStringAsFixed(2)} (${expense.category})',
        );
      });
    }

    return buffer.toString();
  }
}
