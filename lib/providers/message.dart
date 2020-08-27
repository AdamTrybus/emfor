import 'package:flutter/foundation.dart';

class Message {
  final String text;
  final createdAt;
  final String userUid;

  Message({
    @required this.text,
    @required this.createdAt,
    @required this.userUid,
  });
}
