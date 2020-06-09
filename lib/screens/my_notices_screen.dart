import 'package:flutter/material.dart';
import 'package:new_emfor/screens/my_notices_detail_screen.dart';
import '../providers/notice.dart';
import '../providers/notices.dart';
import 'package:provider/provider.dart';

class MyNoticesScreen extends StatefulWidget {
  @override
  _MyNoticesScreenState createState() => _MyNoticesScreenState();
}

class _MyNoticesScreenState extends State<MyNoticesScreen> {
  List<Notice> notices = [];
  var isLoading = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(microseconds: 0)).then((value) {
      Provider.of<Notices>(context, listen: false).fetchAndSetBid();
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    notices = Provider.of<Notices>(context).items;
    return notices.isEmpty
        ? Center(
            child: Image.asset("assets/emfor_logo.png"),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: notices.length,
            shrinkWrap: true,
            itemBuilder: (ctx, i) => Column(
              children: [
                ListTile(
                  title: Text(
                    notices[i].service,
                    style: Theme.of(context).textTheme.title,
                  ),
                  subtitle: Text(
                    notices[i].dateOfIssue,
                    style: Theme.of(context).textTheme.subtitle,
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(MyNoticesDetailScreen.routeName,arguments: notices[i]);
                  },
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
