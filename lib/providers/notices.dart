import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/notice.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notices with ChangeNotifier {
  List<Notice> _items = [];
  List<Notice> get items {
    return [..._items];
  }

  Future<void> fetchAndSetItems() async {
    _items = [];
    var prefs = await SharedPreferences.getInstance();
    String phone = prefs.getString("phone");
    final databaseReference = Firestore.instance;
    await databaseReference
        .collection("notices")
        .orderBy("createdAt", descending: true)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        dynamic notice = f.data;
        //if(notice["phone" == phone])return ;
        _items.add(Notice(
          id: f.documentID,
          service: notice["service"],
          variety: notice["variety"],
          description: notice["description"] ?? "",
          files: notice["files"] ?? [],
          place: notice["place"],
          time: notice["time"],
          userPhone: notice["userPhone"],
          createdAt: notice["createdAt"],
          userName: notice["userName"],
          userImage: notice["userImage"],
          lat: notice["lat"],
          lng: notice["lng"],
        ));
      });
    });
    notifyListeners();
  }
}
