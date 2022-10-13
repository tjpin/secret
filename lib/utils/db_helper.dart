// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart' as p;

// import '../imports.dart';


/////// THIS COMMENTED CODE WORKS WITH SQFLITE ////////////////
///////////////////////////////////////////////////////////////

// class DatabaseHelper with ChangeNotifier {
//   int count = 0;

//   static Future<String> getDbPath() async {
//     String dbPath = await getDatabasesPath();
//     String path = p.join(dbPath, 'accounts');
//     return path;
//   }

//   static String query =
//       "CREATE TABLE accounts (id INTEGER PRIMARY KEY, name TEXT, username TEXT, password TEXT, site TEXT, isImported INTEGER, isFavorite INTEGER)";

//   final db = openDatabase(getDbPath().toString(), version: 1,
//       onCreate: (Database db, int version) {
//     return db.execute(query);
//   });

//   Future<int> addAccount(Account account) async {
//     final _db = await db;
//     _db.insert('accounts', account.accountMap());
//     return 0;
//   }

//   Future<int> updateAccount(Account account) async {
//     final _db = await db;
//     _db.update('accounts', account.accountMap(),
//         where: 'id = ?', whereArgs: [account.id]);
//     return 0;
//   }

//   Future<void> setFavorite(Account account) async {
//     final _db = await db;
//     _db.update('accounts', account.accountMap(),
//         where: 'id = ?', whereArgs: [account.id]);
//     notifyListeners();
//   }

//   Future<List<Account>> getAccounts() async {
//     final _db = await db;
//     List<Account> accounts = [];

//     List<Map<String, Object?>> data = await _db.query('accounts');
//     return data
//         .map((e) => Account().fromMam(e))
//         .toList()
//         .where((element) => element.isImported == 1)
//         .toList();

//     // data.forEach((accountMap) {
//     //   accounts.add(Account().fromMam(accountMap));
//     // });
//     // return accounts.where((element) => element.isImported == 1).toList();
//   }

//   Future<List<Account>> getImportedAccounts() async {
//     final _db = await db;
//     List<Account> importedAcc = [];
//     List<Map<String, Object?>> data = await _db.query('accounts');
//     data.forEach((accountMap) {
//       importedAcc.add(Account().fromMam(accountMap));
//     });
//     return importedAcc.where((element) => element.isImported == 0).toList();
//   }

//   Future<void> deleteAccount(int id) async {
//     final _db = await db;
//     _db.rawDelete('DELETE FROM accounts WHERE id = ?', [id]);
//   }

//   Future<void> deleteAllImported() async {
//     final _db = await db;
//     _db.rawDelete('DELETE FROM accounts WHERE isImported = 0');
//   }

// // DB COUNTS
//   Future<int> getImportedCount() async {
//     final _db = await db;
//     count = Sqflite.firstIntValue(await _db
//         .rawQuery('SELECT COUNT(*) FROM accounts WHERE isImported = 0'))!;
//     return Sqflite.firstIntValue(await _db
//         .rawQuery('SELECT COUNT(*) FROM accounts WHERE isImported = 0'))!;
//   }

//   Future<int> getFavoriteCount() async {
//     final _db = await db;
//     return Sqflite.firstIntValue(await _db
//         .rawQuery('SELECT COUNT(*) FROM accounts WHERE isFavorite = 0'))!;
//   }

//   getAddedCount() async {
//     final _db = await db;
//     return Sqflite.firstIntValue(await _db
//         .rawQuery('SELECT COUNT(*) FROM accounts WHERE isImported = 1'));
//   }

//   Future<void> testCount() async {
//     count = await getImportedCount();
//   }
// }

