// ignore_for_file: camel_case_types, non_constant_identifier_names, avoid_init_to_null, unnecessary_this

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class awoseme_dialoge {
  var context = null;
  dynamic Duration = 0;
  dynamic DialogType = null;
  bool headerAnimationLoop = false;
  dynamic AnimType = null;
  String title = '';
  String desc = '';
  dynamic buttonsTextStyle = null;
  bool showCloseIcon = false;
  dynamic btnCancelOnPress = null;
  dynamic btnOkOnPress = null;
  dynamic btnOkColor = null;
  dynamic btnCancelColor = null;
  String btnCancelText = "";
  awoseme_dialoges(
    context,
    headerAnimationLoop,
    DialogType,
    Duration,
    AnimType,
    title,
    desc,
    buttonsTextStyle,
  ) {
    this.context = context;
    this.headerAnimationLoop = headerAnimationLoop;
    this.DialogType = DialogType;
    this.Duration = Duration;
    this.AnimType = AnimType;
    this.title = title;
    this.desc = desc;
    this.buttonsTextStyle = buttonsTextStyle;
    this.showCloseIcon = showCloseIcon;
    this.btnCancelOnPress = btnCancelOnPress;
    this.btnOkOnPress = btnOkOnPress;
    this.btnOkColor = btnOkColor;
    this.btnCancelText = btnCancelText;

    return AwesomeDialog(
      context: context,
      dialogType: DialogType,
      headerAnimationLoop: headerAnimationLoop,
      animType: AnimType,
      title: title,
      desc: desc,
      buttonsTextStyle: buttonsTextStyle,
      showCloseIcon: true,
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        const Color(0xffA5A5A5);
      },
    ).show();
  }
}
