import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class MessageMixin {
  final scaffoldGlobalKey = GlobalKey<ScaffoldState>();

  showError(
          {@required String message,
          BuildContext context,
          GlobalKey<ScaffoldState> key}) =>
      _showSnackBar(context, message, key: key, color: Colors.red);

  showSuccess(
          {@required String message,
          BuildContext context,
          GlobalKey<ScaffoldState> key}) =>
      _showSnackBar(context, message,
          key: key, color: Theme.of(context).primaryColor);

  void _showSnackBar(BuildContext context, String message,
      {GlobalKey<ScaffoldState> key, Color color}) {
    final snackbar = SnackBar(
      backgroundColor: color,
      content: Text(message),
      behavior: SnackBarBehavior.floating,
    );

    if (key != null) {
      key.currentState.showSnackBar(snackbar);
    } else {
      Scaffold.of(context).showSnackBar(snackbar);
    }
  }
}
