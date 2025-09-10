import 'package:expense_tracker/models/credential.dart';
import 'package:hive/hive.dart';

class CredentialRepository {
  Future<Box<BaseCredential>> _openBox() async {
    return await Hive.openBox<BaseCredential>('credentials');
  }

  Future<void> addCredential(BaseCredential credential) async {
    final box = await _openBox();
    await box.add(credential);
  }

  Future<List<BaseCredential>> getAll() async {
    final box = await _openBox();
    return box.values.cast<BaseCredential>().toList();
  }

  Future<void> deleteCredential(int index) async {
    final box = await _openBox();
    await box.deleteAt(index);
  }
}
