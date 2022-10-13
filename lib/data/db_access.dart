import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:password_manager/data/account.dart';
import 'package:password_manager/data/card_data.dart';

class DbAccess {
  static Box<CardData> getCards() => Hive.box<CardData>('cards');
  static Box<Account> getAccount() => Hive.box<Account>('accounts');
}
