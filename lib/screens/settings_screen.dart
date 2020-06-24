import 'package:flutter/material.dart';
import '../screens/depute_screen.dart';
import '../widgets/change_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
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
          onTap: (){
            Navigator.of(context).pushNamed(ChangeProfile.routeName);
          },
        ),
        Divider(
          height: 2,
          thickness: 1,
        ),
        ListTile(
          leading: Icon(Icons.event_available),
          title: Text("Moje ogłoszenia"),
          onTap: (){
            Navigator.of(context).pushNamed(DeputeScreen.routeName);
          },
        ),
        Divider(
          height: 2,
          thickness: 1,
        ),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text("Wyloguj"),
          onTap: ()async {
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
  }
}
