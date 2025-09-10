import 'package:flutter/material.dart';

import '../models/expense.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;

  const ExpenseCard({required this.expense});

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
                  expense.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  '${expense.amount.toStringAsFixed(2)}',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.red),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              expense.category,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.blue),
            ),
            if (expense.description.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(expense.description),
              ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${expense.date.day}/${expense.date.month}/${expense.date.year}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (expense.lastSyncTime != null)
                  Icon(Icons.cloud_done, color: Colors.green, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
