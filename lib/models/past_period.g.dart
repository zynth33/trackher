// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'past_period.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PastPeriodAdapter extends TypeAdapter<PastPeriod> {
  @override
  final int typeId = 1;

  @override
  PastPeriod read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PastPeriod(
      pastPeriods: (fields[0] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, PastPeriod obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.pastPeriods);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PastPeriodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
