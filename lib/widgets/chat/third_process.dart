import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_emfor/providers/chat.dart';
import 'package:new_emfor/providers/depute.dart';
import 'package:new_emfor/providers/notice.dart';
import 'package:new_emfor/providers/read.dart';
import 'package:new_emfor/screens/depute_detail_screen.dart';
import 'package:new_emfor/widgets/chat/shadow_sheet.dart';
import 'package:provider/provider.dart';

class ThirdProcess extends StatelessWidget {
  bool exp;
  @override
  Widget build(BuildContext context) {
    exp = Provider.of<Read>(context).expanded;
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
                      onTap: () {
                        var chat =
                            Provider.of<Read>(context, listen: false).chat;
                        Firestore.instance
                            .collection("notices")
                            .document(chat.noticeId)
                            .get()
                            .then((value) async {
                          dynamic notice = value.data;
                          var n = Notice(
                            id: value.documentID,
                            service: notice["service"],
                            variety: notice["variety"],
                            description: notice["description"] ?? "",
                            files: notice["files"],
                            place: notice["place"],
                            time: notice["time"],
                            userPhone: notice["userPhone"],
                            createdAt: notice["createdAt"],
                            userName: notice["userName"],
                            userImage: notice["userImage"],
                            lat: notice["lat"],
                            lng: notice["lng"],
                          );
                          await Firestore.instance
                              .collection("chat")
                              .document(chat.chatId)
                              .updateData({
                            "process": 4,
                            "description": n.description,
                            "lat": n.lat,
                            "lng": n.lng,
                            "place": n.place,
                            "variety": n.variety,
                            "files": n.files,
                          });
                          Firestore.instance
                              .collection("notices")
                              .document(value.documentID)
                              .delete();
                          Firestore.instance
                              .collection("chat")
                              .where("noticeId", isEqualTo: value.documentID)
                              .where("process", isLessThan: 4)
                              .getDocuments()
                              .then((value) {
                            for (DocumentSnapshot doc in value.documents) {
                              doc.reference.delete();
                            }
                          });
                          await Firestore.instance
                              .collection("chat")
                              .document(chat.chatId)
                              .get()
                              .then((value) {
                            var e = value.data;
                            var depute = Depute(
                              chatId: value.documentID,
                              expertImage: e["expertImage"],
                              expertName: e["expertName"],
                              noticeTitle: e["noticeTitle"],
                              noticeId: e["noticeId"],
                              expertPhone: e["expertPhone"],
                              principalPhone: e["principalPhone"],
                              createdAt: e["createdAt"],
                              expertRead: e["expertRead"],
                              principalImage: e["principalImage"],
                              principalName: e["principalName"],
                              principalRead: e["principalRead"],
                              process: e["process"],
                              attentions: e["attentions"],
                              estimate: e["estimate"],
                              meet: e["meet"],
                              description: e["description"],
                              files: e["files"],
                              lat: e["lat"],
                              lng: e["lng"],
                              place: e["place"],
                              variety: e["variety"],
                            );
                            Navigator.of(context).pushReplacementNamed(
                                DeputeDetailScreen.routeName,
                                arguments: depute);
                          });
                        });
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
        ],
      ),
    );
  }
}
