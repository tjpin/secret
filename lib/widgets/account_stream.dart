import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:password_manager/imports.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:password_manager/utils/auth.dart';

import '../widgets/edit_account_dialog.dart';

class AccountStream extends StatefulWidget {
  const AccountStream({Key? key}) : super(key: key);

  @override
  State<AccountStream> createState() => _AccountStreaamState();
}

class _AccountStreaamState extends State<AccountStream> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _siteController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  List<Account> accounts = [];

  int selectedTileIndex = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _siteController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctx = Theme.of(context);
    return ValueListenableBuilder<Box<Account>>(
        valueListenable: DbAccess.getAccount().listenable(),
        builder: (context, box, _) {
          box.isNotEmpty
              ? accounts = box.values
                  .where((element) => element.isImported == false)
                  .toList()
              : [];
          return accounts.isEmpty
              ? Center(
                  child: TextButton.icon(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => AddAccountDialog(
                                  refresh: () => setState(() {}),
                                  nameController: _nameController,
                                  usernameController: _usernameController,
                                  siteController: _siteController,
                                  passwordController: _passwordController,
                                ));
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add Accounts')))
              : RefreshIndicator(
                  onRefresh: () async {},
                  color: ctx.iconTheme.color,
                  child: ListView.builder(
                      itemCount: accounts.length,
                      itemBuilder: (context, i) => Slidable(
                          direction: Axis.horizontal,
                          dragStartBehavior: DragStartBehavior.start,
                          closeOnScroll: true,
                          key: UniqueKey(),
                          startActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              extentRatio: 0.3,
                              children: [
                                const SizedBox(
                                  width: 5,
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => EditAccountDialog(
                                              refresh: () => setState(() {}),
                                              acc: accounts[i],
                                              nameController: _nameController,
                                              usernameController:
                                                  _usernameController,
                                              passwordController:
                                                  _passwordController,
                                              siteController: _siteController,
                                            ));
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    size: 20,
                                  ),
                                  splashRadius: 25,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      DbAccess.getAccount()
                                          .delete(accounts[i].key);
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    size: 20,
                                  ),
                                  splashRadius: 25,
                                ),
                              ]),
                          child: ListTile(
                            title: Text(
                              accounts[i].name!,
                              style: ctx.textTheme.bodyMedium,
                            ),
                            subtitle: Text(accounts[i].username!,
                                style: ctx.textTheme.bodyMedium!.copyWith(
                                    color:
                                        ctx.iconTheme.color!.withOpacity(0.7))),
                            selected: selectedTileIndex == i ? true : false,
                            leading: CircleAvatar(
                                radius: 25,
                                backgroundColor: ctx.primaryColor,
                                child: Text(
                                  accounts[i]
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
                                      .setFavoriteAccount(accounts[i]);
                                });
                              },
                              icon: accounts[i].isFavorite == false
                                  ? const Icon(Icons.favorite_border_outlined,
                                      size: 15)
                                  : const Icon(Icons.favorite, size: 15),
                              splashRadius: 25,
                            ),
                            onLongPress: () =>
                                showDetails(context, ctx, accounts[i]),
                            onTap: () {
                              Fluttertoast.showToast(
                                  msg: 'Long press for details');
                              setState(() {
                                selectedTileIndex = i;
                              });
                            },
                          ))),
                );
        });
  }
}

class DetailCard extends StatelessWidget {
  String content;
  String label;
  IconData icon;
  DetailCard({
    Key? key,
    required this.content,
    required this.label,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctx = Theme.of(context);
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label),
          InkWell(
            onTap: () {
              Clipboard.setData(ClipboardData(text: content));
              Fluttertoast.showToast(msg: '$label Copied to clipboard');
            },
            child: Chip(
                backgroundColor: ctx.primaryColor.withAlpha(10),
                avatar: Icon(
                  icon,
                  size: 18,
                  color: ctx.iconTheme.color!.withOpacity(0.5),
                ),
                label: Text(
                  content,
                  style: ctx.textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                )),
          )
        ]),
      ),
    );
  }
}
