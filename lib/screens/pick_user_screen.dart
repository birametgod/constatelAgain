import 'package:constatel/screens/agent_screen.dart';
import 'package:flutter/material.dart';
import 'package:constatel/screens/map_screen.dart';

class PickUserScreen extends StatefulWidget {
  const PickUserScreen({super.key});

  @override
  State<PickUserScreen> createState() => _PickUserScreenState();
}

class _PickUserScreenState extends State<PickUserScreen> {
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff3c4372),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 100,
                color: Colors.white,
              ),
              SizedBox(height: 20),
              Text(
                'Vérification réussie!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Choisissez votre type de compte',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 40),
              // Radio options container
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    _buildRadioOption(
                      'user',
                      'Utilisateur Régulier',
                      'Accédez à nos services en tant qu\'utilisateur',
                      Icons.person,
                    ),
                    Divider(height: 1, color: Colors.grey[300]),
                    _buildRadioOption(
                      'agent',
                      'Agent',
                      'Accédez au portail des agents',
                      Icons.business_center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              // Continue Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: Size(double.infinity, 55),
                ),
                onPressed: selectedRole == null
                    ? null
                    : () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => selectedRole == 'agent'
                          ? AgentScreen()
                          : MapScreen(),
                    ),
                  );
                },
                child: Text(
                  'Continuer',
                  style: TextStyle(
                    color: selectedRole == null ? Colors.grey : Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadioOption(
      String value,
      String title,
      String subtitle,
      IconData icon,
      ) {
    return RadioListTile<String>(
      value: value,
      groupValue: selectedRole,
      onChanged: (String? newValue) {
        setState(() {
          selectedRole = newValue;
        });
      },
      title: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xff3c4372).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Color(0xff3c4372),
              size: 24,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xff3c4372),
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      activeColor: Color(0xff3c4372),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}