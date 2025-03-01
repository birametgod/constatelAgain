import 'package:flutter/material.dart';
import 'package:constatel/widgets/rounded_button.dart';
import 'package:constatel/services/authentication.dart';

class SignInWithPhoneNumberScreen extends StatefulWidget {
  const SignInWithPhoneNumberScreen({Key? key}) : super(key: key);

  @override
  State<SignInWithPhoneNumberScreen> createState() =>
      _SignInWithPhoneNumberScreenState();
}

class _SignInWithPhoneNumberScreenState
    extends State<SignInWithPhoneNumberScreen> {
  final phoneController = TextEditingController();

  //PhoneNumber number = PhoneNumber(isoCode: 'SN');
  String phoneNumber = "";

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff3c4372),
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Commençons par le numéro de téléphone, c'est parti !",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center, // Center align the text
              ),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color of the "button"
                      borderRadius: BorderRadius.circular(40.0), // Adjust the border radius as needed
                    ),
                    child: TextField(
                      onChanged: (String value) {
                        phoneNumber = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter phone number',
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  SizedBox(height: 10.0,),
                  RoundedButton(
                    text: 'Continuer',
                    color: Colors.white,
                    textColor: Colors.black,
                    widthNumber: 0.9,
                    onPressed: () async {
                      print("+221$phoneNumber");
                      await signInWithPhoneNumber(context, "+221$phoneNumber");
                    },
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Si vous n'avez pas de compte, vous serez redirigé pour en créer un nouveau",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
