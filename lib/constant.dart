import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

const hightLightTextColor = Color.fromRGBO(100, 116, 139, 1);
const hintTextColor = Color.fromRGBO(159, 177, 199, 1);
const greyText = Color.fromRGBO(93, 97, 112, 1);
const textFieldColor = Color(0xffDDE7F3);

/// Flashes an error message on the top of the screen.
void errorUpMessage(BuildContext context, String text, String title) {
  final primaryColor = Theme.of(context).primaryColor;
  Flushbar(
    title: title,
    message: text,
    duration: const Duration(seconds: 2),
    backgroundColor: Colors.red,
    flushbarPosition: FlushbarPosition.TOP,
  ).show(context);
}
