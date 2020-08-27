import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:new_emfor/providers/chat.dart';
import 'package:new_emfor/screens/profile_screen.dart';
import 'package:new_emfor/screens/questions_screen.dart';
import 'package:new_emfor/widgets/chat/guarantee_widget.dart';
import '../providers/read.dart';
import 'package:provider/provider.dart';
import '../widgets/chat/new_message.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/chat/message_bubble.dart';

class ChatScreenDetail extends StatefulWidget {
  static const routeName = "/chatdetail-screen";
  @override
  _ChatScreenDetailState createState() => _ChatScreenDetailState();
}

class _ChatScreenDetailState extends State<ChatScreenDetail> {
  Chat chat;
  bool isLoading = true;
  bool isExpert = false;
  String uid, chatId, name = "";

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(microseconds: 0)).then((value) async {
      var prefs = await SharedPreferences.getInstance();
      uid = prefs.getString("uid");
      chatId = ModalRoute.of(context).settings.arguments;
      var pushUp = prefs.getBool("pushUp") ?? true;
      if (pushUp) {
        final fbm = FirebaseMessaging();
        fbm.subscribeToTopic(chatId);
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  void _onWillPop() async {
    Provider.of<Read>(context, listen: false).setRead();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _onWillPop();
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: FlatButton(
            onPressed: isExpert
                ? null
                : () => Navigator.of(context)
                    .pushNamed(ProfileScreen.routeName, arguments: uid),
            child: Text(
              isLoading ? "" : name,
              style: TextStyle(color: Colors.black),
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => _onWillPop(),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.flag),
              onPressed: () =>
                  Navigator.of(context).pushNamed(QuestionsScreen.routeName),
            ),
            IconButton(
              icon: Icon(Icons.more_horiz),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        elevation: 4,
                        content: Text(
                          "Czy napewno chcesz usunąć konwersacje ?",
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
                                Firestore.instance
                                    .collection("chat")
                                    .document(chat.chatId)
                                    .delete();
                                int count = 0;
                                Navigator.of(context)
                                    .popUntil((_) => count++ >= 2);
                              },
                              child: Text(
                                "Tak",
                                style: Theme.of(context).textTheme.title,
                              ))
                        ],
                      );
                    });
              },
            ),
          ],
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : StreamBuilder(
                stream: Firestore.instance
                    .collection("chat")
                    .document(chatId)
                    .snapshots(),
                builder: (ctx, chatSnapshot) {
                  if (chatSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  var element = chatSnapshot.data;
                  chat = Chat(
                    chatId: element.documentID,
                    expertImage: element["expertImage"],
                    expertName: element["expertName"],
                    noticeTitle: element["noticeTitle"],
                    noticeId: element["noticeId"],
                    expertUid: element["expertUid"],
                    principalUid: element["principalUid"],
                    createdAt: element["createdAt"],
                    expertRead: element["expertRead"],
                    principalImage: element["principalImage"],
                    principalName: element["principalName"],
                    principalRead: element["principalRead"],
                    process: element["process"],
                  );
                  isExpert = uid == chat.expertUid;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (name == "") {
                      setState(() {
                        name = isExpert ? chat.principalName : chat.expertName;
                      });
                    }
                  });
                  Provider.of<Read>(context, listen: false)
                      .setValues(chat: chat, isExpert: isExpert);
                  return StreamBuilder(
                    stream: Firestore.instance
                        .collection("chat")
                        .document(chat.chatId)
                        .collection("messages")
                        .orderBy("createdAt", descending: true)
                        .snapshots(),
                    builder: (ctx, chatSnapshot) {
                      if (chatSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      var chatDocs = chatSnapshot.data.documents ?? [];
                      return Column(
                        children: [
                          GuaranteeWidget(
                              chat.process, chat.principalUid == uid),
                          Expanded(
                            child: ListView.builder(
                              reverse: true,
                              itemCount: chatDocs.length,
                              itemBuilder: (ctx, index) => MessageBubble(
                                chatDocs[index]["file"],
                                chatDocs[index]["text"],
                                chatDocs[index]["userUid"] == uid,
                              ),
                            ),
                          ),
                          NewMessage(
                              chat.chatId,
                              uid,
                              isExpert ? chat.expertName : chat.principalName,
                              "chat"),
                        ],
                      );
                    },
                  );
                }),
      ),
    );
  }
}
