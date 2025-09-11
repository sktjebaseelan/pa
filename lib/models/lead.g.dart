// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lead.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LeadAdapter extends TypeAdapter<Lead> {
  @override
  final int typeId = 5;

  @override
  Lead read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Lead(
      id: fields[0] as String,
      candidateName: fields[1] as String,
      companyName: fields[2] as String,
      persons: fields[3] as int,
      address: fields[4] as String,
      pincode: fields[5] as String,
      lat: fields[6] as double,
      long: fields[7] as double,
      tentativeDate: fields[8] as DateTime,
      scheduledDate: fields[9] as DateTime?,
      status: fields[10] as LeadStatus,
      assigneeId: fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Lead obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.candidateName)
      ..writeByte(2)
      ..write(obj.companyName)
      ..writeByte(3)
      ..write(obj.persons)
      ..writeByte(4)
      ..write(obj.address)
      ..writeByte(5)
      ..write(obj.pincode)
      ..writeByte(6)
      ..write(obj.lat)
      ..writeByte(7)
      ..write(obj.long)
      ..writeByte(8)
      ..write(obj.tentativeDate)
      ..writeByte(9)
      ..write(obj.scheduledDate)
      ..writeByte(10)
      ..write(obj.status)
      ..writeByte(11)
      ..write(obj.assigneeId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LeadAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
