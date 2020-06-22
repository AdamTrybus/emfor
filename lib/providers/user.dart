import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:new_emfor/widgets/change_profile.dart';

class User with ChangeNotifier {
  String _name, _gmail, _phone, _imageUrl;
  String _category, _description;
  bool _expert;
  void setBasic(
      {String name, String gmail, String phone, String imageUrl, bool expert}) {
    _name = name;
    _gmail = gmail;
    _phone = phone;
    _imageUrl = imageUrl;
    _expert = expert;
  }
  void setExpert({String category, String description, bool expert}){
    _category = category;
    _description = description;
    _expert = expert;
  }
}
