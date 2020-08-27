import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_emfor/screens/feedback_screen.dart';
import 'package:new_emfor/screens/filter_screen.dart';
import '../widgets/change_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                color: Colors.black,
                alignment: Alignment.center,
                child: FittedBox(
                  child: Text(
                    "Emfor",
                    style: TextStyle(
                      fontFamily: "OpenSans",
                      fontSize: 100,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.account_box),
                title: Text("Profil"),
                onTap: () {
                  Navigator.of(context).pushNamed(ChangeProfile.routeName);
                },
              ),
              Divider(
                height: 2,
                thickness: 1,
              ),
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text("Powiadomienia"),
                onTap: () {
                  Navigator.of(context).pushNamed(FilterScreen.routeName);
                },
              ),
              Divider(
                height: 2,
                thickness: 1,
              ),
              if (snap.data.getBool("expert"))
                Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.feedback),
                      title: Text("Opinie"),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(FeedbackScreen.routeName);
                      },
                    ),
                    Divider(
                      height: 2,
                      thickness: 1,
                    ),
                  ],
                ),
              ListTile(
                title: Text("Wyloguj"),
                leading: Icon(Icons.exit_to_app),
                onTap: () async {
                  var prefs = await SharedPreferences.getInstance();
                  prefs.setString("phone", null);
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.of(context).pushReplacementNamed("/");
                },
              ),
              Divider(
                height: 2,
                thickness: 1,
              ),
            ],
          );
        });
  }
}
