import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_emfor/providers/categories.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class Work with ChangeNotifier {
  int length = 0;
  Map<String, String> notice = {};
  Map<String, String> choices = {};
  String _question = "", _subcategory, _category;
  List<String> _options = [];
  String place, description, time;
  List<File> _files = [];
  bool _multi;
  List<String> get options {
    return [..._options];
  }

  void publish() async {
    var prefs = await SharedPreferences.getInstance();
    notice.putIfAbsent("category", () => _category);
    notice.putIfAbsent("service", () => _subcategory);
    notice.putIfAbsent("createdAt", () => DateTime.now().toString());
    notice.putIfAbsent("userPhone", () => prefs.getString("phone"));
    notice.putIfAbsent("userImage", () => prefs.getString("image"));
    notice.putIfAbsent("userName", () => prefs.getString("name"));
    var map = {"variety": choices, ...notice};
    List<String> fs = [];
    await Future.forEach(files, (File file) async {
      final ref = FirebaseStorage.instance
          .ref()
          .child(prefs.getString("phone"))
          .child("notices")
          .child(file.path.replaceAll("/", ""));
      await ref.putFile(file).onComplete;
      var url = await ref.getDownloadURL();
      fs.add(url);
    });
    if (fs.isNotEmpty) map.putIfAbsent("files", () => fs);
    Firestore.instance.collection("notices").add(map);
  }

  bool get multi {
    return _multi;
  }

  List<File> get files {
    return _files;
  }

  void setFiles(List<File> f) {
    _files = f;
  }

  String get question {
    return _question;
  }

  void setCategory(String cat) {
    _category = cat;
  }

  void setSubcategory(String subcategory1) {
    choices.clear();
    _subcategory = subcategory1;
  }

  void setNotice(String key, String value) {
    try {
      notice.update(key, (val) => value);
    } catch (e) {
      notice.putIfAbsent(key, () => value);
    }
    notifyListeners();
  }

  String getNotice() {
    try {
      return notice[question];
    } catch (error) {
      return "";
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
      var list = choices[question].split(",");
      list.removeWhere((element) => element.isEmpty);
      return list;
    } catch (error) {
      return [];
    }
  }

  void setQuestion(String question) {
    _question = question;
  }

  void setOptions() async {
    _options = Categories().workData[_category].keys.toList();
    notifyListeners();
  }

  Future<void> setSubCollection(int i) async {
    length = Categories().workData[_category][_subcategory].length + 3;
    _question = Categories()
        .workData[_category][_subcategory]
        .keys
        .toList()
        .elementAt(i);
    var data = Categories().workData[_category][_subcategory][_question];
    _options = data["options"];
    _multi = data["multi"];
    notifyListeners();
  }
}
