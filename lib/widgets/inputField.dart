import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatelessWidget {
  InputField({
    Key? key,
    required this.ctx,
    required this.hint,
    required this.controller,
    this.maxLength = 30,
    this.minLength = 16,
    this.isPassword = false,
    this.formaters,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  final ThemeData ctx;
  final String hint;
  final int maxLength;
  final int minLength;
  final bool isPassword;
  final TextEditingController controller;
  final TextInputType keyboardType;
  List<TextInputFormatter>? formaters;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: TextField(
        textAlign: TextAlign.center,
        controller: controller,
        style: ctx.textTheme.bodyMedium,
        inputFormatters: [],
        obscureText: isPassword,
        maxLength: maxLength,
        keyboardType: keyboardType,
        cursorColor: ctx.iconTheme.color,
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
