import '../widgets/notice_detail_builder.dart';
import '../providers/notice.dart';
import 'package:flutter/material.dart';

class DeputeDetailScreen extends StatelessWidget {
  static const String routeName = "mynoticedetail_screen";
  Notice notice;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    notice = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          InfoDetailBuilder(
            notice: notice,
            height: height,
          ),
          RaisedButton(
            color: Colors.black,
            onPressed: () {},
            child: Text(
              "Czat",
              style: TextStyle(color: Colors.white, fontFamily: "Lato"),
            ),
          ),
          SizedBox(
            height: 16,
          ),
        ]),
      ),
    );
  }
}
