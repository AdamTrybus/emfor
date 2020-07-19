import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_emfor/providers/chat.dart';
import 'package:new_emfor/widgets/chat/first_process.dart';
import 'package:new_emfor/widgets/confirm_dialog.dart';
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
  String phone;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(microseconds: 0)).then((value) async {
      var prefs = await SharedPreferences.getInstance();
      phone = prefs.getString("phone");
      chat = Provider.of<Read>(context, listen: false).chat;
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
            chat != null ? chat.expertName : "",
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
                    .document(chat.chatId)
                    .snapshots(),
                builder: (ctx, chatSnapshot) {
                  if (chatSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  chat.process = chatSnapshot.data["process"];
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
                              chat.process, chat.principalPhone == phone),
                          Expanded(
                            child: ListView.builder(
                              reverse: true,
                              itemCount: chatDocs.length,
                              itemBuilder: (ctx, index) => MessageBubble(
                                chatDocs[index]["text"],
                                chatDocs[index]["userPhone"] == phone,
                              ),
                            ),
                          ),
                          NewMessage(chat.chatId, phone),
                        ],
                      );
                    },
                  );
                }),
      ),
    );
  }
}
