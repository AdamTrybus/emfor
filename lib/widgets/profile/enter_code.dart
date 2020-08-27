import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_emfor/widgets/button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class EnterCode extends StatefulWidget {
  static const String routeName = "Enter - code";
  @override
  _EnterCodeState createState() => _EnterCodeState();
}

class _EnterCodeState extends State<EnterCode> {
  String verificationId, phone;
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
          var prefs = await SharedPreferences.getInstance();
          var firestore = Firestore.instance;
          firestore
              .collection("users")
              .where("phone", isEqualTo: phone)
              .getDocuments()
              .then((value) {
            if (value.documents.isNotEmpty) {
              Toast.show(
                  "Numer jest już w naszej bazie - zmień na inny", context,
                  duration: 10);
            } else {
              firestore
                  .collection("users")
                  .document(prefs.getString("uid"))
                  .updateData({"phone": phone});
              prefs.setString("phone", phone);
            }
            int count = 0;
            Navigator.of(context).popUntil((_) => count++ >= 2);
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 32,
              ),
              padding: EdgeInsets.all(16),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Padding(
                padding: const EdgeInsets.all(20),
                child: PinCodeTextField(
                  length: 6,
                  onChanged: (s) {},
                  textInputType: TextInputType.number,
                  animationType: AnimationType.fade,
                  autoFocus: true,
                  onCompleted: (code) => _signInWithPhoneNumber(code),
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
          ],
        ),
      ),
    );
  }
}
