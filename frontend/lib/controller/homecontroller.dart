import 'package:get/get.dart';

class homecontroller extends GetxController {
  String? mail;
  String password = '';
  void add(String mail, String password) {
    this.mail = mail;
    this.password = password;
    update();
  }
}
