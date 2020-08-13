import 'package:flutter/material.dart';
import 'package:new_emfor/providers/depute.dart';

class Deputes with ChangeNotifier {
  Depute _chosenDepute;
  String _phone;
  bool side;
  bool isExert;
  String get phone {
    return _phone;
  }

  void setVal(Depute d, bool s, String p, bool i) {
    _chosenDepute = d;
    side = s;
    _phone = p;
    isExert = i;
  }

  Depute get chosenDepute {
    return _chosenDepute;
  }
}
