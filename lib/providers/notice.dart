import 'package:flutter/foundation.dart';

class Notice {
  final String id;
  final String service;
  final variety;
  final String description;
  final String files;
  final String time;
  final String place;
  final String userPhone;
  final String dateOfIssue;
  final interests;

  Notice({
    @required this.id,
    @required this.service,
    @required this.variety,
    @required this.description,
    @required this.time,
    @required this.files,
    @required this.place,
    @required this.userPhone,
    @required this.dateOfIssue,
    @required this.interests,
  });
}
