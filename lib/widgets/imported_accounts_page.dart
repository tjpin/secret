import 'package:fluttertoast/fluttertoast.dart';
import 'package:password_manager/imports.dart';

class ImportedAccountsPage extends StatefulWidget {
  const ImportedAccountsPage({Key? key}) : super(key: key);

  @override
  State<ImportedAccountsPage> createState() => _ImportedAccountsPageState();
}

class _ImportedAccountsPageState extends State<ImportedAccountsPage> {
  List<Account> importedAccounts = [];
  String file = '';
  int importedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ctx = Theme.of(context);
    return ValueListenableBuilder<Box<Account>>(
        valueListenable: DbAccess.getAccount().listenable(),
        builder: (context, box, _) {
          box.isNotEmpty
              ? importedAccounts = box.values
                  .where((element) => element.isImported == true)
                  .toList()
                  .sublist(1)
              : [];
          return importedAccounts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                          onPressed: () {
                            deleteImportedAccounts();
                            FilePicker.platform.pickFiles(
                                allowedExtensions: ['csv'],
                                type: FileType.custom,
                                dialogTitle:
                                    'Select Password file.').then((value) {
                              setState(() {
                                file = value!.files.first.path!;
                              });
                              readImportedData(
                                  file,
                                  () => setState(() {}),
                                  () => loaderOverlay(context),
                                  importedAccounts);
                            });
                          },
                          icon: const Icon(Icons.import_export),
                          label: const Text('Import Browser Accounts')),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: importedAccounts.length,
                  controller: ScrollController(),
                  itemBuilder: (context, i) => ListTile(
                        title: Text(
                          importedAccounts[i].name!,
                          style: ctx.textTheme.bodyMedium,
                        ),
                        subtitle: Text(importedAccounts[i].username!,
                            style: ctx.textTheme.bodyMedium!.copyWith(
                                color: ctx.iconTheme.color!.withOpacity(0.7))),
                        selected: importedIndex == i ? true : false,
                        leading: CircleAvatar(
                            radius: 25,
                            backgroundColor: ctx.primaryColor,
                            child: Text(
                              importedAccounts[i]
                                  .username!
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: ctx.textTheme.bodyLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            )),
                        trailing: IconButton(
                          onPressed: () {
                            setState(() {
                              DbAccessHelper()
                                  .setFavoriteAccount(importedAccounts[i]);
                            });
                          },
                          icon: importedAccounts[i].isFavorite == false
                              ? const Icon(Icons.favorite_border_outlined,
                                  size: 15)
                              : const Icon(Icons.favorite, size: 15),
                          splashRadius: 25,
                        ),
                        onTap: () {
                          print(importedAccounts[i].site);
                          Fluttertoast.showToast(
                              msg: 'Long press for details',
                              toastLength: Toast.LENGTH_SHORT);
                          setState(() {
                            importedIndex = i;
                          });
                        },
                        onLongPress: () =>
                            showDetails(context, ctx, importedAccounts[i]),
                      ));
        });
  }
}
