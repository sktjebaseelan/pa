import 'package:expense_tracker/models/account.dart';
import 'package:flutter/material.dart';

class AccountCard extends StatelessWidget {
  final Account account;

  const AccountCard({required this.account});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  account.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                if (account.lastSyncTime != null)
                  Icon(Icons.cloud_done, color: Colors.green),
              ],
            ),
            SizedBox(height: 8),
            Text(account.type, style: Theme.of(context).textTheme.bodyMedium),
            SizedBox(height: 8),
            Text(
              '\${account.balance.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: account.balance >= 0 ? Colors.green : Colors.red,
              ),
            ),
            if (account.lastSyncTime != null)
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Last synced: ${account.lastSyncTime!.day}/${account.lastSyncTime!.month} ${account.lastSyncTime!.hour}:${account.lastSyncTime!.minute.toString().padLeft(2, '0')}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
