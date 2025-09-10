// lib/repositories/database_repository.dart
import 'package:hive_flutter/hive_flutter.dart';
import '../models/account.dart';
import '../models/expense.dart';

class DatabaseRepository {
  static const String accountBoxName = 'accounts';
  static const String expenseBoxName = 'expenses';
  static const String syncBoxName = 'sync_data';

  Future<Box<Account>> get _accountBox async =>
      await Hive.openBox<Account>(accountBoxName);

  Future<Box<Expense>> get _expenseBox async =>
      await Hive.openBox<Expense>(expenseBoxName);

  Future<Box> get _syncBox async => await Hive.openBox(syncBoxName);

  // Account operations
  Future<List<Account>> getAllAccounts() async {
    final box = await _accountBox;
    return box.values.toList();
  }

  Future<Expense?> getExpenseById(String expenseId) async {
    final box = await _expenseBox;
    return box.get(expenseId);
  }

  Future<void> addAccount(Account account) async {
    final box = await _accountBox;
    await box.put(account.id, account);
  }

  Future<void> updateAccount(Account account) async {
    final box = await _accountBox;
    await box.put(account.id, account);
  }

  Future<void> updateAccountBalance(
    String accountId,
    double amountChange,
  ) async {
    final box = await _accountBox;
    final account = box.get(accountId);
    if (account != null) {
      account.balance += amountChange;
      await box.put(accountId, account);
    }
  }

  Future<void> deleteAccount(String accountId) async {
    final box = await _accountBox;
    await box.delete(accountId);
  }

  // Expense operations
  Future<List<Expense>> getAllExpenses() async {
    final box = await _expenseBox;
    return box.values.toList();
  }

  Future<List<Expense>> getExpensesByAccount(String accountId) async {
    final box = await _expenseBox;
    return box.values
        .where((expense) => expense.accountId == accountId)
        .toList();
  }

  Future<void> addExpense(Expense expense) async {
    final box = await _expenseBox;
    await box.put(expense.id, expense);
  }

  Future<void> updateExpense(Expense expense) async {
    final box = await _expenseBox;
    await box.put(expense.id, expense);
  }

  Future<void> deleteExpense(String expenseId) async {
    final box = await _expenseBox;
    await box.delete(expenseId);
  }

  // Sync operations
  Future<DateTime?> getLastSyncTime() async {
    final box = await _syncBox;
    final timestamp = box.get('lastSyncTime');
    return timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp)
        : null;
  }

  Future<void> setLastSyncTime(DateTime syncTime) async {
    final box = await _syncBox;
    await box.put('lastSyncTime', syncTime.millisecondsSinceEpoch);
  }
}
