import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_emfor/providers/read.dart';
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
  String expertPhone = "",
      userPhone = "",
      chatId = "",
      noticeId,
      expertName = "",
      userName = "",
      userImage = "",
      title = "";
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(microseconds: 0)).then((value) async {
      var map =
          ModalRoute.of(context).settings.arguments as Map<String, Object>;
      expertPhone = map["phone"];
      noticeId = map["noticeId"];
      expertName = map["name"];
      title = map["noticeTitle"];
      chatId = map["chatId"] ?? "$noticeId-$expertPhone";
      var prefs = await SharedPreferences.getInstance();
      userPhone = prefs.getString("phone");
      userName = prefs.getString("name");
      userImage = prefs.getString("image");
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<bool> _onWillPop() async {
    Provider.of<Read>(context, listen: false).setRead();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(expertName),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : StreamBuilder(
                stream: Firestore.instance
                    .collection("chat")
                    .document(chatId)
                    .collection("messages")
                    .orderBy("createdAt", descending: true)
                    .snapshots(),
                builder: (ctx, chatSnapshot) {
                  if (chatSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  var chatDocs = chatSnapshot.data.documents ?? [];
                  if (chatSnapshot.data.documents.isEmpty) {
                    Firestore.instance
                        .collection("chat")
                        .document(chatId)
                        .setData({
                      "title": title,
                      "id": noticeId,
                      "principalName": userName,
                      "principalImage": userImage,
                      "expert": expertPhone,
                    });
                  }
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          reverse: true,
                          itemCount: chatDocs.length,
                          itemBuilder: (ctx, index) => MessageBubble(
                            chatDocs[index]["text"],
                            chatDocs[index]["userPhone"] == userPhone,
                          ),
                        ),
                      ),
                      NewMessage(chatId, userPhone),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
