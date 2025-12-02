import 'package:flutter/material.dart';

class PopupAction {
  final Function() action;
  final Icon icon;
  final String key;
  final String text;

  PopupAction({required this.action, required this.icon, required this.key, required this.text});
}
