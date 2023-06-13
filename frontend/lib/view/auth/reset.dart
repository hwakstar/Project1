// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, deprecated_member_use

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/view/auth/signin.dart';
import 'package:get/get.dart';

import '../../controller/homecontroller.dart';
import '../../model/commun/awoseme_dialoge.dart';
import '../../model/commun/decoration.dart';

bool isValidEmail(String email) {
  final RegExp regExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  return regExp.hasMatch(email);
}

class RestPassword extends StatefulWidget {
  const RestPassword({Key? key}) : super(key: key);

  @override
  State<RestPassword> createState() => _RestPasswordState();
}

class _RestPasswordState extends State<RestPassword> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController mail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var mwd = MediaQuery.of(context).size.width;
    var mhd = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: mhd,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/image/backg1.gif'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 100, left: 20),
                    child: Text(
                      'Reset Your Password',
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.w600,
                          fontSize: 30),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Email',
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.w500,
                          fontSize: 17),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: formstate,
                    child: Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "your email please";
                          }
                        },
                        controller: mail,
                        onSaved: (value) {
                          mail.text = value!;
                        },
                        decoration: decoration_input_txt()
                            .deco(Icon(Icons.email), "Enter your email", 20.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Color.fromARGB(255, 252, 252, 252),
                            backgroundColor: Color.fromARGB(255, 47, 176, 58),
                            fixedSize: const Size(200, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () async {
                            var formdata = formstate.currentState;
                            if (formdata!.validate()) {
                              try {
                                await FirebaseAuth.instance
                                    .sendPasswordResetEmail(email: mail.text);

                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.SUCCES,
                                  animType: AnimType.BOTTOMSLIDE,
                                  title: 'success',
                                  desc: 'check your email',
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () {
                                    Get.to(() => const login());
                                  },
                                ).show();
                              } catch (e) {
                                awoseme_dialoge().awoseme_dialoges(
                                  context,
                                  false,
                                  DialogType.warning,
                                  7,
                                  AnimType.scale,
                                  "warning",
                                  "no user found for that email",
                                  TextStyle(
                                      color: Color.fromARGB(255, 172, 29, 41)),
                                );
                              }
                            }
                          },
                          child: const Text('Send'))),
                ]),
          ],
        ),
      ),
    );
  }
}
