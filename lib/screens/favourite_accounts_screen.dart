import 'package:fluttertoast/fluttertoast.dart';
import 'package:password_manager/imports.dart';

class FavoriteAccountsScreen extends StatefulWidget {
  const FavoriteAccountsScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteAccountsScreen> createState() => _FavoriteAccountsScreenState();
}

class _FavoriteAccountsScreenState extends State<FavoriteAccountsScreen> {
  int favoriteIndex = 0;
  List<Account> favoriteAccounts = [];

  @override
  Widget build(BuildContext context) {
    final ctx = Theme.of(context);
    return ValueListenableBuilder<Box<Account>>(
      valueListenable: DbAccess.getAccount().listenable(),
      builder: (context, box, _) {
        box.values.isNotEmpty
            ? favoriteAccounts = box.values
                .toList()
                .where((account) => account.isFavorite == true)
                .toList()
            : [];
        return favoriteAccounts.isEmpty
            ? const Center(child: Text("No favorited accounts"))
            : RefreshIndicator(
                onRefresh: () async {},
                child: ListView.builder(
                    itemCount: favoriteAccounts.length,
                    itemBuilder: (context, i) => ListTile(
                          selected: favoriteIndex == i ? true : false,
                          title: Text(
                            favoriteAccounts[i].name!,
                            style: ctx.textTheme.bodyMedium,
                          ),
                          subtitle: Text(
                            favoriteAccounts[i].username!,
                            style: ctx.textTheme.bodySmall!.copyWith(
                                color: ctx.iconTheme.color!.withOpacity(0.7)),
                          ),
                          onTap: () {
                            setState(() => favoriteIndex = i);
                            Fluttertoast.showToast(
                                msg: 'Long press for details');
                          },
                          onLongPress: () =>
                              showDetails(context, ctx, favoriteAccounts[i]),
                          trailing: IconButton(
                              onPressed: () {
                                setState(() {
                                  if (favoriteAccounts[i].isFavorite) {
                                    Account acc = Account()
                                      ..id = favoriteAccounts[i].id
                                      ..name = favoriteAccounts[i].name
                                      ..username = favoriteAccounts[i].username
                                      ..password = favoriteAccounts[i].password
                                      ..site = favoriteAccounts[i].site
                                      ..dateAdded =
                                          favoriteAccounts[i].dateAdded
                                      ..isFavorite = false
                                      ..isImported =
                                          favoriteAccounts[i].isImported;
                                    DbAccess.getAccount()
                                        .put(favoriteAccounts[i].key, acc);
                                  } else {
                                    Account acc = Account()
                                      ..id = favoriteAccounts[i].id
                                      ..name = favoriteAccounts[i].name
                                      ..username = favoriteAccounts[i].username
                                      ..password = favoriteAccounts[i].password
                                      ..site = favoriteAccounts[i].site
                                      ..dateAdded =
                                          favoriteAccounts[i].dateAdded
                                      ..isFavorite = true
                                      ..isImported =
                                          favoriteAccounts[i].isImported;
                                    DbAccess.getAccount()
                                        .put(favoriteAccounts[i].key, acc);
                                  }
                                });
                              },
                              icon: const Icon(
                                Icons.favorite,
                                size: 17,
                              ),
                              splashRadius: 20),
                        )),
              );
      },
    );
  }
}
