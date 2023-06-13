import 'package:flutter/material.dart';

class LoggedInPage extends StatelessWidget {
  final String email;

  const LoggedInPage({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logged In'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              size: 100,
              color: Colors.green,
            ),
            const SizedBox(height: 20),
            Text(
              'You are logged in with:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              email,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

          ],
        ),
      ),
    );
  }
}