import 'package:flutter/material.dart';

class UserOnboardPage extends StatefulWidget {
  const UserOnboardPage({super.key});

  @override
  State<UserOnboardPage> createState() => _UserOnboardPageState();
}

class _UserOnboardPageState extends State<UserOnboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Welcome User',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
