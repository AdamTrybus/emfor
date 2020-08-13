import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_emfor/providers/chat.dart';
import 'package:new_emfor/providers/read.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../chat_detail_screen.dart';

class PrincipalChat extends StatefulWidget {
  @override
  _PrincipalChatState createState() => _PrincipalChatState();
}

class _PrincipalChatState extends State<PrincipalChat> {
  final List<Chat> notices = [];
  var range;
  final ids = [];
  var isLoading = true;
  var phone = "";
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

  int idsLength(i) {
    range =
        notices.where((element) => element.noticeId == ids[i]["id"]).toList();
    return range.length;
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
                .where("principalPhone", isEqualTo: phone)
                .where("process", isLessThan: 4)
                .orderBy("process", descending: true)
                .orderBy("createdAt", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              notices.clear();
              ids.clear();
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
                var map = {
                  "id": chat.noticeId,
                  "title": chat.noticeTitle,
                  "createdAt": chat.createdAt,
                };
                if (!ids.contains(map)) {
                  ids.add(map);
                }
                notices.add(chat);
              });
              return ListView.builder(
                  itemCount: ids.length,
                  itemBuilder: (ctx, i) => ListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        ids[i]["title"],
                                        style: TextStyle(
                                          fontFamily: "Quicksand",
                                          fontSize: 19,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      color: Colors.amber[500],
                                      padding: EdgeInsets.all(6),
                                      child: Text(
                                        ids[i]["createdAt"],
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: Colors.black38,
                                  thickness: 2,
                                  endIndent: 4,
                                  indent: 4,
                                ),
                              ],
                            ),
                          ),
                          ListView.builder(
                            itemCount: idsLength(i),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (ctx, x) => Card(
                              elevation: 8,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          range[x].expertImage != null
                                              ? NetworkImage(
                                                  range[x].expertImage,
                                                )
                                              : AssetImage(
                                                  "assets/user_image.png",
                                                ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        range[x].expertName,
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                            Theme.of(context).textTheme.button,
                                      ),
                                    ),
                                    Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: RaisedButton(
                                            color: Colors.black,
                                            onPressed: () {
                                              range = notices
                                                  .where((element) =>
                                                      element.noticeId ==
                                                      ids[i]["id"])
                                                  .toList();
                                              Provider.of<Read>(context,
                                                      listen: false)
                                                  .setValues(
                                                chat: range[x],
                                                isExpert: false,
                                              );
                                              Navigator.of(context).pushNamed(
                                                  ChatScreenDetail.routeName);
                                            },
                                            child: Text(
                                              "Czat",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: "Lato"),
                                            ),
                                          ),
                                        ),
                                        !range[x].principalRead
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
                              ),
                            ),
                          ),
                        ],
                      ));
            });
  }
}
