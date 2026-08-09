import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoaderUtils {
  LoaderUtils._();

  static void showLoader(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}