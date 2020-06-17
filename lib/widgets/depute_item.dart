import '../screens/depute_detail_screen.dart';
import '../providers/notice.dart';
import 'package:flutter/material.dart';

class DeputeItem extends StatelessWidget {
  final Notice notice;
  DeputeItem(this.notice);
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
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    notice.createdAt,
                    style: Theme.of(context).textTheme.overline,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                          DeputeDetailScreen.routeName,
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
