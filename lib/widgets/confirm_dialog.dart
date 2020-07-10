import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../providers/notice.dart';
import '../widgets/notice_detail_builder.dart';

class ConfirmDialog extends StatelessWidget {
  final noticeId, expertPhone;
  ConfirmDialog(this.noticeId, this.expertPhone);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firestore.instance.collection("notices").document(noticeId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        dynamic f = snapshot.data;
        final notice = Notice(
          id: f.documentID,
          service: f["service"],
          variety: f["variety"],
          description: f["description"] ?? "",
          files: f["files"],
          place: f["place"],
          time: f["time"],
          userPhone: f["userPhone"],
          createdAt: f["createdAt"],
          userName: f["userName"],
          userImage: f["userImage"],
        );
        return FutureBuilder(
          future: Firestore.instance
              .collection("notices")
              .document(noticeId)
              .collection("eagers")
              .document(expertPhone)
              .get(),
          builder: (context, estimateSnapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                snapshot.connectionState == ConnectionState.none) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: InfoDetailBuilder(
                      notice: notice,
                      height: MediaQuery.of(context).size.height,
                      estimate: estimateSnapshot.data["estimate"],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 50,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0),
                            side: BorderSide(color: Colors.black, width: 4)),
                        color: Colors.white,
                        onPressed: () {},
                        child: Text(
                          "Anuluj",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Quicksand",
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      child: RaisedButton(
                        color: Colors.black,
                        disabledColor: Colors.black26,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0),
                            side: BorderSide(color: Colors.black, width: 4)),
                        onPressed: () {},
                        child: Text(
                          "Zatwierdź",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Quicksand",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 6,
                )
              ],
            );
          },
        );
      },
    );
  }
}
