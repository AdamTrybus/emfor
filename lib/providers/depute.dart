import 'package:flutter/cupertino.dart';

class Depute {
  final String chatId;
  final String expertImage;
  final String expertName;
  final String noticeTitle;
  final String noticeId;
  final String expertPhone;
  final String principalPhone;
  final String createdAt;
  final bool expertRead;
  final bool supportExpertRead;
  final String principalImage;
  final String principalName;
  final bool principalRead;
  final bool supportPrincipalRead;
  int process;
  final String estimate;
  final String meet;
  final String attentions;
  final String lat;
  final String lng;
  final variety;
  final String description;
  final List<dynamic> files;
  final String place;
  final bool cancel;
  final bool problem;
  final List activity;

  Depute({
    @required this.supportExpertRead,
    @required this.supportPrincipalRead,
    @required this.lat,
    @required this.lng,
    @required this.variety,
    @required this.description,
    @required this.files,
    @required this.place,
    @required this.estimate,
    @required this.meet,
    @required this.attentions,
    @required this.chatId,
    @required this.expertImage,
    @required this.expertName,
    @required this.noticeTitle,
    @required this.noticeId,
    @required this.expertPhone,
    @required this.principalPhone,
    @required this.createdAt,
    @required this.expertRead,
    @required this.principalImage,
    @required this.principalName,
    @required this.principalRead,
    @required this.process,
    @required this.cancel,
    @required this.problem,
    @required this.activity,
  });
}
