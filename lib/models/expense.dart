// lib/models/expense.dart
import 'package:hive/hive.dart';

part 'expense.g.dart';

@HiveType(typeId: 1)
class Expense extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String accountId;

  @HiveField(2)
  String title;

  @HiveField(3)
  String description;

  @HiveField(4)
  double amount;

  @HiveField(5)
  String category;

  @HiveField(6)
  DateTime date;

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  DateTime? lastSyncTime;

  Expense({
    required this.id,
    required this.accountId,
    required this.title,
    required this.description,
    required this.amount,
    required this.category,
    required this.date,
    required this.createdAt,
    this.lastSyncTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'accountId': accountId,
      'title': title,
      'description': description,
      'amount': amount,
      'category': category,
      'date': date.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'lastSyncTime': lastSyncTime?.millisecondsSinceEpoch,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      accountId: map['accountId'],
      title: map['title'],
      description: map['description'],
      amount: map['amount'].toDouble(),
      category: map['category'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      lastSyncTime: map['lastSyncTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastSyncTime'])
          : null,
    );
  }
}
