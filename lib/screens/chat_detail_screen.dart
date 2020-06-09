import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_emfor/widgets/chat/new_message.dart';
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
      chatId = "no path",
      _selectedDate = "Wybierz termin",
      noticeId;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(microseconds: 0)).then((value) async {
      var map =
          ModalRoute.of(context).settings.arguments as Map<String, Object>;
      expertPhone = map["phone"];
      noticeId = map["noticeId"];
      var prefs = await SharedPreferences.getInstance();
      userPhone = prefs.getString("phone");
      setState(() {
        isLoading = false;
      });
    });
  }

  void _datePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 120)),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = DateFormat.yMMMd().format(pickedDate);
      });
      Firestore.instance
          .collection("notices")
          .document(noticeId)
          .updateData({"date": _selectedDate});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(expertPhone),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: FlatButton(
            onPressed: _datePicker,
            child: Text(
              _selectedDate,
              style: Theme.of(context).textTheme.body1,
            ),
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : FutureBuilder(
              future: Firestore.instance
                  .collection("chat")
                  .where("principal", isEqualTo: userPhone)
                  .where("expert", isEqualTo: expertPhone)
                  .getDocuments(),
              builder: (ctx, futureSnapshot) {
                if (futureSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (futureSnapshot.data.documents.isNotEmpty) {
                  chatId = futureSnapshot.data.documents.first.documentID;
                }
                return StreamBuilder(
                  stream: Firestore.instance
                      .collection("chat")
                      .document(chatId)
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
                    var chatDocs = [];
                    if (chatSnapshot.data.documents.isNotEmpty) {
                      chatDocs = chatSnapshot.data.documents;
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
                        NewMessage(chatId, userPhone, expertPhone),
                      ],
                    );
                  },
                );
              },
            ),
    );
  }
}
