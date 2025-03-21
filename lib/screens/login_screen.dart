import 'package:constatel/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:constatel/providers/auth_provider.dart';
import 'package:constatel/widgets/rounded_button.dart';
import 'package:constatel/screens/sign_phone_number_screen.dart';

import 'dart:async';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  /// Check if the user is already logged in
  void _checkLoginStatus() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.currentUser != null) {
      // Navigate to HomeScreen if already authenticated
      Future.microtask(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MapScreen()),
        );
      });
    }
  }

  /// Sign in using phone number from AuthProvider
  Future<void> _signInWithPhoneNumber() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignInWithPhoneNumberScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
        backgroundColor: Color(0xff3c4372),
        body: SafeArea(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Add your widgets here
                Image.asset(
                  'assets/images/carDrawing.png',
                  fit: BoxFit.contain,
                ),
                Column(
                  children: [
                    Align(
                        child: Text(
                      "ConstaTel",
                      style: TextStyle(
                          fontFamily: 'Malick',
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.18,
                          fontWeight: FontWeight.w500),
                    )),
                    const SizedBox(
                      height: 15.0,
                    ),
                    const Align(
                        child: Text(
                      "Connect, share, care",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500),
                    )),
                  ],
                ),
                RoundedButton(
                  text: 'Commencer',
                  color: Colors.white,
                  textColor: Colors.black, // Set the text color to red
                  onPressed: _signInWithPhoneNumber,
                  widthNumber: 0.4,
                ),
              ],
            ),
          ),
        ));
  }
}
