import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_emfor/widgets/chat/waiting_widget.dart';
import 'package:new_emfor/widgets/confirm_dialog.dart';
import 'package:new_emfor/widgets/chat/guarantee_widget.dart';
import '../providers/read.dart';
import '../widgets/sheets/first_sheet.dart';
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
  int process = 0;
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
          title: Text(
            expertName,
            style: TextStyle(color: Colors.black),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => _onWillPop(),
          ),
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
                      "read": true,
                      "process": 0,
                    });
                  }
                  return Column(
                    children: [
                      //GuaranteeWidget(noticeId),
                      WaitingWidget(),
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
