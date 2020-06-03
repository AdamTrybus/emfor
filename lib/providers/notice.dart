import 'package:flutter/foundation.dart';

class Notice {
  final String id;
  final String service;
  final String description;
  final String files;
  final String time;
  final String place;
  final String userPhone;

  Notice({
    @required this.id,
    @required this.service,
    @required this.description,
    @required this.time,
    @required this.files,
    @required this.place,
    @required this.userPhone,
  });
}
