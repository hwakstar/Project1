import 'package:flutter/material.dart';

class textstyle {
  String ch = '';
  var color = Colors.black;
  double size = 20;
  var weight = FontWeight.normal;

  textStyle(String ch, var color, double size, var weight) {
    this.ch = ch;
    this.color = color;
    this.size = size;
    this.weight = weight;
    return Text(ch,
        style: TextStyle(
          fontSize: size,
          fontWeight: weight,
          fontStyle: FontStyle.italic,
          color: color,
        ));
  }
}
