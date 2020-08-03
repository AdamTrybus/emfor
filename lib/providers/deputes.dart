import 'package:flutter/material.dart';
import 'package:new_emfor/providers/depute.dart';

class Deputes with ChangeNotifier {
  Depute _chosenDepute;
  String _phone;
  bool side;
  String get phone {
    return _phone;
  }

  void setVal(Depute d, bool s, String p) {
    _chosenDepute = d;
    side = s;
    _phone = p;
  }

  Depute get chosenDepute {
    return _chosenDepute;
  }
}
