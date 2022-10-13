import 'package:flutter/material.dart';

class AuthPinInput extends StatelessWidget {
  const AuthPinInput({
    Key? key,
    required this.cnt,
    required this.ctx,
  }) : super(key: key);

  final TextEditingController cnt;
  final ThemeData ctx;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: cnt,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      maxLines: 1,
      cursorColor: ctx.iconTheme.color,
      style: ctx.textTheme.bodyLarge,
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: ctx.colorScheme.error,
                  strokeAlign: StrokeAlign.inside)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: ctx.colorScheme.error,
                  strokeAlign: StrokeAlign.inside)),
          hintText: "Enter pin"),
      onChanged: (value) async {},
    );
  }
}
