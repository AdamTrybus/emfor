import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: height * 0.63,
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
          SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                "Zacznij działać z Emfor",
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () =>
                Navigator.of(context).pushNamed(PhoneVerification.routeName),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Image.asset(
                    "assets/poland_icon.png",
                    width: 40,
                    height: 50,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "+48",
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Medium",
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Wprowadź numer telefonu",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        fontFamily: "OpenSans",
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: SizedBox()),
          Divider(
            thickness: 1.5,
            endIndent: 15,
            color: Colors.black12,
            indent: 15,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: FlatButton(
              onPressed: () {},
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Regulamin korzystania z aplikacji",
                style: TextStyle(
                  fontFamily: "OpenSans",
                  color: Colors.teal,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
