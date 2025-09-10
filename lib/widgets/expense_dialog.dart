import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/account_bloc.dart';
import '../blocs/expense_bloc.dart';

class ExpenseDialog extends StatefulWidget {
  final String? accountId;

  ExpenseDialog({this.accountId});

  @override
  _ExpenseDialogState createState() => _ExpenseDialogState();
}

class _ExpenseDialogState extends State<ExpenseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  String? _selectedAccountId;
  String _selectedCategory = 'Food';
  DateTime _selectedDate = DateTime.now();

  final List<String> _categories = [
    'Food',
    'Transportation',
    'Shopping',
    'Entertainment',
    'Bills',
    'Healthcare',
    'Education',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _selectedAccountId = widget.accountId;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Expense'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.accountId == null)
                BlocBuilder<AccountBloc, AccountState>(
                  builder: (context, state) {
                    if (state is AccountLoaded && state.accounts.isNotEmpty) {
                      return DropdownButtonFormField<String>(
                        value: _selectedAccountId,
                        decoration: InputDecoration(labelText: 'Account'),
                        items: state.accounts
                            .map(
                              (account) => DropdownMenuItem(
                                value: account.id,
                                child: Text(account.name),
                              ),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _selectedAccountId = value),
                        validator: (value) =>
                            value == null ? 'Please select account' : null,
                      );
                    }
                    return Text('No accounts available');
                  },
                ),
              SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value?.isEmpty == true ? 'Please enter title' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 2,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty == true) return 'Please enter amount';
                  if (double.tryParse(value!) == null)
                    return 'Please enter valid number';
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(labelText: 'Category'),
                items: _categories
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ),
                    )
                    .toList(),
                onChanged: (value) =>
                    setState(() => _selectedCategory = value!),
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text('Date'),
                subtitle: Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: _selectDate,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(onPressed: _saveExpense, child: Text('Save')),
      ],
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  void _saveExpense() {
    if (_formKey.currentState?.validate() == true &&
        _selectedAccountId != null) {
      context.read<ExpenseBloc>().add(
        AddExpense(
          accountId: _selectedAccountId!,
          title: _titleController.text,
          description: _descriptionController.text,
          amount: double.parse(_amountController.text),
          category: _selectedCategory,
          date: _selectedDate,
        ),
      );

      // Refresh accounts to show updated balance
      context.read<AccountBloc>().add(LoadAccounts());

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
