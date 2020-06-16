import 'package:flutter/material.dart';
import 'package:new_emfor/screens/phone_verification.dart';
import '../widgets/button.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Widget button(String text, Color textColor, Color backgroundColor) {
    return Container(
      height: 75,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: RaisedButton(
        onPressed: () {},
        color: backgroundColor,
        elevation: 4,
        child: Text(
          text,
          style: TextStyle(
            fontFamily: "Gotham",
            color: textColor,
            fontSize: 32,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: height * 0.65,
            padding: EdgeInsets.all(20),
            width: double.infinity,
            color: Colors.black,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                "Emfor",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Quicksand",
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Expanded(child: SizedBox()),
          MyButton(
            text: "Zaloguj",
            onPressed: () {
              Navigator.of(context).pushNamed(PhoneVerification.routeName,arguments: true);
            },
          ),
          SizedBox(
            height: 20,
          ),
          MyButton(
            text: "Rejestracja",
            textColor: Colors.black,
            backgroundColor: Colors.grey[50],
            onPressed: () {
              Navigator.of(context).pushNamed(PhoneVerification.routeName,arguments: false);
            },
          ),
          Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}
