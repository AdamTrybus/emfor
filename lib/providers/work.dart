import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Work with ChangeNotifier {
  int length = 0;
  Map<String, String> notice = {};
  Map<String, String> choices = {};
  String _question = "", subcategory;
  List<String> _options = [];
  String place, description, time;
  List<String> get options {
    return [..._options];
  }

  void publish() async {
    var prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    var dateString = DateFormat.yMMMMd().format(now);
    notice.putIfAbsent("createdAt", () => dateString);
    notice.putIfAbsent("userPhone", () => prefs.getString("phone"));
    notice.putIfAbsent("userImage", () => prefs.getString("image"));
    notice.putIfAbsent("userName", () => prefs.getString("name"));
    Firestore.instance
        .collection("notices")
        .add({"variety": choices, ...notice});
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

  List<String> getNotice() {
    try {
      return notice[question].split(",");
    } catch (error) {
      return [];
    }
  }

  void setChoices(String key, String value) {
    try {
      choices.update(key, (val) => value);
    } catch (e) {
      choices.putIfAbsent(key, () => value);
    }
    notifyListeners();
  }

  List<String> getChoices() {
    try {
      return choices[question].split(",");
    } catch (error) {
      return [];
    }
  }

  void setQuestion(String question) {
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
