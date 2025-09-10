// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BankCredentialAdapter extends TypeAdapter<BankCredential> {
  @override
  final int typeId = 3;

  @override
  BankCredential read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BankCredential(
      bankName: fields[0] as String,
      ifsc: fields[1] as String,
      accountNumber: fields[2] as String,
      accountType: fields[3] as String,
      passbookImagePath: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BankCredential obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.bankName)
      ..writeByte(1)
      ..write(obj.ifsc)
      ..writeByte(2)
      ..write(obj.accountNumber)
      ..writeByte(3)
      ..write(obj.accountType)
      ..writeByte(4)
      ..write(obj.passbookImagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BankCredentialAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AadhaarCredentialAdapter extends TypeAdapter<AadhaarCredential> {
  @override
  final int typeId = 4;

  @override
  AadhaarCredential read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AadhaarCredential(
      name: fields[0] as String,
      aadhaarNumber: fields[1] as String,
      dob: fields[2] as String,
      frontImagePath: fields[3] as String?,
      backImagePath: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AadhaarCredential obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.aadhaarNumber)
      ..writeByte(2)
      ..write(obj.dob)
      ..writeByte(3)
      ..write(obj.frontImagePath)
      ..writeByte(4)
      ..write(obj.backImagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AadhaarCredentialAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PanCredentialAdapter extends TypeAdapter<PanCredential> {
  @override
  final int typeId = 5;

  @override
  PanCredential read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PanCredential(
      name: fields[0] as String,
      panNumber: fields[1] as String,
      dob: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PanCredential obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.panNumber)
      ..writeByte(2)
      ..write(obj.dob);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PanCredentialAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EmailCredentialAdapter extends TypeAdapter<EmailCredential> {
  @override
  final int typeId = 6;

  @override
  EmailCredential read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EmailCredential(
      username: fields[0] as String,
      password: fields[1] as String,
      provider: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, EmailCredential obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.password)
      ..writeByte(2)
      ..write(obj.provider);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmailCredentialAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CredentialTypeAdapter extends TypeAdapter<CredentialType> {
  @override
  final int typeId = 2;

  @override
  CredentialType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CredentialType.bank;
      case 1:
        return CredentialType.aadhaar;
      case 2:
        return CredentialType.pan;
      case 3:
        return CredentialType.email;
      default:
        return CredentialType.bank;
    }
  }

  @override
  void write(BinaryWriter writer, CredentialType obj) {
    switch (obj) {
      case CredentialType.bank:
        writer.writeByte(0);
        break;
      case CredentialType.aadhaar:
        writer.writeByte(1);
        break;
      case CredentialType.pan:
        writer.writeByte(2);
        break;
      case CredentialType.email:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CredentialTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
