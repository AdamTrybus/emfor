import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:new_emfor/providers/notice.dart';
import 'package:new_emfor/providers/read.dart';
import 'package:new_emfor/widgets/chat/shadow_sheet.dart';
import 'package:new_emfor/widgets/chat/payu_chat_widget.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class ThirdProcess extends StatefulWidget {
  @override
  _ThirdProcessState createState() => _ThirdProcessState();
}

class _ThirdProcessState extends State<ThirdProcess> {
  bool exp;

  void directToPayu() async {
    final ProgressDialog pr = ProgressDialog(context);
    await pr.show();
    var chat = Provider.of<Read>(context, listen: false).chat;
    var estimate = "";
    await Firestore.instance
        .collection("chat")
        .document(chat.chatId)
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
            "name": "Emfor - ${chat.noticeTitle}",
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
        .pushNamed(PayuChatWidget.routeName, arguments: map["redirectUri"]);
  }

  @override
  Widget build(BuildContext context) {
    exp = Provider.of<Read>(context).expanded;
    return ShadowSheet(
      color: Colors.green[300],
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (exp)
            Column(
              children: [
                Text(
                  "Oferta gwarancji usługi została zaakceptowana przez wykonawcę. Do finalizacji pozostało opłacić przez to powstałą umowę",
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    Expanded(child: SizedBox()),
                    GestureDetector(
                      onTap: () => directToPayu,
                      child: Text(
                        "Dokonaj płatności",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.amber[600]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}
