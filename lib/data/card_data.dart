import 'package:hive/hive.dart';

part 'card_data.g.dart';

@HiveType(typeId: 1)
class CardData extends HiveObject {
  @HiveField(0)
  String? name;
  @HiveField(1)
  int? cardNumber;
  @HiveField(2)
  int? cardCvv;
  @HiveField(3)
  String? expiryDate;
  @HiveField(4)
  String cardType = "Default";

  CardData({this.name, this.cardNumber, this.cardCvv, this.expiryDate, this.cardType = 'Default'});
}
