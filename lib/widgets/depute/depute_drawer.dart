import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_emfor/providers/depute.dart';
import 'package:new_emfor/providers/deputes.dart';
import 'package:new_emfor/screens/support_screen.dart';
import 'package:new_emfor/widgets/depute/depute_detail_info.dart';
import 'package:new_emfor/widgets/depute/renegotiate_window.dart';
import 'package:provider/provider.dart';

class DeputeDrawer extends StatefulWidget {
  @override
  _DeputeDrawerState createState() => _DeputeDrawerState();
}

class _DeputeDrawerState extends State<DeputeDrawer> {
  Depute depute;

  bool isBefore() {
    var dt = DateTime.parse(depute.meet);
    return DateTime.now().isBefore(dt);
  }

  void cancelPressed() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 4,
            content: Text(
              "Czy pernamentnie chcesz anulować umowę?",
              style: Theme.of(context).textTheme.subhead,
            ),
            actions: [
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    "Nie",
                    style: Theme.of(context).textTheme.title,
                  )),
              FlatButton(
                  onPressed: () {
                    var list = new List.from(depute.activity);
                    list.add({
                      "choice": 0,
                      "data": DateTime.now().toString(),
                    });
                    Firestore.instance
                        .collection("chat")
                        .document(depute.chatId)
                        .updateData({
                      "estimate": "5",
                      "meet": "-",
                      "attentions": "-",
                      "cancel": true,
                      "activity": list
                    });
                    int count = 0;
                    Navigator.of(context).popUntil((_) => count++ >= 2);
                  },
                  child: Text(
                    "Tak",
                    style: Theme.of(context).textTheme.title,
                  ))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    depute = Provider.of<Deputes>(context).chosenDepute;
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            color: Colors.black,
            alignment: Alignment.center,
            child: FittedBox(
              child: Text(
                "Punkt Obsługi",
                style: TextStyle(
                  fontFamily: "Medium",
                  fontSize: 100,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.chrome_reader_mode),
            title: Text("Przejrzyj zlecenie"),
            onTap: () {
              Navigator.of(context).pushNamed(DeputeDetailInfo.routeName);
            },
          ),
          Divider(
            height: 2,
            thickness: 1,
          ),
          ListTile(
            leading: Icon(Icons.mode_edit),
            title: Text("Renegocjuj umowe"),
            onTap: () {
              Navigator.of(context).pushNamed(RenegotiateWindow.routeName);
            },
          ),
          Divider(
            height: 2,
            thickness: 1,
          ),
          Expanded(child: SizedBox()),
          FlatButton(
            onPressed: isBefore()
                ? cancelPressed
                : () =>
                    Navigator.of(context).pushNamed(SupportScreen.routeName),
            child: Text(
              isBefore() ? "Odwołaj" : "Zgłoś problem",
              style: TextStyle(
                fontSize: 18,
                fontFamily: "OpenSans",
                fontWeight: FontWeight.w300,
                color: Colors.red,
              ),
            ),
          )
        ],
      ),
    );
  }
}
