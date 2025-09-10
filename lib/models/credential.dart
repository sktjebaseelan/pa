import 'package:hive/hive.dart';

part 'credential.g.dart';

@HiveType(typeId: 2)
enum CredentialType {
  @HiveField(0)
  bank,
  @HiveField(1)
  aadhaar,
  @HiveField(2)
  pan,
  @HiveField(3)
  email,
}

/// Base interface
abstract class BaseCredential extends HiveObject {
  CredentialType get type;
}

/// 🔹 Bank
@HiveType(typeId: 3)
class BankCredential extends HiveObject implements BaseCredential {
  @HiveField(0)
  String bankName;
  @HiveField(1)
  String ifsc;
  @HiveField(2)
  String accountNumber;
  @HiveField(3)
  String accountType;
  @HiveField(4)
  String? passbookImagePath;

  BankCredential({
    required this.bankName,
    required this.ifsc,
    required this.accountNumber,
    required this.accountType,
    this.passbookImagePath,
  });

  @override
  CredentialType get type => CredentialType.bank;
}

/// 🔹 Aadhaar
@HiveType(typeId: 4)
class AadhaarCredential extends HiveObject implements BaseCredential {
  @HiveField(0)
  String name;
  @HiveField(1)
  String aadhaarNumber;
  @HiveField(2)
  String dob;
  @HiveField(3)
  String? frontImagePath;
  @HiveField(4)
  String? backImagePath;

  AadhaarCredential({
    required this.name,
    required this.aadhaarNumber,
    required this.dob,
    this.frontImagePath,
    this.backImagePath,
  });

  @override
  CredentialType get type => CredentialType.aadhaar;
}

/// 🔹 PAN
@HiveType(typeId: 5)
class PanCredential extends HiveObject implements BaseCredential {
  @HiveField(0)
  String name;
  @HiveField(1)
  String panNumber;
  @HiveField(2)
  String dob;

  PanCredential({
    required this.name,
    required this.panNumber,
    required this.dob,
  });

  @override
  CredentialType get type => CredentialType.pan;
}

/// 🔹 Email
@HiveType(typeId: 6)
class EmailCredential extends HiveObject implements BaseCredential {
  @HiveField(0)
  String username;
  @HiveField(1)
  String password;
  @HiveField(2)
  String provider;

  EmailCredential({
    required this.username,
    required this.password,
    required this.provider,
  });

  @override
  CredentialType get type => CredentialType.email;
}
