// lib/blocs/sync_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/database_repository.dart';
import '../repositories/firebase_repository.dart';

// Events
abstract class SyncEvent {}

class SyncData extends SyncEvent {}

class GetLastSyncTime extends SyncEvent {}

// States
abstract class SyncState {}

class SyncInitial extends SyncState {}

class SyncLoading extends SyncState {}

class SyncCompleted extends SyncState {
  final DateTime syncTime;

  SyncCompleted(this.syncTime);
}

class SyncError extends SyncState {
  final String message;

  SyncError(this.message);
}

class SyncTimeLoaded extends SyncState {
  final DateTime? lastSyncTime;

  SyncTimeLoaded(this.lastSyncTime);
}

// Bloc
class SyncBloc extends Bloc<SyncEvent, SyncState> {
  final DatabaseRepository databaseRepository;
  final FirebaseRepository firebaseRepository;

  SyncBloc({required this.databaseRepository, required this.firebaseRepository})
    : super(SyncInitial()) {
    on<SyncData>(_onSyncData);
    on<GetLastSyncTime>(_onGetLastSyncTime);
  }

  Future<void> _onSyncData(SyncData event, Emitter<SyncState> emit) async {
    emit(SyncLoading());
    try {
      // Get local data
      final accounts = await databaseRepository.getAllAccounts();
      final expenses = await databaseRepository.getAllExpenses();

      // Sync to Firebase
      await firebaseRepository.syncAccounts(accounts);
      await firebaseRepository.syncExpenses(expenses);
      await firebaseRepository.updateSyncTimestamp();

      // Update local sync time
      final syncTime = DateTime.now();
      await databaseRepository.setLastSyncTime(syncTime);

      // Update last sync time for all records
      for (var account in accounts) {
        account.lastSyncTime = syncTime;
        await databaseRepository.updateAccount(account);
      }

      for (var expense in expenses) {
        expense.lastSyncTime = syncTime;
        await databaseRepository.updateExpense(expense);
      }

      emit(SyncCompleted(syncTime));
    } catch (e) {
      emit(SyncError('Sync failed: $e'));
    }
  }

  Future<void> _onGetLastSyncTime(
    GetLastSyncTime event,
    Emitter<SyncState> emit,
  ) async {
    try {
      final lastSyncTime = await databaseRepository.getLastSyncTime();
      emit(SyncTimeLoaded(lastSyncTime));
    } catch (e) {
      emit(SyncError('Failed to get sync time: $e'));
    }
  }
}
