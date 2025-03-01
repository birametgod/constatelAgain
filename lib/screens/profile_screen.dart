import 'package:constatel/screens/faq_screen.dart';
import 'package:constatel/screens/login_screen.dart';
import 'package:constatel/screens/personal_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:constatel/providers/auth_provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset("assets/images/back.png", scale: 5),
          ),
          title: Text(
            "Profile",
            style: TextStyle(color: Colors.black, fontFamily: 'Gilroy_Bold'),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Image.asset("assets/images/inFrontOfTheCar.png",
                    height: height / 10),
              ),
              SizedBox(height: height / 70),
              Text(
                "Sy Sall",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Gilroy_Bold',
                    fontSize: 16),
              ),
              // _profile(),
              SizedBox(height: height / 20),
              GestureDetector(
                onTap: () {
                },
                child: invitefriend(
                    Color(0xff3c4372),
                    "Invitation\nInvite tes amis pour gagner des cadeaux.",
                    Colors.white),
              ),
              // GestureDetector(
              //     onTap: () {
              //       Get.to(const ReferralCode());
              //     },
              //     child: referalcode()),
              SizedBox(height: height / 25),
              Row(
                children: [
                  SizedBox(width: width / 20),
                  Text(
                    "Général",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        fontFamily: 'Gilroy_Bold'),
                  ),
                ],
              ),
              SizedBox(height: height / 50),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                      const PersonalDetails(),
                    ),
                  );
                },
                child: iteamlist("assets/images/user.svg", "",
                    "Informations Personnelles"),
              ),
              SizedBox(height: height / 30),
              GestureDetector(
                onTap: () {
                  //Get.to(const PaymentMethod());
                },
                child: iteamlist("assets/images/wallet.svg", "",
                    "Mes constats"),
              ),
              SizedBox(height: height / 30),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                      const FAQ(),
                    ),
                  );
                },
                child: iteamlist(
                    "assets/images/question.svg", "", "Faq & support"),
              ),

              SizedBox(height: height / 25),
              Row(
                children: [
                  SizedBox(width: width / 20),
                  Text(
                    "Settings",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        fontFamily: 'Gilroy_Bold'),
                  ),
                ],
              ),

              SizedBox(height: height / 40),

              GestureDetector(
                onTap: () {
                  AuthProvider().signOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                      const LoginScreen(),
                    ),
                  );
                },
                child:
                iteamlist("assets/images/right.svg", "", "Déconnexion"),
              ),
              SizedBox(height: height / 50),

            ],
          ),
        ),
      );
  }


  Widget invitefriend(colorbutton, buttontext, buttontextcolor) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LayoutBuilder(builder: (context, constraints) {
              return Container(
                height: height / 10,
                width: width / 1.1,
                decoration: BoxDecoration(
                  color: colorbutton!,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset("assets/images/Invitefriends.png",
                        height: height / 20),
                    Text(
                      buttontext!,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontFamily: 'Gilroy_Medium',
                          fontSize: 13,
                          color: buttontextcolor),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: Colors.white,
                    )
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }


  Widget iteamlist(image, txt, name) {
    return Container(
      color: Colors.transparent,
      child: Row(
        children: [
          SizedBox(width: width / 25),
          SvgPicture.asset(image, height: height / 40),
          //Image.asset(image, height: height / 22),
          SizedBox(width: width / 40),
          Text(
            name,
            style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontFamily: 'Gilroy_Medium'),
          ),
          const Spacer(),
          SizedBox(width: width / 100),
          Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 17),
          SizedBox(width: width / 15),
        ],
      ),
    );
  }

}

dynamic height;
dynamic width;

double responsiveWidth(int X, double width) {
  return (width * X) / width;
}

double responsiveHeight(int X, double height) {
  return (height * X) / height;
}
