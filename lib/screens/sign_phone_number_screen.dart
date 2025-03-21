import 'package:constatel/screens/confirmation_code_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:constatel/widgets/rounded_button.dart';
import 'package:constatel/providers/auth_provider.dart';

class SignInWithPhoneNumberScreen extends StatefulWidget {
  const SignInWithPhoneNumberScreen({Key? key}) : super(key: key);

  @override
  State<SignInWithPhoneNumberScreen> createState() =>
      _SignInWithPhoneNumberScreenState();
}

class _SignInWithPhoneNumberScreenState
    extends State<SignInWithPhoneNumberScreen> {
  final phoneController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _signInWithPhoneNumber() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String phoneNumber = "+221${phoneController.text.trim()}";

    if (phoneController.text.isEmpty || phoneController.text.length < 9) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez entrer un numéro valide")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await authProvider.signInWithPhoneNumber(
        context,
        phoneNumber,
            (String verificationId) {
          // Navigate to OTP verification screen when code is sent
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConfirmationCodeScreen(
                verificationId: verificationId,
              ),
            ),
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: ${e.toString()}")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff3c4372),
      body: SafeArea(
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
              textAlign: TextAlign.center,
            ),
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  child: TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      hintText: 'Entrer le numéro de téléphone',
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ),
                const SizedBox(height: 10.0),
                RoundedButton(
                  text: isLoading ? 'En cours...' : 'Continuer',
                  color: Colors.white,
                  textColor: Colors.black,
                  widthNumber: 0.9,
                  onPressed: _signInWithPhoneNumber,
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
    );
  }
}
