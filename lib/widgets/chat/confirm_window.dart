import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_emfor/providers/chat.dart';
import 'package:new_emfor/providers/read.dart';
import 'package:new_emfor/screens/chat_detail_screen.dart';
import 'package:provider/provider.dart';

class ConfirmWindow extends StatefulWidget {
  static const String routeName = "/confirm-window";
  @override
  _ConfirmWindowState createState() => _ConfirmWindowState();
}

class _ConfirmWindowState extends State<ConfirmWindow> {
  String attentions, estimate, day;
  Chat chat;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration()).then((_) async {
      chat = Provider.of<Read>(context, listen: false).chat;
      await Firestore.instance
          .collection("chat")
          .document(chat.chatId)
          .get()
          .then((result) {
        estimate = result.data["estimate"];
        attentions = result.data["attentions"];
        day = DateFormat("dd/MM/yyyy")
            .format(DateTime.parse(result.data["meet"]));
        setState(() {
          loading = false;
        });
      });
    });
  }

  void onPress(bool accept) {
    Firestore.instance
        .collection("chat")
        .document(chat.chatId)
        .updateData({"process": accept ? 3 : 2});

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                child: SingleChildScrollView(
                  child: Column(children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: FloatingActionButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.arrow_back,
                          size: 50,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Gwarancja usługi",
                        style: Theme.of(context).textTheme.headline,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 20, top: 12, bottom: 12),
                      child: Text(
                        "Zleceniodawca przysłał ofertę. Na podstawie dostępnych informacji zostanie spisana umowa, na której podstawie będzie działała gwarancja. Zatwierdzając zgadasz się na regulamin oraz postanowienia zawarte w niej. Więcej informacji na www.emfor.com",
                        style: TextStyle(
                            fontFamily: "Quicksand",
                            fontSize: 12,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                    TextFormField(
                      initialValue: estimate,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(12.0),
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.payment),
                        enabled: false,
                        filled: true,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      initialValue: day,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(12.0),
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.date_range),
                        enabled: false,
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      initialValue: attentions,
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: "Dodatkowe uwagi",
                        enabled: false,
                        labelStyle: TextStyle(color: Colors.grey[700]),
                        contentPadding: EdgeInsets.all(12.0),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                    SizedBox(
                      height: 10 > MediaQuery.of(context).viewInsets.bottom
                          ? 25
                          : MediaQuery.of(context).viewInsets.bottom,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: RaisedButton(
                              color: Colors.white,
                              textColor: Colors.teal,
                              onPressed: () => onPress(false),
                              elevation: 4,
                              child: Text(
                                "Odrzuć",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: "Quicksand"),
                              ),
                              shape: RoundedRectangleBorder(
                                  side:
                                      BorderSide(color: Colors.teal, width: 2)),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: RaisedButton(
                              color: Colors.teal,
                              onPressed: () => onPress(true),
                              elevation: 4,
                              textColor: Colors.white,
                              child: Text(
                                "Akceptuj",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: "Quicksand"),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ]),
                ),
              ),
      ),
    );
  }
}
