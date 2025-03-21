import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:constatel/providers/auth_provider.dart';
import 'package:constatel/screens/pick_user_screen.dart';
import 'package:constatel/widgets/rounded_button.dart';

class ConfirmationCodeScreen extends StatefulWidget {
  final String verificationId;

  const ConfirmationCodeScreen({Key? key, required this.verificationId})
      : super(key: key);

  @override
  _ConfirmationCodeScreenState createState() => _ConfirmationCodeScreenState();
}

class _ConfirmationCodeScreenState extends State<ConfirmationCodeScreen> {
  final List<TextEditingController> _codeControllers =
  List.generate(6, (_) => TextEditingController());

  @override
  void dispose() {
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff3c4372),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Maintenant, vérifiez votre numéro de téléphone",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.start,
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        6,
                            (index) => buildCodeInput(_codeControllers[index]),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    const Text(
                      "Veuillez saisir le code de confirmation que nous venons de vous envoyer par SMS.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                RoundedButton(
                  text: 'Continuer',
                  color: Colors.white,
                  textColor: Colors.black,
                  widthNumber: 0.9,
                  onPressed: () async {
                    String confirmationCode =
                    _codeControllers.map((c) => c.text).join();

                    if (confirmationCode.length == 6) {
                      try {
                        final authProvider =
                        Provider.of<AuthProvider>(context, listen: false);
                        await authProvider.verifySmsCode(
                          context,
                          widget.verificationId,
                          confirmationCode,
                        );

                        // Navigate to the next screen
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) => PickUserScreen(),
                            transitionsBuilder:
                                (_, animation, __, child) => FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                            transitionDuration: Duration(milliseconds: 500),
                          ),
                        );
                      } catch (error) {
                        print('Error signing in: $error');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Échec de la vérification du code."),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Veuillez entrer un code valide."),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCodeInput(TextEditingController controller) {
    return Container(
      width: 50.0,
      height: 60.0,
      padding: EdgeInsets.only(top: 15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(27.0),
      ),
      child: TextFormField(
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(border: InputBorder.none),
        onChanged: (value) {
          if (value.isNotEmpty) FocusScope.of(context).nextFocus();
        },
      ),
    );
  }
}
