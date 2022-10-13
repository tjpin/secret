import 'package:fluttertoast/fluttertoast.dart';
import 'package:password_manager/imports.dart';

import 'account_stream.dart';

class AddedAccountsPage extends StatefulWidget {
  const AddedAccountsPage({Key? key}) : super(key: key);

  @override
  State<AddedAccountsPage> createState() => _AddedAccountsPageState();
}

class _AddedAccountsPageState extends State<AddedAccountsPage> {
  int selectedIndex = 0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final ctx = Theme.of(context);
    return const AccountStream();
  }

  Future<dynamic> accountBottomSheet(
      BuildContext context, ThemeData ctx, Account ac) {
    return showModalBottomSheet(
        context: context,
        backgroundColor: ctx.primaryColor,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        builder: (context) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      IconButton(
                          onPressed: () => Navigator.of(context).pop(context),
                          icon: const Icon(Icons.close),
                          splashRadius: 25),
                    ],
                  ),
                  Chip(label: Text(ac.name!)),
                  ModalItem(
                    label: "Username",
                    text: ac.username!,
                    ctx: ctx,
                  ),
                  ModalItem(
                    label: "Password",
                    text: ac.password!,
                    ctx: ctx,
                  ),
                  ModalItem(
                    label: "Site Link",
                    text: ac.site ?? '',
                    ctx: ctx,
                  ),
                ],
              ),
            ));
  }
}

class ModalItem extends StatelessWidget {
  ThemeData ctx;
  String label;
  String text;
  ModalItem(
      {Key? key, required this.label, required this.text, required this.ctx})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: ctx.textTheme.bodyMedium!.copyWith(
                color: ctx.textTheme.bodyMedium!.color!.withOpacity(0.6)),
          ),
          InkWell(
              borderRadius: BorderRadius.circular(30),
              splashColor: ctx.primaryColor,
              onTap: () {
                Fluttertoast.showToast(msg: "$label copied ✔");
              },
              child: Chip(
                  avatar: Icon(
                    Icons.copy,
                    size: 16,
                    color: ctx.iconTheme.color!.withOpacity(0.5),
                  ),
                  label: Text(
                    text,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                  )))
        ],
      ),
    );
  }
}
