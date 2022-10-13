import 'package:password_manager/imports.dart';

class DbAccessHelper {
  void setFavoriteAccount(Account account) {
    if (account.isFavorite == true) {
      Account acc = Account()
        ..id = account.id
        ..name = account.name
        ..username = account.username
        ..password = account.password
        ..dateAdded = account.dateAdded
        ..site = account.site
        ..isFavorite = false
        ..isImported = account.isImported;
      DbAccess.getAccount().put(account.key, acc);
    } else {
      Account acc = Account()
        ..id = account.id
        ..name = account.name
        ..username = account.username
        ..password = account.password
        ..dateAdded = account.dateAdded
        ..site = account.site
        ..isFavorite = true
        ..isImported = account.isImported;
      DbAccess.getAccount().put(account.key, acc);
    }
  }
}
