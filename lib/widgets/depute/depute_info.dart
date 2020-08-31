import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:new_emfor/providers/depute.dart';
import 'package:new_emfor/providers/deputes.dart';
import 'package:new_emfor/widgets/depute/depute_timeline.dart';
import 'package:new_emfor/widgets/depute/payu_depute_widget.dart';
import 'package:new_emfor/widgets/depute/side_window.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DeputeInfo extends StatelessWidget {
  Depute depute;
  bool first = false, last = false;
  String data, text;

  void values(context) {
    Map act = Provider.of<Deputes>(context, listen: false).currentActivity();
    data = act["data"];
    text = act["text"];
    last = act["last"] ?? false;
    first = act["first"] ?? false;
  }

  void directToPayu(context) async {
    final ProgressDialog pr = ProgressDialog(context);
    await pr.show();
    var estimate = "";
    await Firestore.instance
        .collection("chat")
        .document(depute.chatId)
        .get()
        .then((result) {
      estimate = result.data["estimate"];
    });
    final user = await FirebaseAuth.instance.currentUser();
    final idToken = await user.getIdToken();
    final authToken = idToken.token;
    final fbm = FirebaseMessaging();
    final prefs = await SharedPreferences.getInstance();
    var uid = prefs.getString("uid");
    fbm.subscribeToTopic(uid);
    //     "https://firestore.googleapis.com/v1/projects/emfor-add82/databases/(default)/documents/payments?key=AIzaSyCP70Z4SAFkDc8XroaMUNde1oaCgvzEH9o";
    var url =
        'https://emfor-add82.firebaseio.com/users/T6xsVXyAv8MwSXQF4H2yCkHXJvc2.json?auth=$authToken';
    final response = await http.post(
      "https://secure.snd.payu.com/api/v2_1/orders",
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer d9a4536e-62ba-4f60-8017-6053211d3f47",
      },
      body: json.encode({
        "notifyUrl": url,
        "customerIp": "127.0.0.1",
        "merchantPosId": "300746",
        "description": uid,
        "currencyCode": "PLN",
        "totalAmount": "${estimate}00",
        "buyer": {
          "email": prefs.getString("gmail"),
          "phone": prefs.getString("phone"),
          "firstName": prefs.getString("name"),
          "lastName": "",
          "language": "pl",
        },
        "settings": {"invoiceDisabled": "true"},
        "products": [
          {
            "name": "Emfor - ${depute.noticeTitle}",
            "unitPrice": "${estimate}00",
            "quantity": "1"
          },
        ]
      }),
    );
    Map map = json.decode(response.body);
    print(response.body);
    await pr.hide();
    Navigator.of(context)
        .pushNamed(PayuDeputeWidget.routeName, arguments: map["redirectUri"]);
  }

  @override
  Widget build(BuildContext context) {
    depute = Provider.of<Deputes>(context).chosenDepute;
    values(context);
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(DeputeTimeline.routeName),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Column(
          children: [
            TimelineTile(
              alignment: TimelineAlign.left,
              isFirst: first,
              isLast: last,
              indicatorStyle: const IndicatorStyle(
                width: 20,
                color: Colors.blue,
                padding: EdgeInsets.all(6),
              ),
              rightChild: Container(
                constraints: BoxConstraints(
                  minHeight: 50,
                ),
                padding: EdgeInsets.only(left: 6, right: 6, top: 4, bottom: 2),
                margin: EdgeInsets.symmetric(horizontal: 6, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[300],
                      spreadRadius: 0,
                      blurRadius: 8,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      text,
                      style: Theme.of(context).textTheme.overline,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(data,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w200,
                              fontFamily: "OpenSans")),
                    )
                  ],
                ),
              ),
              topLineStyle: const LineStyle(
                color: Colors.blue,
              ),
            ),
            if (!Provider.of<Deputes>(context).side && depute.process == 5)
              Column(
                children: [
                  Divider(
                    thickness: 2,
                  ),
                  FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onPressed: () {
                      Navigator.of(context).pushNamed(SideWindow.routeName);
                    },
                    child: Text(
                      "Sprawdź nową ofertę",
                      style: Theme.of(context).textTheme.overline,
                    ),
                  )
                ],
              ),
            if (Provider.of<Deputes>(context).side && depute.process == 7)
              Column(
                children: [
                  Divider(
                    thickness: 2,
                  ),
                  FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onPressed: () => directToPayu(context),
                    child: Text(
                      "Dokonaj płatności, aby sfinalozować umowę",
                      style: Theme.of(context).textTheme.overline,
                    ),
                  )
                ],
              ),
          ],
        ),
      ),
    );
  }
}
