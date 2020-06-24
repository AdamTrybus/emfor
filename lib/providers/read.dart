import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Read with ChangeNotifier {
  String _expertPhone, _noticeId, _chatId;
  bool _isExpert;

  void setValues(
      {String expertPhone, String noticeId, String chatId, bool isExpert}) {
    _expertPhone = expertPhone;
    _noticeId = noticeId;
    _chatId = chatId;
    _isExpert = isExpert;
  }

  void setNotRead() {
    if (_isExpert) {
      Firestore.instance
          .collection("notices")
          .document(_noticeId)
          .collection("eagers")
          .document(_expertPhone)
          .updateData({"read": false});
    } else {
      Firestore.instance
          .collection("chat")
          .document(_chatId)
          .updateData({"read": false});
    }
  }

  void setRead() {
    if (_isExpert) {
      Firestore.instance
          .collection("chat")
          .document(_chatId)
          .updateData({"read": true});
    } else {
      Firestore.instance
          .collection("notices")
          .document(_noticeId)
          .collection("eagers")
          .document(_expertPhone)
          .updateData({"read": true});
    }
  }
}
