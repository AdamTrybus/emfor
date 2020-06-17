import '../providers/notice.dart';
import '../screens/notice_detail_screen.dart';
import 'package:flutter/material.dart';

class NoticeItem extends StatelessWidget {
  final Notice notice;
  NoticeItem(this.notice);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notice.service,
              style: TextStyle(
                fontFamily: "Quicksand",
                fontSize: 22,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              notice.place ?? "",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  fontFamily: "OpenSans"),
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                        notice.userImage,
                      ) ??
                      Image.asset(
                        "assets/user_image.png",
                      ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: "Zleceniodawca \n",
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: notice.userName,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                          NoticeDetailScreen.routeName,
                          arguments: notice);
                    },
                    child: Text(
                      "Szczegóły",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
