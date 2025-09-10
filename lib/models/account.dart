import 'package:hive/hive.dart';

part 'account.g.dart';

@HiveType(typeId: 0)
class Account extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String type;

  @HiveField(3)
  double balance;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime? lastSyncTime;

  Account({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    required this.createdAt,
    this.lastSyncTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'balance': balance,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'lastSyncTime': lastSyncTime?.millisecondsSinceEpoch,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      balance: map['balance'].toDouble(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      lastSyncTime: map['lastSyncTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastSyncTime'])
          : null,
    );
  }
}
