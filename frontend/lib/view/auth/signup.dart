// ignore_for_file: avoid_print, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../controller/homecontroller.dart';
import '../../model/commun/decoration.dart';
import '../../model/commun/text_style.dart';
import 'signin.dart';

bool isValidEmail(String email) {
  final RegExp regExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  return regExp.hasMatch(email);
}

// ignore: camel_case_types
class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

bool x = false;
bool p = true;

// ignore: camel_case_types
class _SignUpState extends State<SignUp> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController password = TextEditingController();


  Future<UserCredential?> signUpWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
    await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    try {
      // Create a new user with the Google credentials
      final UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: googleUser!.email,
        password: googleUser.id,
      );

      // Link the Google credential to the created user
      await userCredential.user?.linkWithCredential(credential);

      // Return the UserCredential
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use') {
        print('The Google account is already linked to another user.');
        // You can handle this case as per your requirement.
      }
      // Return null if sign up with Google fails
      return null;
    } catch (e) {
      print('Error occurred during Google sign up: $e');
      // Return null if sign up with Google fails
      return null;
    }
  }

  Future<UserCredential?> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'your_client_id',
          redirectUri: Uri.parse('your_redirect_uri'),
        ),
      );

      // Handle the Apple ID credential and sign in the user
      // ...

      return null; // Return the UserCredential if available
    } catch (e) {
      print('Sign in with Apple error: $e');
      return null; // Return null if sign in with Apple fails
    }
  }



  @override
  Widget build(BuildContext context) {
    var mwd = MediaQuery.of(context).size.width;
    var mhd = MediaQuery.of(context).size.height;
    var inputDecoration = InputDecoration(
      prefixIcon: const Icon(Icons.lock),
      suffixIcon: IconButton(
        icon: Icon(

          p ? Icons.visibility : Icons.visibility_off,
          color:  Colors.black,
        ),
        onPressed: () {
          setState(() {
            p = !p;
          });
        },
      ),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      hintText: 'Enter your password',
    );
    return Scaffold(
      body: Stack(
          children: [
            Container(
              height: mhd,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/image/backg1.gif', ),
                  fit: BoxFit.fill,


                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: 350,
                child: ListView(

                  children: [
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 100),
                        child: textstyle().textStyle(
                          "Create Account",
                          Colors.black,
                          40,
                          FontWeight.w900,
                        ),
                      ),
                    ),
                    Form(
                      key: formstate,
                      child: GetBuilder<homecontroller>(
                        init: homecontroller(),
                        builder: (controller) => Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              controller: username,
                              validator: (value) {
                                if (value!.isEmpty ||
                                    value.length < 3 ||
                                    value.length > 7) {
                                  return "Please enter your name";
                                }
                                return null;
                              },
                              decoration: decoration_input_txt().deco(
                                Icon(Icons.person),
                                "Enter your name",
                                20.0,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: email,
                              decoration: decoration_input_txt().deco(
                                Icon(Icons.email),
                                "Enter your email",
                                20.0,
                              ),
                              validator: (value) {
                                if (value!.isEmpty || !isValidEmail(value)) {
                                  return "Please enter a valid email";
                                }
                                return null;
                              },
                            ),


                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: password,
                              obscureText: p,
                              decoration: inputDecoration,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    GetBuilder<homecontroller>(
                      builder: (controller) =>
                          Container(
                            margin: const EdgeInsets.only(top: 20, left: 50, right: 50),
                            height: 50,
                            width: 150,
                            child: ElevatedButton(
                              onPressed: (() async {
                                var formdata = formstate.currentState;
                                if (formdata!.validate()) {
                                  try {
                                    final credential =
                                    await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                      email: email.text,
                                      password: password.text,
                                    );
                                    CollectionReference usersRef =
                                    FirebaseFirestore.instance
                                        .collection('users');
                                    usersRef.doc(email.text).set({
                                      'name': username.text,
                                      'email': email.text,
                                      'phone': phone.text,
                                      'password': password.text,
                                    });

                                    if (credential.user != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => login(),
                                        ),
                                      );
                                    }
                                  } on FirebaseAuthException catch (e) {
                                    if (e.code == 'weak-password') {
                                      AwesomeDialog(
                                        context: context,
                                        autoHide: const Duration(seconds: 3),
                                        dialogType: DialogType.error,
                                        headerAnimationLoop: false,
                                        animType: AnimType.scale,
                                        title: 'Warning',
                                        desc: 'Password is too weak',
                                        buttonsTextStyle: const TextStyle(
                                          color: Color.fromARGB(255, 172, 29, 29),
                                        ),
                                        showCloseIcon: true,
                                        btnCancelOnPress: () {},
                                        btnOkOnPress: () {
                                          const Color(0xffA5A5A5);
                                        },
                                      ).show();
                                    } else if (e.code == 'email-already-in-use') {
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.error,
                                        headerAnimationLoop: false,
                                        animType: AnimType.scale,
                                        title: 'Warning',
                                        desc: 'Email already in use',
                                        buttonsTextStyle:
                                        const TextStyle(color: Colors.black),
                                        showCloseIcon: true,
                                        btnCancelOnPress: () {},
                                        btnOkOnPress: () {
                                          const Color(0xffA5A5A5);
                                        },
                                      ).show();
                                    }
                                  } catch (e) {
                                    print(e);
                                  }
                                }
                              }),
                              style: ElevatedButton.styleFrom(

                                  backgroundColor: Colors.blue
                              ),
                              child: const Text(
                                'Sign up',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: mwd * 0.3,
                        ),
                        SizedBox(height: 20,),
                        Container(
                          height: 50,
                          width: 250,
                          child: ElevatedButton(
                            onPressed: () async {
                              UserCredential? cred = await signUpWithGoogle();
                              if (cred?.user != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => login(),
                                  ),
                                );
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  child : Image.asset("assets/image/google_icon.png", scale : 4),

                                ),
                                SizedBox(width: 30,),
                                Text("Sign up with google", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black),)
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,

                        ),
                        Container(
                          height: 50,
                          width: 250,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black
                              ),

                              onPressed: () async {
                                UserCredential? cred =  await signInWithApple();
                                if (cred?.user != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => login(),
                                    ),
                                  );
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    child : Image.asset("assets/image/apple_icon.png", scale : 2, color: Colors.white, ),
                                    color: Colors.black,
                                  ),
                                  SizedBox(width: 30,),
                                  Text("Sign up with apple", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),)
                                ],
                              )
                          ),
                        ),


                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Get.to(() => login());
                      },
                      child: const Text("Already have an account?"),
                    ),
                  ],
                ),
              ),
            ),
          ] ),


    );
  }
}
