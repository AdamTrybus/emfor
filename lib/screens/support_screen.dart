import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_emfor/providers/depute.dart';
import 'package:new_emfor/providers/deputes.dart';
import 'package:new_emfor/widgets/chat/message_bubble.dart';
import 'package:new_emfor/widgets/chat/new_message.dart';
import 'package:new_emfor/widgets/support/problem_window.dart';
import 'package:new_emfor/widgets/support/report_problem.dart';
import 'package:provider/provider.dart';

class SupportScreen extends StatefulWidget {
  static const String routeName = "support-screen";
  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  Depute depute;
  String phone;
  bool loading = true;

  @override
  void _onWillPop() {
    bool expert = Provider.of<Deputes>(context, listen: false).isExpert;
    var string = expert ? "supportExpertRead" : "supportPrincipalRead";
    Firestore.instance
        .collection("chat")
        .document(depute.chatId)
        .updateData({string: true});
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(microseconds: 0)).then((value) async {
      depute = Provider.of<Deputes>(context, listen: false).chosenDepute;
      phone = Provider.of<Deputes>(context, listen: false).phone;
      if (!depute.problem) {
        Navigator.of(context).pushNamed(ReportProblem.routeName);
      }
      setState(() {
        loading = false;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text("Support"),
        leading:
            IconButton(icon: Icon(Icons.arrow_back), onPressed: _onWillPop),
        actions: [
          IconButton(
            icon: Icon(Icons.table_chart),
            onPressed: () =>
                Navigator.of(context).pushNamed(ProblemWindow.routeName),
          )
        ],
      ),
      body: WillPopScope(
        onWillPop: () {
          _onWillPop();
          return Future.value(true);
        },
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : StreamBuilder(
                stream: Firestore.instance
                    .collection("support")
                    .document("${depute.chatId}-$phone")
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
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          reverse: true,
                          shrinkWrap: true,
                          itemCount: chatDocs.length,
                          itemBuilder: (ctx, index) => MessageBubble(
                            chatDocs[index]["file"],
                            chatDocs[index]["text"],
                            chatDocs[index]["userPhone"] == phone,
                          ),
                        ),
                      ),
                      NewMessage(
                        depute.chatId,
                        phone,
                        support: true,
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
