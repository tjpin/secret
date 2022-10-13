import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:password_manager/imports.dart';

class EditAccountDialog extends StatefulWidget {
  Function refresh;
  Account acc;
  TextEditingController nameController;
  TextEditingController usernameController;
  TextEditingController siteController;
  TextEditingController passwordController;

  // bool favoritedValue = false;
  EditAccountDialog(
      {Key? key,
      required this.acc,
      required this.refresh,
      required this.nameController,
      required this.usernameController,
      required this.siteController,
      required this.passwordController})
      : super(key: key);

  @override
  State<EditAccountDialog> createState() => _AddAccountDialogState();
}

class _AddAccountDialogState extends State<EditAccountDialog> {
  bool validateInputs(BuildContext ctx) {
    if (widget.nameController.text.isEmpty ||
        widget.usernameController.text.isEmpty ||
        widget.passwordController.text.isEmpty) {
      return false;
    }
    return true;
  }

  Future<void> _editAccount(BuildContext ctx) async {
    if (validateInputs(ctx)) {
      Account account = Account()
        ..name = widget.nameController.text
        ..username = widget.usernameController.text
        ..password = widget.passwordController.text
        ..site =
            widget.siteController.text.isEmpty ? "" : widget.siteController.text
        ..isFavorite = widget.acc.isFavorite;
      DbAccess.getAccount().put(widget.acc.key, account);
      widget.refresh();
      Navigator.of(ctx).pop(ctx);
    } else {
      Fluttertoast.showToast(
          backgroundColor: Colors.red,
          textColor: Colors.white,
          msg: 'All fields are required');
    }
  }

  @override
  void initState() {
    widget.nameController.text = widget.acc.name!;
    widget.usernameController.text = widget.acc.username!;
    widget.passwordController.text = widget.acc.password!;
    widget.siteController.text = widget.acc.site ?? "";
    super.initState();
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
            const Chip(label: Text("Edit Account")),
            const SizedBox(
              height: 10,
            ),
            EdtiField(
                ctx: ctx,
                hint: 'Account Name',
                controller: widget.nameController),
            EdtiField(
                ctx: ctx,
                hint: 'Username',
                controller: widget.usernameController),
            EdtiField(
                ctx: ctx,
                hint: 'SIte Link - Optional',
                controller: widget.siteController),
            EdtiField(
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
              value: widget.acc.isFavorite == false ? false : true,
              selected: widget.acc.isFavorite == false ? false : true,
              onChanged: (v) => setState(() {
                v! == true ? widget.acc.isFavorite = true : false;
              }),
              title: const Text('Make Favorite'),
              activeColor: Colors.orange,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                dialogButton(ctx, "Cancel", Icons.cancel,
                    () => Navigator.of(context).pop(context)),
                dialogButton(ctx, "Edit Account", Icons.update,
                    () => _editAccount(context)),
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

class EdtiField extends StatelessWidget {
  const EdtiField({
    Key? key,
    required this.ctx,
    required this.hint,
    required this.controller,
    this.maxLength = 30,
    this.minLength = 16,
    this.formaters = const [],
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  final ThemeData ctx;
  final String hint;
  final int maxLength;
  final int minLength;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final List<TextInputFormatter> formaters;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: TextField(
        textAlign: TextAlign.center,
        controller: controller,
        style: ctx.textTheme.bodyMedium,
        inputFormatters: [],
        maxLength: maxLength,
        keyboardType: keyboardType,
        decoration: InputDecoration(
            hintText: hint,
            isDense: true,
            counterText: '',
            focusedBorder: OutlineInputBorder(
                gapPadding: 0, borderRadius: BorderRadius.circular(25)),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 0.5),
                gapPadding: 0,
                borderRadius: BorderRadius.circular(5))),
        // controller: textController,
      ),
    );
  }
}
