import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_emfor/providers/depute.dart';

class Deputes with ChangeNotifier {
  Depute _chosenDepute;
  String _phone;
  bool side;
  bool isExpert;
  String get phone {
    return _phone;
  }

  void setVal(Depute d, bool s, String p, bool i) {
    _chosenDepute = d;
    side = s;
    _phone = p;
    isExpert = i;
  }

  Depute get chosenDepute {
    return _chosenDepute;
  }

  List getActivities() {
    List activities = [];

    activities.add(
      {
        "text": "Oczekiwanie na termin zlecenia",
        "data": DateFormat("dd/MM/yyyy HH:mm")
            .format(DateTime.parse(_chosenDepute.createdAt)),
      },
    );

    if (!_chosenDepute.cancel) {
      var dt = DateTime.parse(_chosenDepute.meet);
      activities.add(
        {
          "text": "Termin wykonania zlecenia",
          "data": DateFormat("dd/MM/yyyy HH:mm")
              .format(DateTime.parse(_chosenDepute.meet)),
        },
      );
      activities.add(
        {
          "text": "Czas gwarancji - zgłaszanie ew uwag",
          "data":
              DateFormat("dd/MM/yyyy HH:mm").format(dt.add(Duration(days: 1))),
        },
      );
      activities.add(
        {
          "text": "Pieniądze wypłacone wykonawcy - koniec okresu gwarancji",
          "data":
              DateFormat("dd/MM/yyyy HH:mm").format(dt.add(Duration(days: 7))),
        },
      );
    }
    _chosenDepute.activity.forEach((element) {
      var text;
      var color;
      if (element["choice"] == 0) {
        text = "Oferta została odwołana";
        color = Colors.red[200];
      } else if (element["choice"] == 1) {
        text = "Został zgłoszony problem";
        color = Colors.amber[200];
      } else if (element["choice"] == 2) {
        text = "Oferta została renegocjonowana";
        color = Colors.cyan[200];
      }

      activities.add(
        {
          "text": text,
          "data": DateFormat("dd/MM/yyyy HH:mm")
              .format(DateTime.parse(element["data"])),
          "color": color,
        },
      );
    });

    activities.sort((a, b) {
      var one = DateFormat("dd/MM/yyyy HH:mm").parse(a["data"]);
      var two = DateFormat("dd/MM/yyyy HH:mm").parse(b["data"]);
      if (one.isAfter(two))
        return 1;
      else if (one.isAtSameMomentAs(two))
        return 0;
      else
        return -1;
    });

    return activities;
  }

  Map currentActivity() {
    List activities = getActivities();
    var current = {
      ...activities[0],
      "first": true,
    };
    var i = 0;
    activities.forEach((element) {
      var d = DateFormat("dd/MM/yyyy HH:mm").parse(element["data"]);
      var b = DateFormat("dd/MM/yyyy HH:mm").parse(current["data"]);
      bool before = d.isBefore(DateTime.now());
      bool after = d.isAfter(b);
      if (before && after) {
        var map = element;
        if (i == 0) {
          map.putIfAbsent("first", () => true);
        } else if (i == activities.length - 1) {
          map.putIfAbsent("last", () => true);
        }
        current = map;
      }
      i++;
    });
    return current;
  }
}
