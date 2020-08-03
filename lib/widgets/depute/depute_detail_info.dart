import 'package:flutter/material.dart';
import 'package:new_emfor/providers/chat.dart';
import 'package:new_emfor/providers/depute.dart';
import 'package:new_emfor/providers/deputes.dart';
import 'package:new_emfor/providers/notice.dart';
import 'package:new_emfor/widgets/notice_detail_builder.dart';
import 'package:provider/provider.dart';

class DeputeDetailInfo extends StatelessWidget {
  static const String routeName = "depute-info";
  Depute depute;
  Notice notice;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    depute = Provider.of<Deputes>(context, listen: false).chosenDepute;
    notice = Notice(
      id: depute.chatId,
      service: depute.noticeTitle,
      variety: depute.variety,
      description: "${depute.description}\n${depute.attentions}",
      files: depute.files,
      place: depute.place,
      time: depute.meet,
      userPhone: depute.principalPhone,
      createdAt: depute.createdAt,
      userName: depute.principalName,
      userImage: depute.principalImage,
      lat: depute.lat,
      lng: depute.lng,
    );
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          InfoDetailBuilder(notice: notice, height: height),
        ]),
      ),
    );
  }
}
