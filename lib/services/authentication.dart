import 'package:constatel/screens/confirmation_code_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:constatel/screens/home_screen.dart';

FirebaseAuth auth = FirebaseAuth.instance;
TextEditingController codeController = TextEditingController();



Future<void> signInWithPhoneNumber(BuildContext context, String mobile) async {
  print(mobile);
  auth.verifyPhoneNumber(
    phoneNumber: mobile,
    // Automatic handling of the SMS code on Android devices.
    verificationCompleted: (PhoneAuthCredential credential) async {
      // Android ONLY
      // Sign the user in (or link) with the auto-generated credential
      await auth.signInWithCredential(credential).then((value) =>
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen())));
    },
    // Handle failure events such as invalid phone numbers or whether the SMS quota has been exceeded.
    verificationFailed: (FirebaseAuthException e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
    },
    // Handle when a code has been sent to the device from Firebase, used to prompt users to enter the code.
    codeSent: (String verificationId, int? resendToken) {
      // Navigate to the next screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmationCodeScreen(verificationId: verificationId),
        ),
      );
    },
    // Handle a timeout of when automatic SMS code handling fails.
    codeAutoRetrievalTimeout: (String verificationId) {
      print('verificationId: ${verificationId} ');
      // Auto-resolution timed out...
      /** On Android devices which support automatic SMS code resolution,
        * this handler will be called if the device has not automatically resolved an SMS message within a certain timeframe.
        * Once the timeframe has passed, the device will no longer attempt to resolve any incoming messages.
           By default, the device waits for 30 seconds however this can be customized with the timeout argument:**/
    },
  );
}

Future<void> signInWithPhoneNumber2(BuildContext context, String mobile) async {
  await auth.verifyPhoneNumber(
    phoneNumber: mobile,
    // Automatic handling of the SMS code on Android devices.
    verificationCompleted: (PhoneAuthCredential credential) async {
      // Android ONLY
      // Sign the user in (or link) with the auto-generated credential
      await auth
          .signInWithCredential(credential)
          .then((value) => Navigator.popAndPushNamed(context, 'home'));
    },
    // Handle failure events such as invalid phone numbers or whether the SMS quota has been exceeded.
    verificationFailed: (FirebaseAuthException e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
    },
    // Handle when a code has been sent to the device from Firebase, used to prompt users to enter the code.
    codeSent: (String verificationId, int? resendToken) {
      _dialogBuilder(context, verificationId);
    },
    // Handle a timeout of when automatic SMS code handling fails.
    codeAutoRetrievalTimeout: (String verificationId) {
      print('verificationId: ${verificationId} ');
      // Auto-resolution timed out...
      /** On Android devices which support automatic SMS code resolution,
       * this handler will be called if the device has not automatically resolved an SMS message within a certain timeframe.
       * Once the timeframe has passed, the device will no longer attempt to resolve any incoming messages.
          By default, the device waits for 30 seconds however this can be customized with the timeout argument:**/
    },
  );
}

Future<void> _dialogBuilder(BuildContext context, String verificationId) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enter Sms Code"),
          content: TextField(
            controller: codeController,
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Confirm'),
              onPressed: () async {
                // resendToken only supported in android devices
                // Update the UI - wait for the user to enter the SMS code
                String smsCode = codeController.text.trim();
                // Create a PhoneAuthCredential with the code
                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                    verificationId: verificationId, smsCode: smsCode);

                //Sign the user in with the credential
                await auth
                    .signInWithCredential(credential)
                    .then((value) => {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()))
                        })
                    .catchError((error) {
                });
              },
            ),
          ],
        );
      });
}
