import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_emfor/providers/chat.dart';
import 'package:new_emfor/providers/read.dart';
import 'package:new_emfor/widgets/chat/shadow_sheet.dart';
import 'package:provider/provider.dart';

class ThirdProcess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ShadowSheet(
      color: Colors.green[300],
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Gwarancja usługi",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          SizedBox(
            height: 6,
          ),
          Text(
            "Oferta gwarancji usługi została zaakceptowana przez wykonawcę. Do finalizacji pozostało opłacić przez to powstałą umowę",
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w400, color: Colors.white),
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            children: [
              Expanded(child: SizedBox()),
              GestureDetector(
                onTap: () {
                  Firestore.instance
                      .collection("chat")
                      .document(
                          Provider.of<Read>(context, listen: false).chat.chatId)
                      .updateData({"process": 4});
                },
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
    );
  }
}
