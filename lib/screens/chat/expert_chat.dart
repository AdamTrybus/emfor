import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
                .where("expert", isEqualTo: phone)
                .snapshots(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              var chatDocs = [];
              if (snapshot.data.documents.length > 0) {
                chatDocs = snapshot.data.documents;
              }
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
                          chatDocs[i]["title"],
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
                                  chatDocs[i]["principalImage"] != null
                                      ? NetworkImage(
                                          chatDocs[i]["principalImage"],
                                        )
                                      : AssetImage(
                                          "assets/user_image.png",
                                        ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                chatDocs[i]["principalName"],
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
                                        chatId: chatDocs[i].documentID,
                                        expertPhone: phone,
                                        isExpert: true,
                                        noticeId: chatDocs[i]["id"],
                                      );
                                      Navigator.of(context).pushNamed(
                                          ChatScreenDetail.routeName,
                                          arguments: {
                                            "noticeId": chatDocs[i]["id"],
                                            "phone": phone,
                                            "name": chatDocs[i]
                                                ["principalName"],
                                            "chatId": chatDocs[i].documentID,
                                          });
                                    },
                                    child: Text(
                                      "Czat",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                    color: Colors.black,
                                  ),
                                ),
                                !chatDocs[i]["read"]
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
