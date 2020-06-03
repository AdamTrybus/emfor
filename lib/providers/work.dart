import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Work with ChangeNotifier {
  int length = 0;
  Map<String, String> notice = {};
  String _question = "", subcategory;
  List<String> _options = [];
  String place,description,calendar;
  List<String> get options {
    return [..._options];
  }

  String get question {
    return _question;
  }

  void setSubcategory(String subcategory1) {
    subcategory = subcategory1;
  }

  void setNotice(String key, String value) {
    try {
      notice.update(key, (val) => value);
    } catch (e) {
      notice.putIfAbsent(key, () => value);
    }
    notifyListeners();
  }
  
  void publish()async{
    var prefs = await SharedPreferences.getInstance();
    notice.putIfAbsent("userPhone", () => prefs.getString("phone"));
    Firestore.instance.collection("notices").add(notice);
  }

  List<String> getChoices() {
    try {
      return notice[question].split(",");
    } catch (error) {
      return [];
    }
  }
  void setQuestion(String question){
    _question = question;
  }

  void setOptions() async {
    await Firestore.instance
        .collection("work")
        .document("Elektryk")
        .get()
        .then((value) {
      var string = value.data.values;
      String val = string.toString().replaceAll("(", ""); //removing (...)
      val = val.replaceAll(")", "");
      _question = value.data.keys.first;
      _options = val.split(",");
    });
    notifyListeners();
  }

  Future<void> setSubCollection(int i) async {
    if (length == 0) {
      await Firestore.instance
          .collection("work")
          .document("Elektryk")
          .collection(subcategory)
          .getDocuments()
          .then((value) => length = value.documents.length + 3);
      print(length);
    }
    _options = [];
    _question = "";
    await Firestore.instance
        .collection("work")
        .document("Elektryk")
        .collection(subcategory)
        .document(i.toString())
        .get()
        .then((value) {
      if (!value.exists) {
        _question = "Termin usługi";
        _options = [
          "W ciągu kilku dni",
          "W ciągu 1-2 tygodni",
          "Dostosuje się do wykonawcy",
          "Dokładna data"
        ];
      } else {
        var string = value.data.values;
        String val = string.toString().replaceAll("(", "");
        val = val.replaceAll(")", "");
        _question = value.data.keys.first;
        _options = val.split(",");
      }
    });
    notifyListeners();
  }
}