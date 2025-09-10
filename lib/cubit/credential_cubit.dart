import 'package:expense_tracker/models/credential.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/credential_repository.dart';

class CredentialState {
  final List<BaseCredential> credentials;
  final bool loading;

  CredentialState({required this.credentials, this.loading = false});

  CredentialState copyWith({List<BaseCredential>? credentials, bool? loading}) {
    return CredentialState(
      credentials: credentials ?? this.credentials,
      loading: loading ?? this.loading,
    );
  }
}

class CredentialCubit extends Cubit<CredentialState> {
  final CredentialRepository repo;

  CredentialCubit(this.repo) : super(CredentialState(credentials: []));

  Future<void> load() async {
    emit(state.copyWith(loading: true));
    final list = await repo.getAll();
    emit(CredentialState(credentials: list));
  }

  Future<void> add(BaseCredential cred) async {
    await repo.addCredential(cred);
    await load();
  }

  Future<void> delete(int index) async {
    await repo.deleteCredential(index);
    await load();
  }
}
