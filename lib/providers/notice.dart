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
  final String createdAt;
  final String userName;
  final String userImage;

  Notice({
    @required this.id,
    @required this.service,
    @required this.variety,
    @required this.description,
    @required this.time,
    @required this.files,
    @required this.place,
    @required this.userPhone,
    @required this.createdAt,
    @required this.userName,
    @required this.userImage,
  });
}
