// lib/screens/expense_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/expense_bloc.dart';
import '../models/expense.dart';
import '../widgets/expense_card.dart';

class ExpenseScreen extends StatefulWidget {
  final String? accountId;

  ExpenseScreen({this.accountId});

  @override
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.accountId != null) {
      context.read<ExpenseBloc>().add(LoadExpensesByAccount(widget.accountId!));
    } else {
      context.read<ExpenseBloc>().add(LoadExpenses());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.accountId != null ? 'Account Expenses' : 'All Expenses',
        ),
      ),
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
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
                    Text('No expenses found'),
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: state.expenses.length,
              itemBuilder: (context, index) {
                final expense = state.expenses[index];
                return ExpenseCard(expense: expense);
              },
            );
          } else if (state is ExpenseError) {
            return Center(child: Text(state.message));
          }
          return Center(child: Text('No expenses found'));
        },
      ),
    );
  }
}
