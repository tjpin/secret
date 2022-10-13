// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CardDataAdapter extends TypeAdapter<CardData> {
  @override
  final int typeId = 1;

  @override
  CardData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CardData(
      name: fields[0] as String?,
      cardNumber: fields[1] as int?,
      cardCvv: fields[2] as int?,
      expiryDate: fields[3] as String?,
      cardType: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CardData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.cardNumber)
      ..writeByte(2)
      ..write(obj.cardCvv)
      ..writeByte(3)
      ..write(obj.expiryDate)
      ..writeByte(4)
      ..write(obj.cardType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
