import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_emfor/providers/chat.dart';

class Read with ChangeNotifier {
  Chat _chat;
  bool _isExpert;
  Chat get chat {
    return _chat;
  }

  void setValues({Chat chat, bool isExpert}) {
    _chat = chat;
    _isExpert = isExpert;
  }

  void setChat(Chat chat) {
    _chat = chat;
  }

  void setNotRead() {
    if (_isExpert) {
      Firestore.instance
          .collection("chat")
          .document(_chat.chatId)
          .updateData({"principalRead": false});
    } else {
      Firestore.instance
          .collection("chat")
          .document(_chat.chatId)
          .updateData({"expertRead": false});
    }
  }

  void setRead() {
    if (_isExpert) {
      Firestore.instance
          .collection("chat")
          .document(_chat.chatId)
          .updateData({"expertRead": true});
    } else {
      Firestore.instance
          .collection("chat")
          .document(_chat.chatId)
          .updateData({"principalRead": true});
    }
  }
}
