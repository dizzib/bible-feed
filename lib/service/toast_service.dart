import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ToastService {
  void _showToast({required String msg, required Color backgroundColor}) {
    final toastTimeSecs = 5;
    Fluttertoast.showToast(
      backgroundColor: backgroundColor,
      msg: msg,
      textColor: Colors.white,
      timeInSecForIosWeb: toastTimeSecs,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  void showError(String msg) {
    _showToast(msg: msg, backgroundColor: Colors.red);
  }

  void showOk(String msg) {
    _showToast(msg: msg, backgroundColor: Colors.green);
  }
}
