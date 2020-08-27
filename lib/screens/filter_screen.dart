import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilterScreen extends StatefulWidget {
  static const String routeName = "filter-screen";
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  bool pushUp = true, email = true, changes = false, loading = true;
  String uid;
  var prefs;

  void _onBackPressed() {
    if (changes) {
      Firestore.instance
          .collection("users")
          .document(uid)
          .updateData({"pushUp": pushUp, "email": email});
      prefs.setBool("pushUp", pushUp);
      prefs.setBool("email", email);
      var isEpert = prefs.getBool("expert");
      Firestore.instance
          .collection("chat")
          .where(isEpert ? "expertUid" : "principalUid", isEqualTo: uid)
          .getDocuments()
          .then((value) async {
        final fbm = FirebaseMessaging();
        value.documents.forEach((element) async {
          var topic = element.documentID;
          if (pushUp)
            await fbm.subscribeToTopic(topic);
          else
            await fbm.unsubscribeFromTopic(topic);
        });
      });
    }
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration()).then((_) async {
      prefs = await SharedPreferences.getInstance();
      uid = prefs.getString("uid");
      pushUp = prefs.getBool("pushUp") ?? true;
      email = prefs.getBool("email") ?? true;
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _onBackPressed();
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Powiadomienia"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: _onBackPressed,
          ),
        ),
        body: SafeArea(
          child: loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  children: [
                    ListTile(
                      title: Text("Powiadomienia"),
                      trailing: Switch(
                          value: pushUp,
                          onChanged: (v) {
                            changes = true;
                            setState(() {
                              pushUp = v;
                            });
                          }),
                    ),
                    ListTile(
                      title: Text("Wiadomości e-mail"),
                      trailing: Switch(
                          value: email,
                          onChanged: (v) {
                            changes = true;
                            setState(() {
                              email = v;
                            });
                          }),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
