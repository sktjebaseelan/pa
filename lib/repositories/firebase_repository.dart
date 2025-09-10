// lib/repositories/firebase_repository.dart
import 'package:firebase_database/firebase_database.dart';
import '../models/account.dart';
import '../models/expense.dart';

class FirebaseRepository {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Account operations
  Future<void> syncAccounts(List<Account> accounts) async {
    try {
      final accountsRef = _database.child('accounts');
      final Map<String, dynamic> accountsMap = {};

      for (Account account in accounts) {
        accountsMap[account.id] = account.toMap();
      }

      await accountsRef.set(accountsMap);
    } catch (e) {
      throw Exception('Failed to sync accounts: $e');
    }
  }

  Future<List<Account>> getAccountsFromFirebase() async {
    try {
      final snapshot = await _database.child('accounts').get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        return data.values
            .map(
              (accountData) =>
                  Account.fromMap(Map<String, dynamic>.from(accountData)),
            )
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to get accounts from Firebase: $e');
    }
  }

  // Expense operations
  Future<void> syncExpenses(List<Expense> expenses) async {
    try {
      final expensesRef = _database.child('expenses');
      final Map<String, dynamic> expensesMap = {};

      for (Expense expense in expenses) {
        expensesMap[expense.id] = expense.toMap();
      }

      await expensesRef.set(expensesMap);
    } catch (e) {
      throw Exception('Failed to sync expenses: $e');
    }
  }

  Future<List<Expense>> getExpensesFromFirebase() async {
    try {
      final snapshot = await _database.child('expenses').get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        return data.values
            .map(
              (expenseData) =>
                  Expense.fromMap(Map<String, dynamic>.from(expenseData)),
            )
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to get expenses from Firebase: $e');
    }
  }

  // Sync timestamp
  Future<void> updateSyncTimestamp() async {
    try {
      await _database
          .child('lastSync')
          .set(DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      throw Exception('Failed to update sync timestamp: $e');
    }
  }

  Future<DateTime?> getLastSyncFromFirebase() async {
    try {
      final snapshot = await _database.child('lastSync').get();
      if (snapshot.exists) {
        return DateTime.fromMillisecondsSinceEpoch(snapshot.value as int);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get last sync time: $e');
    }
  }
}
