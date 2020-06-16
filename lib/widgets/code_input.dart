import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import './personal_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../widgets/button.dart';

class CodeInput extends StatefulWidget {
  static const routeName = "/code-input";
  @override
  _CodeInputState createState() => _CodeInputState();
}

class _CodeInputState extends State<CodeInput> {
  String verificationId, code, phone;
  bool firstBuild = true, loading = false, login;
  var firebaseAuth = FirebaseAuth.instance;

  void onFailed() {
    Toast.show(
      "Błąd",
      context,
      duration: Toast.LENGTH_SHORT,
    );
    Navigator.of(context).pop();
    setState(() {
      loading = false;
    });
  }

  void signIn(AuthCredential authCredential) {
    try {
      firebaseAuth.signInWithCredential(authCredential).catchError((e) {
        onFailed();
      }).then((user) async {
        if (user.user != null) {
          Firestore.instance
              .collection("users")
              .document(phone)
              .get()
              .then((value) async {
            if (value.exists && login) {
              var prefs = await SharedPreferences.getInstance();
              prefs.setString("phone", phone);
              prefs.setString("gmail", value.data["gmail"]);
              prefs.setString("name", value.data["name"]);
              prefs.setString("imageUrl", value.data["imageUrl"]);
              Navigator.of(context).pushNamed("/");
            } else {
              if (login) {
                Toast.show(
                  "Załóż najpierw konto",
                  context,
                  duration: Toast.LENGTH_LONG,
                );
                Navigator.of(context).popUntil((route) => route.isFirst);
              } else {
                Navigator.of(context)
                    .pushNamed(PersonalInfo.routeName, arguments: phone);
              }
            }
          });
        } else {
          onFailed();
        }
      });
    } catch (e) {
      onFailed();
    }
  }

  Future<void> verifyPhone(String phone) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      signIn(authResult);
    };

    final PhoneVerificationFailed verificationfailed =
        (AuthException authException) {
      onFailed();
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      verificationId = verId;
      setState(() {
        loading = false;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      onFailed();
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: const Duration(seconds: 60),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }

  void _signInWithPhoneNumber(String smsCode) async {
    AuthCredential _authCredential = PhoneAuthProvider.getCredential(
        verificationId: verificationId, smsCode: smsCode);
    signIn(_authCredential);
  }

  @override
  Widget build(BuildContext context) {
    var map = ModalRoute.of(context).settings.arguments as Map<String, Object>;
    phone = map["phone"];
    login = map["login"];
    if (firstBuild) {
      loading = true;
      firstBuild = false;
      verifyPhone(phone);
    }
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                SizedBox(
                  height: 25,
                ),
                Text(
                  "Wprowadź kod",
                  style: Theme.of(context).textTheme.display1,
                ),
                SizedBox(
                  height: 6,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: "Kod został wysłany do ",
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                      TextSpan(
                        text: phone,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                    padding: const EdgeInsets.all(20),
                    child: PinCodeTextField(
                      length: 6,
                      onChanged: (value) => code = value,
                      textInputType: TextInputType.number,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        borderRadius: BorderRadius.circular(10),
                        borderWidth: 2,
                        fieldHeight: 50,
                        fieldWidth: 50,
                        shape: PinCodeFieldShape.underline,
                        selectedFillColor: Colors.grey[200],
                        inactiveFillColor: Colors.grey[300],
                        disabledColor: Colors.grey[300],
                        inactiveColor: Colors.grey[300],
                        activeColor: Colors.grey[300],
                        selectedColor: Colors.grey[300],
                        activeFillColor: Colors.grey[300],
                      ),
                      backgroundColor: Colors.transparent,
                      animationDuration: Duration(milliseconds: 300),
                      enableActiveFill: true,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    )),
                Expanded(child: SizedBox()),
                MyButton(
                  onPressed: () {
                    _signInWithPhoneNumber(code);
                  },
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
    );
  }
}
