import 'package:flutter/foundation.dart';

class Notice {
  final String id;
  final String service;
  final variety;
  final String description;
  final List<dynamic> files;
  final String time;
  final String place;
  final String userUid;
  final String createdAt;
  final String userName;
  final String userImage;
  final String lat;
  final String lng;

  Notice({
    @required this.lat,
    @required this.lng,
    @required this.id,
    @required this.service,
    @required this.variety,
    @required this.description,
    @required this.time,
    @required this.files,
    @required this.place,
    @required this.userUid,
    @required this.createdAt,
    @required this.userName,
    @required this.userImage,
  });
}
