import 'package:password_manager/imports.dart';
import 'dart:convert';

import '../widgets/account_stream.dart';
import 'auth.dart';

// Show loading or progress overlay
void loaderOverlay(BuildContext context) {
  Loader.show(context,
      progressIndicator: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(
              height: 10,
            ),
            Text("Importing...")
          ],
        ),
      ));
  Future.delayed(const Duration(seconds: 1)).then((value) => Loader.hide());
}

Future<List<List<dynamic>>> readCsvData(String filePath) async {
  final csv = File(filePath).openRead();
  return await csv
      .transform(utf8.decoder)
      .transform(
        const CsvToListConverter(),
      )
      .toList();
}

Future<void> readImportedData(String file, Function setState,
    Function loaderOverlay, List<Account> importedAccounts) async {
  readCsvData(file).then((items) {
    List<List<dynamic>> nlist =
        items.map((e) => e.where((i) => i != '').toList()).toList();
    final accountsList =
        nlist.where((list) => list.isNotEmpty && list.length == 4);
    final loadedAccounts = accountsList.where(
        (element) => element[3] != importedAccounts.contains(element[3]));
    // EXPECTED VALUES: name, url, username, password
    for (var accounts in loadedAccounts) {
      Account ac = Account()
        ..name = accounts[0].toString()
        ..site = accounts[1].toString()
        ..username = accounts[2].toString()
        ..password = accounts[3].toString()
        ..isFavorite = false
        ..isImported = true;
      DbAccess.getAccount().add(ac);
      loaderOverlay();
      setState();
    }
  });
}

Future showDetails(BuildContext context, ThemeData ctx, Account acc) async {
  if (!await AuthHelper.authenticate()) {
    return;
  }
  showModalBottomSheet(
      context: context,
      constraints: const BoxConstraints(maxHeight: 350),
      backgroundColor: ctx.primaryColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      builder: (context) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Chip(
                    label: Text(acc.name!),
                    avatar: const Icon(Icons.account_circle),
                  ),
                ),
                DetailCard(
                  label: 'Username/ Email:',
                  content: acc.username!,
                  icon: Icons.email,
                ),
                DetailCard(
                  label: 'Account Password:',
                  content: acc.password!,
                  icon: Icons.password,
                ),
                DetailCard(
                  label: 'Site Url:',
                  content: acc.site.toString() == 'null'
                      ? 'No link'
                      : acc.site.toString(),
                  icon: Icons.link_rounded,
                ),
              ],
            ),
          ));
}

void deleteImportedAccounts() {
  DbAccess.getAccount().toMap().forEach((key, value) {
    if (!value.isImported) {
      return;
    }
    DbAccess.getAccount().delete(key);
  });
}

void deleteAllAccounts() {
  DbAccess.getAccount().clear();
}

Future<dynamic> accountsDeleteDialog(
    BuildContext context, Function deleteCalback, String title) {
  return showDialog(
      context: context,
      builder: (context) => Dialog(
            child: Container(
              height: 150,
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Delete $title ?',
                    textAlign: TextAlign.center,
                  ),
                  const Center(
                      child: Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 35,
                  )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel')),
                      TextButton(
                          onPressed: () => deleteCalback(),
                          child: const Text('Delete')),
                    ],
                  )
                ],
              ),
            ),
          ));
}

void clearImportedAccounts(BuildContext context) {
  Loader.show(context,
      progressIndicator: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(
              height: 10,
            ),
            Text("Deleting...")
          ],
        ),
      ));
  Future.delayed(const Duration(seconds: 1)).then((value) => Loader.hide());
}

int getAddedAccountsCount() {
  return DbAccess.getAccount()
      .values
      .where((element) => element.isImported == false)
      .toList()
      .length;
}

int getFavAccountsCount() {
  return DbAccess.getAccount()
      .values
      .where((element) => element.isFavorite == true)
      .toList()
      .length;
}

int getImportedAccountsCount() {
  return DbAccess.getAccount()
      .values
      .where((element) => element.isImported == true)
      .toList()
      .length;
}
