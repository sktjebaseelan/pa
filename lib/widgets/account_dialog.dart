// Dialog Widgets
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/account_bloc.dart';
import '../models/account.dart';

class AccountDialog extends StatefulWidget {
  final Account? account;

  AccountDialog({this.account});

  @override
  _AccountDialogState createState() => _AccountDialogState();
}

class _AccountDialogState extends State<AccountDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  String _selectedType = 'Checking';
  final List<String> _accountTypes = [
    'Checking',
    'Savings',
    'Credit Card',
    'Cash',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.account != null) {
      _nameController.text = widget.account!.name;
      _balanceController.text = widget.account!.balance.toString();
      _selectedType = widget.account!.type;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.account == null ? 'Add Account' : 'Edit Account'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Account Name'),
              validator: (value) =>
                  value?.isEmpty == true ? 'Please enter account name' : null,
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: InputDecoration(labelText: 'Account Type'),
              items: _accountTypes
                  .map(
                    (type) => DropdownMenuItem(value: type, child: Text(type)),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _selectedType = value!),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _balanceController,
              decoration: InputDecoration(labelText: 'Initial Balance'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty == true) return 'Please enter balance';
                if (double.tryParse(value!) == null)
                  return 'Please enter valid number';
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: _saveAccount,
          child: Text(widget.account == null ? 'Save' : 'Update'),
        ),
      ],
    );
  }

  void _saveAccount() {
    if (_formKey.currentState?.validate() == true) {
      final name = _nameController.text;
      final balance = double.parse(_balanceController.text);

      if (widget.account == null) {
        context.read<AccountBloc>().add(
          AddAccount(name: name, type: _selectedType, balance: balance),
        );
      } else {
        final updatedAccount = Account(
          id: widget.account!.id,
          name: name,
          type: _selectedType,
          balance: balance,
          createdAt: widget.account!.createdAt,
          lastSyncTime: widget.account!.lastSyncTime,
        );
        context.read<AccountBloc>().add(UpdateAccount(updatedAccount));
      }

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }
}
