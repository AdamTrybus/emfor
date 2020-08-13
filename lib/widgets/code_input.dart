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
  bool firstBuild = true, loading = false;
  var firebaseAuth = FirebaseAuth.instance;

  void onFailed(Object e) {
    Toast.show(
      e.toString(),
      context,
      duration: 10,
    );
    Navigator.of(context).pop();
    setState(() {
      loading = false;
    });
  }

  void signIn(AuthCredential authCredential) {
    try {
      firebaseAuth.signInWithCredential(authCredential).catchError((e) {
        onFailed(e);
      }).then((user) async {
        if (user.user != null) {
          Firestore.instance
              .collection("users")
              .document(phone)
              .get()
              .then((value) async {
            if (value.exists) {
              var prefs = await SharedPreferences.getInstance();
              prefs.setString("phone", phone);
              prefs.setString("gmail", value.data["gmail"]);
              prefs.setString("name", value.data["name"]);
              prefs.setBool("expert", value.data["expert"]);
              prefs.setString("imageUrl", value.data["imageUrl"]);
              Navigator.of(context).pushNamedAndRemoveUntil(
                  "/", (Route<dynamic> route) => false);
            } else {
              Navigator.of(context).pushReplacementNamed(PersonalInfo.routeName,
                  arguments: phone);
            }
          });
        } else {
          onFailed("tutaj nie powinno byc bledu");
        }
      });
    } catch (e) {
      onFailed(e);
    }
  }

  Future<void> verifyPhone(String phone) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      signIn(authResult);
    };

    final PhoneVerificationFailed verificationfailed =
        (AuthException authException) {
      onFailed(authException.message);
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      verificationId = verId;
      setState(() {
        loading = false;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      onFailed("czas minął");
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
      resizeToAvoidBottomPadding: true,
      body: SafeArea(
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Row(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: FloatingActionButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Icon(
                              Icons.arrow_back,
                              size: 50,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 18.0,
                            ),
                            child: Column(
                              children: [
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle,
                                      ),
                                      TextSpan(
                                        text: phone,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
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
      ),
    );
  }
}
