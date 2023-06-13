// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';

class decoration_input_txt {
  String hint = '';
  double Border = 20;
  Icon icon = Icon(Icons.person);
  deco(Icon, String hint, double border) {
    this.Border = border;
    this.hint = hint;
    this.icon = Icon;
    return InputDecoration(
      prefixIcon: Icon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(border),
        ),
      ),
      hintText: hint,
    );
  }
}
