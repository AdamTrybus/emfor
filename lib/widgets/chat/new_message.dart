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
    FocusScope.of(context).unfocus();

    final databaseReference = Firestore.instance;
    await databaseReference
        .collection("chat")
        .document(widget.chatId)
        .collection("messages")
        .add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userPhone': widget.userPhone,
    });
    Provider.of<Read>(context, listen: false).setNotRead();
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      color: Colors.black87,
      child: Container(
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _controller,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: true,
                enableSuggestions: true,
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  labelText: 'Wyślij wiadomość..',
                  labelStyle: new TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _enteredMessage = value;
                  });
                },
              ),
            ),
            IconButton(
                color: Theme.of(context).primaryColor,
                icon: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
                onPressed: _enteredMessage.trim().isEmpty ? null : sendMessage)
          ],
        ),
      ),
    );
  }
}
