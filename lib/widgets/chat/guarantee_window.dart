import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_emfor/providers/chat.dart';
import 'package:new_emfor/providers/notice.dart';
import 'package:new_emfor/providers/read.dart';
import 'package:new_emfor/screens/chat_detail_screen.dart';
import 'package:new_emfor/widgets/button.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class GuaranteeWindow extends StatefulWidget {
  static const String routeName = "/guarantee-window";
  @override
  _GuaranteeWindowState createState() => _GuaranteeWindowState();
}

class _GuaranteeWindowState extends State<GuaranteeWindow> {
  String attentions, estimate;
  Chat chat;
  bool rules = false, loading = true;
  TextEditingController _textController;
  String _selectedDate;
  DateTime date;
  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration()).then((value) async {
      chat = Provider.of<Read>(context, listen: false).chat;
      var renegotiate = ModalRoute.of(context).settings.arguments as bool;
      if (renegotiate) {
        await Firestore.instance
            .collection("chat")
            .document(chat.chatId)
            .get()
            .then((result) {
          estimate = result.data["estimate"];
          attentions = result.data["attentions"];
          _selectedDate = result.data["meet"];
          setState(() {
            loading = false;
          });
        });
      } else {
        setState(() {
          loading = false;
        });
      }
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
        date = pickedDate;
        _selectedDate = DateFormat("dd/MM/yyyy").format(pickedDate);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Form(
          key: _form,
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
                        padding: const EdgeInsets.only(
                            right: 20, top: 12, bottom: 12),
                        child: Text(
                          "Aby gwarancja usługi obejmowała wszystkie istotne dla ciebie roboty, prosimy o wypełnienie poniższego formularza. Przed jego wypełnieniem należy skonsultować termin oraz cenę usługi wraz z wykonawcą",
                          style: TextStyle(
                              fontFamily: "OpenSans",
                              fontSize: 12,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      TextFormField(
                        initialValue: estimate,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(12.0),
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.grey[200],
                          hintText: "Wycena",
                          suffixText: "zł",
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value.isEmpty || double.parse(value) <= 50) {
                            return 'Podaj cenę większą od kwoty minimalnej (50zł)';
                          }
                          return null;
                        },
                        onSaved: (val) => estimate = val,
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
                                        _selectedDate ?? "Nie wybrałeś daty!",
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
                      TextFormField(
                        controller: _textController,
                        maxLines: 5,
                        onSaved: (val) => attentions = val,
                        keyboardType: TextInputType.text,
                        initialValue: attentions,
                        decoration: InputDecoration(
                          labelText: "Dodatkowe uwagi",
                          labelStyle: TextStyle(color: Colors.grey[700]),
                          hintText:
                              "Im więcej szczegółów tym lepsza gwarancja!",
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
                              },
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "Zapoznałem się z regulaminem",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: rules ? Colors.black : Colors.red),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10 > MediaQuery.of(context).viewInsets.bottom
                            ? 25
                            : MediaQuery.of(context).viewInsets.bottom,
                      ),
                      MyButton(
                        onPressed: () {
                          final isValid = _form.currentState.validate();
                          FocusScope.of(context).unfocus();
                          if (!isValid) {
                            return;
                          }
                          _form.currentState.save();
                          if (_selectedDate == null) {
                            Toast.show(
                              "Podaj termin spotkania",
                              context,
                              duration: Toast.LENGTH_LONG,
                            );
                            return;
                          }
                          if (!rules) {
                            Toast.show(
                              "Zaakceptuj regulamin",
                              context,
                              duration: Toast.LENGTH_LONG,
                            );
                            return;
                          }
                          Firestore.instance
                              .collection("chat")
                              .document(chat.chatId)
                              .updateData({
                            "meet": date.toString(),
                            "estimate": estimate,
                            "attentions": attentions,
                            "process": 1,
                          });
                          Navigator.pop(context);
                        },
                        text: "Wyślij ofertę",
                      ),
                    ]),
                  ),
                ),
        ),
      ),
    );
  }
}
