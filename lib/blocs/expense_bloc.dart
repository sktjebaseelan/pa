// lib/blocs/expense_bloc.dart
import 'package:expense_tracker/blocs/account_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../models/expense.dart';
import '../repositories/database_repository.dart';

// Events
abstract class ExpenseEvent {}

class LoadExpenses extends ExpenseEvent {}

class LoadExpensesByAccount extends ExpenseEvent {
  final String accountId;

  LoadExpensesByAccount(this.accountId);
}

class AddExpense extends ExpenseEvent {
  final String accountId;
  final String title;
  final String description;
  final double amount;
  final String category;
  final DateTime date;

  AddExpense({
    required this.accountId,
    required this.title,
    required this.description,
    required this.amount,
    required this.category,
    required this.date,
  });
}

class UpdateExpense extends ExpenseEvent {
  final Expense expense;

  UpdateExpense(this.expense);
}

class DeleteExpense extends ExpenseEvent {
  final String expenseId;

  DeleteExpense(this.expenseId);
}

// States
abstract class ExpenseState {}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseLoaded extends ExpenseState {
  final List<Expense> expenses;

  ExpenseLoaded(this.expenses);
}

class ExpenseError extends ExpenseState {
  final String message;

  ExpenseError(this.message);
}

// Bloc
class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final DatabaseRepository databaseRepository;
  final AccountBloc? accountBloc;

  ExpenseBloc({required this.databaseRepository, this.accountBloc})
    : super(ExpenseInitial()) {
    on<LoadExpenses>(_onLoadExpenses);
    on<LoadExpensesByAccount>(_onLoadExpensesByAccount);
    on<AddExpense>(_onAddExpense);
    on<UpdateExpense>(_onUpdateExpense);
    on<DeleteExpense>(_onDeleteExpense);
  }

  Future<void> _onLoadExpenses(
    LoadExpenses event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseLoading());
    try {
      final expenses = await databaseRepository.getAllExpenses();
      emit(ExpenseLoaded(expenses));
    } catch (e) {
      emit(ExpenseError('Failed to load expenses: $e'));
    }
  }

  Future<void> _onLoadExpensesByAccount(
    LoadExpensesByAccount event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseLoading());
    try {
      final expenses = await databaseRepository.getExpensesByAccount(
        event.accountId,
      );
      emit(ExpenseLoaded(expenses));
    } catch (e) {
      emit(ExpenseError('Failed to load expenses: $e'));
    }
  }

  Future<void> _onAddExpense(
    AddExpense event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      final expense = Expense(
        id: const Uuid().v4(),
        accountId: event.accountId,
        title: event.title,
        description: event.description,
        amount: event.amount,
        category: event.category,
        date: event.date,
        createdAt: DateTime.now(),
      );

      await databaseRepository.addExpense(expense);
      // Update account balance and refresh accounts immediately
      await databaseRepository.updateAccountBalance(
        event.accountId,
        -event.amount,
      );
      accountBloc?.add(RefreshAccounts());
      add(LoadExpenses());
    } catch (e) {
      emit(ExpenseError('Failed to add expense: $e'));
    }
  }

  Future<void> _onUpdateExpense(
    UpdateExpense event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      // Get the original expense to calculate the difference
      final originalExpense = await databaseRepository.getExpenseById(
        event.expense.id,
      );
      if (originalExpense != null) {
        final amountDifference = event.expense.amount - originalExpense.amount;

        // Update the expense
        await databaseRepository.updateExpense(event.expense);

        // Handle account changes
        if (originalExpense.accountId != event.expense.accountId) {
          // Moving expense between accounts
          // Add back the original amount to the old account
          await databaseRepository.updateAccountBalance(
            originalExpense.accountId,
            originalExpense.amount,
          );
          // Subtract the new amount from the new account
          await databaseRepository.updateAccountBalance(
            event.expense.accountId,
            -event.expense.amount,
          );
        } else if (amountDifference != 0) {
          // Same account, different amount
          await databaseRepository.updateAccountBalance(
            event.expense.accountId,
            -amountDifference,
          );
        }

        // Refresh accounts immediately
        accountBloc?.add(RefreshAccounts());
      } else {
        await databaseRepository.updateExpense(event.expense);
      }

      add(LoadExpenses());
    } catch (e) {
      emit(ExpenseError('Failed to update expense: $e'));
    }
  }

  Future<void> _onDeleteExpense(
    DeleteExpense event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      await databaseRepository.deleteExpense(event.expenseId);
      accountBloc?.add(RefreshAccounts());
      add(LoadExpenses());
    } catch (e) {
      emit(ExpenseError('Failed to delete expense: $e'));
    }
  }
}
