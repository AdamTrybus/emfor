import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_emfor/providers/chat.dart';
import 'package:new_emfor/providers/read.dart';
import 'package:provider/provider.dart';
import '../chat_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpertChat extends StatefulWidget {
  @override
  _ExpertChatState createState() => _ExpertChatState();
}

class _ExpertChatState extends State<ExpertChat> {
  var phone;
  final ids = [];
  var isLoading = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(microseconds: 0)).then((value) async {
      var prefs = await SharedPreferences.getInstance();
      phone = prefs.getString("phone");
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : StreamBuilder(
            stream: Firestore.instance
                .collection("chat")
                .where("expertPhone", isEqualTo: phone)
                .where("process", isLessThan: 4)
                .orderBy("process", descending: true)
                .orderBy("createdAt", descending: true)
                .snapshots(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              List<Chat> chatDocs = [];
              snapshot.data.documents.forEach((element) {
                Chat chat = Chat(
                  chatId: element.documentID,
                  expertImage: element["expertImage"],
                  expertName: element["expertName"],
                  noticeTitle: element["noticeTitle"],
                  noticeId: element["noticeId"],
                  expertPhone: element["expertPhone"],
                  principalPhone: element["principalPhone"],
                  createdAt: element["createdAt"],
                  expertRead: element["expertRead"],
                  principalImage: element["principalImage"],
                  principalName: element["principalName"],
                  principalRead: element["principalRead"],
                  process: element["process"],
                );
                chatDocs.add(chat);
              });
              return ListView.builder(
                itemCount: chatDocs.length,
                itemBuilder: (ctx, i) => Card(
                  elevation: 8,
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chatDocs[i].noticeTitle,
                          style: TextStyle(
                            fontFamily: "Quicksand",
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  chatDocs[i].principalImage != null
                                      ? NetworkImage(
                                          chatDocs[i].principalImage,
                                        )
                                      : AssetImage(
                                          "assets/user_image.png",
                                        ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                chatDocs[i].principalName,
                                style: Theme.of(context).textTheme.overline,
                              ),
                            ),
                            Stack(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: RaisedButton(
                                    onPressed: () {
                                      Provider.of<Read>(context, listen: false)
                                          .setValues(
                                        chat: chatDocs[i],
                                        isExpert: true,
                                      );
                                      Navigator.of(context).pushNamed(
                                          ChatScreenDetail.routeName);
                                    },
                                    child: Text(
                                      "Czat",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                    color: Colors.black,
                                  ),
                                ),
                                !chatDocs[i].expertRead
                                    ? Positioned(
                                        right: 0,
                                        top: 0,
                                        child: Container(
                                          padding: EdgeInsets.all(6.0),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.amber[800],
                                          ),
                                          constraints: BoxConstraints(
                                            minWidth: 16,
                                            minHeight: 16,
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }
}
