import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontend/view/auth/signin.dart';
import 'package:get/get.dart';

import 'view/auth/reset.dart';

/*import 'package:stfore/page02.dart';*/

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/page',
      theme: ThemeData(primaryColor: Color.fromARGB(255, 255, 20, 20)),
      getPages: [
        GetPage(name: '/page', page: () => const login()),
      ],
    );
  }
}
