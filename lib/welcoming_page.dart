import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:untitled/login_page.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 10), navigateToLoginRegisterPage);
  }

  void navigateToLoginRegisterPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) =>
            LoginPage(), // Use AuthPage class from login_register_page.dart
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            alignment: Alignment.center,
            child: AspectRatio(
              aspectRatio: 16 / 9, // Adjust aspect ratio as needed
              child: Lottie.asset(
                'assets/Animation - 1710537935017.json',
                width: 900,
                height: 800,
              ),
            ),
          ),
          Positioned(
            bottom: 20.0,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Welcome To Trauma Detection',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

