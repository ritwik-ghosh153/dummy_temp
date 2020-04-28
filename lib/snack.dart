import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnack(
    BuildContext context, String notification) {
  return Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(
      notification,
      style: TextStyle(
          letterSpacing: 2, fontSize: 16, fontWeight: FontWeight.w600),
    ),
    duration: Duration(milliseconds: 2000),
    backgroundColor: Colors.grey[500],
  ));
}
