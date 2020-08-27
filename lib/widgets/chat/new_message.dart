import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_emfor/providers/read.dart';
import 'package:provider/provider.dart';

class NewMessage extends StatefulWidget {
  final String chatId, userUid, userName, respository;
  bool support;
  NewMessage(this.chatId, this.userUid, this.userName, this.respository,
      {this.support = false});
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
        .collection(widget.support ? "support" : "chat")
        .document(widget.chatId)
        .collection("messages")
        .add({
      'text': text,
      'createdAt': Timestamp.now(),
      'userUid': widget.userUid,
      "userName": widget.userName,
      "topic": widget.chatId.replaceAll("+", ""),
      "respository": widget.respository,
    });
    _controller.clear();
    Provider.of<Read>(context, listen: false).setNotRead();
  }

  void sendFile(File file) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child(widget.chatId)
        .child(file.path.replaceAll("/", ""));
    await ref.putFile(file).onComplete;
    var url = await ref.getDownloadURL();
    await Firestore.instance
        .collection(widget.support ? "support" : "chat")
        .document(widget.chatId)
        .collection("messages")
        .add({
      'file': url,
      'createdAt': Timestamp.now(),
      'userUid': widget.userUid,
      "userName": widget.userName,
      "topic": widget.chatId.replaceAll("+", ""),
      "respository": widget.respository,
    });
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
                  onPressed: () async {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (ctx) {
                          return SizedBox(
                            height: 120,
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text("Aparat"),
                                  onTap: () async {
                                    Navigator.of(context).pop();
                                    final file = await ImagePicker.pickImage(
                                        source: ImageSource.camera);
                                    sendFile(file);
                                  },
                                ),
                                ListTile(
                                  title: Text("Zapisane"),
                                  onTap: () async {
                                    Navigator.of(context).pop();
                                    var file = await FilePicker.getFile(
                                        type: FileType.custom,
                                        allowedExtensions: [
                                          "tiff",
                                          "jpg",
                                          "jpeg",
                                          "doc",
                                          "pdf",
                                          "png",
                                          "txt",
                                          "mp4",
                                          "webm",
                                          "mp3"
                                        ]);
                                    sendFile(file);
                                  },
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  backgroundColor: Colors.amber,
                  child: Icon(
                    Icons.add,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  constraints: BoxConstraints(minHeight: 45),
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
                    minLines: 1,
                    maxLines: 3,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(12),
                      isDense: true,
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
