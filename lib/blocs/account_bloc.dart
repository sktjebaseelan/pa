// lib/blocs/account_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../models/account.dart';
import '../repositories/database_repository.dart';

// Events
abstract class AccountEvent {}

class LoadAccounts extends AccountEvent {}

class RefreshAccounts extends AccountEvent {}

class AddAccount extends AccountEvent {
  final String name;
  final String type;
  final double balance;

  AddAccount({required this.name, required this.type, required this.balance});
}

class UpdateAccount extends AccountEvent {
  final Account account;

  UpdateAccount(this.account);
}

class UpdateAccountBalance extends AccountEvent {
  final String accountId;
  final double amountChange;

  UpdateAccountBalance({required this.accountId, required this.amountChange});
}

class DeleteAccount extends AccountEvent {
  final String accountId;

  DeleteAccount(this.accountId);
}

// States
abstract class AccountState {}

class AccountInitial extends AccountState {}

class AccountLoading extends AccountState {}

class AccountLoaded extends AccountState {
  final List<Account> accounts;

  AccountLoaded(this.accounts);
}

class AccountError extends AccountState {
  final String message;

  AccountError(this.message);
}

// Bloc
class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final DatabaseRepository databaseRepository;

  AccountBloc({required this.databaseRepository}) : super(AccountInitial()) {
    on<LoadAccounts>(_onLoadAccounts);
    on<AddAccount>(_onAddAccount);
    on<UpdateAccount>(_onUpdateAccount);
    on<UpdateAccountBalance>(_onUpdateAccountBalance);
    on<DeleteAccount>(_onDeleteAccount);
  }

  Future<void> _onLoadAccounts(
    LoadAccounts event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading());
    try {
      final accounts = await databaseRepository.getAllAccounts();
      emit(AccountLoaded(accounts));
    } catch (e) {
      emit(AccountError('Failed to load accounts: $e'));
    }
  }

  Future<void> _onAddAccount(
    AddAccount event,
    Emitter<AccountState> emit,
  ) async {
    try {
      final account = Account(
        id: const Uuid().v4(),
        name: event.name,
        type: event.type,
        balance: event.balance,
        createdAt: DateTime.now(),
      );

      await databaseRepository.addAccount(account);
      add(LoadAccounts());
    } catch (e) {
      emit(AccountError('Failed to add account: $e'));
    }
  }

  Future<void> _onUpdateAccount(
    UpdateAccount event,
    Emitter<AccountState> emit,
  ) async {
    try {
      await databaseRepository.updateAccount(event.account);
      add(LoadAccounts());
    } catch (e) {
      emit(AccountError('Failed to update account: $e'));
    }
  }

  Future<void> _onUpdateAccountBalance(
    UpdateAccountBalance event,
    Emitter<AccountState> emit,
  ) async {
    try {
      await databaseRepository.updateAccountBalance(
        event.accountId,
        event.amountChange,
      );
      // Immediately refresh the accounts to show updated balance
      final accounts = await databaseRepository.getAllAccounts();
      emit(AccountLoaded(accounts));
    } catch (e) {
      emit(AccountError('Failed to update account balance: $e'));
    }
  }

  Future<void> _onDeleteAccount(
    DeleteAccount event,
    Emitter<AccountState> emit,
  ) async {
    try {
      await databaseRepository.deleteAccount(event.accountId);
      add(LoadAccounts());
    } catch (e) {
      emit(AccountError('Failed to delete account: $e'));
    }
  }
}
