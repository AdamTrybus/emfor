import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_emfor/providers/notice.dart';
import 'package:new_emfor/providers/read.dart';
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
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext c) {
                              return AlertDialog(
                                elevation: 4,
                                content: Text(
                                  "Dziękujemy za dokonanie płatności. Twoje zlecenie obecnie znajduje się w zakładce zatwierdzone ogłoszenia",
                                  style: Theme.of(context).textTheme.subhead,
                                ),
                                actions: [
                                  FlatButton(
                                      onPressed: () {
                                        var chat = Provider.of<Read>(context,
                                                listen: false)
                                            .chat;
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
                                            description:
                                                notice["description"] ?? "",
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
                                            "createdAt":
                                                DateTime.now().toString(),
                                            "process": 4,
                                            "description": n.description,
                                            "lat": n.lat,
                                            "lng": n.lng,
                                            "place": n.place,
                                            "variety": n.variety,
                                            "files": n.files,
                                            "cancel": false,
                                          });
                                          Firestore.instance
                                              .collection("notices")
                                              .document(value.documentID)
                                              .delete();
                                          Firestore.instance
                                              .collection("chat")
                                              .where("noticeId",
                                                  isEqualTo: value.documentID)
                                              .where("process", isLessThan: 4)
                                              .getDocuments()
                                              .then((value) {
                                            for (DocumentSnapshot doc
                                                in value.documents) {
                                              doc.reference.delete();
                                            }
                                          });
                                        });
                                        Navigator.of(c).pushNamedAndRemoveUntil(
                                            "/",
                                            (Route<dynamic> route) => false);
                                      },
                                      child: Text(
                                        "Ok",
                                        style: Theme.of(c).textTheme.title,
                                      ))
                                ],
                              );
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
