import 'package:flutter/material.dart';

class LoaderUtils {
  LoaderUtils._();

  static bool _isShowing = false;

  static void showLoader(BuildContext context) {
    if (_isShowing) return;

    _isShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) {
        return const Center(child: CircularProgressIndicator());
      },
    ).whenComplete(() {
      _isShowing = false;
    });
  }

  static void hideLoader(BuildContext context) {
    if (!_isShowing) return;

    _isShowing = false;

    Navigator.of(context, rootNavigator: true).pop();
  }
}
