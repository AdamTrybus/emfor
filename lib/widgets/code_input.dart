import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './personal_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CodeInput extends StatefulWidget {
  static const routeName = "/code-input";
  @override
  _CodeInputState createState() => _CodeInputState();
}

class _CodeInputState extends State<CodeInput> {
  String verificationId, code, phone;
  bool firstBuild = true, loading = false;
  var firebaseAuth = FirebaseAuth.instance;

  void onFailed() {
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
              .then((value)async {
            if (value.exists) {
              var prefs = await SharedPreferences.getInstance();
              prefs.setString("phone", phone);
              prefs.setString("gmail", value.data["gmail"]);
              prefs.setString("name", value.data["name"]);
              prefs.setString("imageUrl", value.data["imageUrl"]);
              Navigator.of(context).pushNamed("/");
            } else {
              Navigator.of(context)
                  .pushNamed(PersonalInfo.routeName, arguments: phone);
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
      print(forceResend);
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
    phone = ModalRoute.of(context).settings.arguments;
    if (firstBuild) {
      loading = true;
      firstBuild = false;
      verifyPhone(phone);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Phone verification"),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                SizedBox(
                  height: 25,
                ),
                Text("Wprowadź kod",
                    style:
                        TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
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
                      TextSpan(text: "Kod został wysłany do "),
                      TextSpan(
                          text: phone,
                          style: TextStyle(fontWeight: FontWeight.w500)),
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
                Container(
                  width: 200,
                  child: RaisedButton(
                    onPressed: () {
                      _signInWithPhoneNumber(code);
                    },
                    color: Colors.amber[500],
                    elevation: 6,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(26),
                      borderSide:
                          BorderSide(width: 1, color: Colors.amber[500]),
                    ),
                    child: Text(
                      "Dalej",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
    );
  }
}
