import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_emfor/providers/notice.dart';
import 'package:new_emfor/widgets/button.dart';

class GuaranteeWindow extends StatefulWidget {
  static const String routeName = "/guarantee-window";
  @override
  _GuaranteeWindowState createState() => _GuaranteeWindowState();
}

class _GuaranteeWindowState extends State<GuaranteeWindow> {
  String text, noticeId;
  bool loading = true, rules = false;
  final _priceController = TextEditingController();
  TextEditingController _textController;
  String _selectedDate = "Nie wybrałeś daty!";
  Notice notice;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration()).then((value) async {
      noticeId = ModalRoute.of(context).settings.arguments as String;
      Firestore.instance
          .collection("notices")
          .document(noticeId)
          .get()
          .then((value) {
        notice = Notice(
          id: value.documentID,
          service: value["service"],
          variety: value["variety"],
          description: value["description"] ?? "",
          files: value["files"],
          place: value["place"],
          time: value["time"],
          userPhone: value["userPhone"],
          createdAt: value["createdAt"],
          userName: value["userName"],
          userImage: value["userImage"],
        );
        text = notice.description;
        _textController = TextEditingController(text: notice.description);
        setState(() {
          loading = false;
        });
      });
    });
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 90)),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = DateFormat.yMd().format(pickedDate);
      });
    });
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
                        "Aby gwarancja usługi obejmowała wszystkie istotne dla ciebie roboty, prosimy o wypełnienie poniższego formularza. Przed jego wypełnieniem należy skonsultować termin oraz cenę usługi wraz z wykonawcą",
                        style: TextStyle(
                            fontFamily: "OpenSans",
                            fontSize: 12,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(12.0),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.grey[200],
                        hintText: "Wycena",
                        suffixText: "zł",
                      ),
                      keyboardType: TextInputType.number,
                      controller: _priceController,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 50,
                      color: Colors.grey[200],
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.date_range,
                                      size: 18.0,
                                      color: Colors.grey[600],
                                    ),
                                    Text(
                                      " $_selectedDate",
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          FlatButton(
                            onPressed: _presentDatePicker,
                            padding: EdgeInsets.all(0),
                            child: Text(
                              "Wybierz date",
                              style: TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _textController,
                      maxLines: 5,
                      onChanged: (val) => text = val,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Dodatkowe uwagi",
                        labelStyle: TextStyle(color: Colors.grey[700]),
                        hintText: "Im więcej szczegółów tym lepsza gwarancja!",
                        contentPadding: EdgeInsets.all(12.0),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
                              value: rules,
                              onChanged: (b) {
                                setState(() {
                                  rules = b;
                                });
                              }),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Zapoznałem się z regulaminem",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10 > MediaQuery.of(context).viewInsets.bottom
                          ? 25
                          : MediaQuery.of(context).viewInsets.bottom,
                    ),
                    MyButton(),
                  ]),
                ),
              ),
      ),
    );
  }
}
