/////// COMMENTED CLASS WORKS WITH SQFLITE ////////
///////////////////////////////////////////////////

// class Account {
//   int? id;
//   String? name;
//   String? site;
//   String? username;
//   String? password;
//   int isFavorite;
//   int isImported;

//   Account(
//       {this.id,
//       this.name,
//       this.site,
//       this.username,
//       this.password,
//       this.isFavorite = 1,
//       this.isImported = 1});

//   Map<String, dynamic> accountMap() {
//     return {
//       'id': id,
//       'name': name,
//       'username': username,
//       'password': password,
//       'site': site,
//       'isFavorite': isFavorite,
//       'isImported': isImported
//     };
//   }

//   Account fromMam(Map<String, dynamic> json) {
//     return Account(
//         id: json['id'],
//         name: json['name'],
//         username: json['username'],
//         password: json['password'],
//         site: json['site'],
//         isFavorite: json['isFavorite'],
//         isImported: json['isImported']);
//   }

//   @override
//   String toString() {
//     return 'Account{id: $id, name: $name, username: $username, password: $password, site: $site, isFavorite: $isFavorite, isImported: $isImported}';
//   }
// }

import 'package:hive/hive.dart';

part 'account.g.dart';

@HiveType(typeId: 0)
class Account extends HiveObject{
  @HiveField(0)
  String? name;
  @HiveField(1)
  String? username;
  @HiveField(2)
  String? password;
  @HiveField(3)
  DateTime? dateAdded;
  @HiveField(4)
  bool isFavorite;
  @HiveField(5)
  bool isImported;
  @HiveField(6)
  String? site;
  @HiveField(7)
  int? id;

  Account(
      {
      this.name,
      this.username,
      this.password,
      this.dateAdded,
      this.site,
      this.id,
      this.isImported = false,
      this.isFavorite = false});
}
