// lib/screens/account_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/account_bloc.dart';
import '../models/account.dart';
import '../widgets/account_card.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Accounts')),
      body: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          if (state is AccountLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is AccountLoaded) {
            return ListView.builder(
              itemCount: state.accounts.length,
              itemBuilder: (context, index) {
                final account = state.accounts[index];
                return AccountCard(account: account);
              },
            );
          } else if (state is AccountError) {
            return Center(child: Text(state.message));
          }
          return Center(child: Text('No accounts found'));
        },
      ),
    );
  }
}
