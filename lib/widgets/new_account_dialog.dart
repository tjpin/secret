import 'package:fluttertoast/fluttertoast.dart';
import 'package:password_manager/imports.dart';

class AddAccountDialog extends StatefulWidget {
  Function refresh;
  TextEditingController nameController;
  TextEditingController usernameController;
  TextEditingController siteController;
  TextEditingController passwordController;

  bool favoritedValue = false;
  AddAccountDialog(
      {Key? key,
      required this.refresh,
      required this.nameController,
      required this.usernameController,
      required this.siteController,
      required this.passwordController})
      : super(key: key);

  @override
  State<AddAccountDialog> createState() => _AddAccountDialogState();
}

class _AddAccountDialogState extends State<AddAccountDialog> {
  var favoritedValue = false;

  void clearFields() {
    widget.nameController.clear();
    widget.usernameController.clear();
    widget.passwordController.clear();
    widget.siteController.clear();
  }

  bool validateInputs(BuildContext ctx) {
    if (widget.nameController.text.isEmpty ||
        widget.usernameController.text.isEmpty ||
        widget.passwordController.text.isEmpty) {
      return false;
    }
    return true;
  }

  Future<void> _addAccount(BuildContext ctx) async {
    if (validateInputs(ctx)) {
      Account account = Account()
        ..id = int.parse(
            DateTime.now().microsecondsSinceEpoch.toString().substring(10))
        ..name = widget.nameController.text
        ..username = widget.usernameController.text
        ..password = widget.passwordController.text
        ..site =
            widget.siteController.text.isEmpty ? "" : widget.siteController.text
        ..isFavorite = favoritedValue;
      DbAccess.getAccount().put(account.id, account);
      widget.refresh();
      Navigator.of(ctx).pop(ctx);
      clearFields();
    } else {
      Fluttertoast.showToast(
          backgroundColor: Colors.red,
          textColor: Colors.white,
          msg: 'All fields are required');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ctx = Theme.of(context);
    return Dialog(
      backgroundColor: ctx.primaryColor,
      child: Container(
        height: 400,
        padding: const EdgeInsets.all(10),
        width: size.width - 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: ctx.primaryColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Chip(label: Text("Add New Account")),
            const SizedBox(
              height: 10,
            ),
            InputField(
                ctx: ctx,
                hint: 'Account Name',
                controller: widget.nameController),
            InputField(
                ctx: ctx,
                hint: 'Username',
                controller: widget.usernameController),
            InputField(
                ctx: ctx,
                hint: 'SIte Link - Optional',
                controller: widget.siteController),
            InputField(
                ctx: ctx,
                hint: 'Password',
                controller: widget.passwordController),
            const SizedBox(
              height: 20,
            ),
            CheckboxListTile(
              checkboxShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              value: favoritedValue == false ? false : true,
              selected: favoritedValue == false ? false : true,
              onChanged: (v) => setState(() {
                v! == true ? favoritedValue = true : false;
              }),
              title: const Text('Make Favorite'),
              activeColor: Colors.orange,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                dialogButton(ctx, "Cancel", Icons.cancel,
                    () => Navigator.of(context).pop(context)),
                dialogButton(
                    ctx, "Add Account", Icons.add, () => _addAccount(context)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

TextButton dialogButton(
    ThemeData ctx, String lable, IconData icon, Function callBack) {
  return TextButton.icon(
      style: ctx.textButtonTheme.style,
      onPressed: () => callBack(),
      icon: Icon(icon),
      label: Text(lable));
}
