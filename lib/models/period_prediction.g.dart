// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'period_prediction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PeriodPredictionAdapter extends TypeAdapter<PeriodPrediction> {
  @override
  final int typeId = 0;

  @override
  PeriodPrediction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PeriodPrediction(
      month: fields[0] as String,
      periodWindow: (fields[1] as List).cast<String>(),
      ovulation: fields[2] as String,
      fertileWindow: (fields[3] as List).cast<String>(),
      pmsWindow: (fields[4] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, PeriodPrediction obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.month)
      ..writeByte(1)
      ..write(obj.periodWindow)
      ..writeByte(2)
      ..write(obj.ovulation)
      ..writeByte(3)
      ..write(obj.fertileWindow)
      ..writeByte(4)
      ..write(obj.pmsWindow);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PeriodPredictionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
