import '../providers/notice.dart';
import '../screens/notice_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NoticeItem extends StatelessWidget {
  final Notice notice;
  NoticeItem(this.notice);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              child: Image.asset(
                "assets/emfor_logo.png",
                scale: 60,
              ),
            ),
            title: Text(
              notice.service,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontFamily: "OpenSans",
              ),
            ),
            subtitle: Text(
              notice.place,
              style: TextStyle(
                fontFamily: "Lato",
                fontSize: 12,
              ),
            ),
            trailing: RaisedButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(NoticeDetailScreen.routeName, arguments: notice);
              },
              child: Text(
                "szczegóły",
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w400,
                    fontSize: 14),
              ),
              color: Colors.amber[400],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
          ),
          Divider(
            indent: 8,
            endIndent: 8,
            thickness: 2,
          ),
        ],
      ),
    );
  }
}
