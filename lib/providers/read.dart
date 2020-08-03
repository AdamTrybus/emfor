import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_emfor/providers/chat.dart';

class Read with ChangeNotifier {
  Chat _chat;
  String _chatId;
  bool _isExpert, _expanded = true;
  bool get isExpert {
    return _isExpert;
  }

  bool get expanded {
    return _expanded;
  }

  void setExpanded() {
    _expanded = !expanded;
    notifyListeners();
  }

  Chat get chat {
    return _chat;
  }

  void setVal(String chatId, bool isExpert) {
    _chatId = chatId;
    _isExpert = isExpert;
  }

  void setValues({
    Chat chat,
    bool isExpert,
  }) {
    _chat = chat;
    _chatId = chat.chatId;
    _isExpert = isExpert;
  }

  void setChat(Chat chat) {
    _chat = chat;
    _chatId = chat.chatId;
  }

  void setNotRead() {
    if (_isExpert) {
      Firestore.instance
          .collection("chat")
          .document(_chatId)
          .updateData({"principalRead": false});
    } else {
      Firestore.instance
          .collection("chat")
          .document(_chatId)
          .updateData({"expertRead": false});
    }
  }

  void setRead() {
    if (_isExpert) {
      Firestore.instance
          .collection("chat")
          .document(_chatId)
          .updateData({"expertRead": true});
    } else {
      Firestore.instance
          .collection("chat")
          .document(_chatId)
          .updateData({"principalRead": true});
    }
  }
}
