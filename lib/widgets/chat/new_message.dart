import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_emfor/providers/read.dart';
import 'package:provider/provider.dart';

class NewMessage extends StatefulWidget {
  final String chatId, userPhone;
  NewMessage(this.chatId, this.userPhone);
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = new TextEditingController();
  var _enteredMessage = "";

  void sendMessage() async {
    var text = _enteredMessage;
    _enteredMessage = "";
    FocusScope.of(context).unfocus();
    await Firestore.instance
        .collection("chat")
        .document(widget.chatId)
        .collection("messages")
        .add({
      'text': text,
      'createdAt': Timestamp.now(),
      'userPhone': widget.userPhone,
    });
    _controller.clear();
    Provider.of<Read>(context, listen: false).setNotRead();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 4,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Row(
            children: <Widget>[
              SizedBox(
                height: 40,
                child: FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: Colors.amber,
                  child: Icon(
                    Icons.add,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[400],
                        offset: Offset(0.0, 5.0),
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: _controller,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(12),
                      hintText: 'Wyślij wiadomość..',
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                          color: Theme.of(context).primaryColor,
                          icon: Icon(
                            Icons.send,
                            color: Colors.black,
                          ),
                          onPressed: _enteredMessage.trim().isEmpty
                              ? null
                              : sendMessage),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _enteredMessage = value;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
