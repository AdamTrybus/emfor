import 'package:flutter/foundation.dart';

class Message {
  final String text;
  final createdAt;
  final String userPhone;

  Message({@required this.text, @required this.createdAt,
      @required this.userPhone,});
}
