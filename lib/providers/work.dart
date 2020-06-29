import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_emfor/providers/categories.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Work with ChangeNotifier {
  int length = 0;
  Map<String, String> notice = {};
  Map<String, String> choices = {};
  String _question = "", subcategory;
  List<String> _options = [];
  String place, description, time;
  bool _multi;
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

  bool get multi {
    return _multi;
  }

  String get question {
    return _question;
  }

  void setSubcategory(String subcategory1) {
    choices.clear();
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
    _question = "Co się stało ?";
    _options = Categories().workData["Elektryk"].keys.toList();
    notifyListeners();
  }

  Future<void> setSubCollection(int i) async {
    length = Categories().workData["Elektryk"][subcategory].length + 3;
    _question = Categories()
        .workData["Elektryk"][subcategory]
        .keys
        .toList()
        .elementAt(i);
    var data = Categories().workData["Elektryk"][subcategory][_question];
    _options = data["options"];
    _multi = data["multi"];
    notifyListeners();
  }
}
