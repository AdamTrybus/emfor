import '../providers/notice.dart';
import '../providers/notices.dart';
import '../widgets/notice_item.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoticeScreen extends StatefulWidget {
  static const routeName = '/notice-screen';

  @override
  _NoticeScreenState createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(microseconds: 0)).then((value) {
      Provider.of<Notices>(context, listen: false).fetchAndSetItems().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Notice> items = Provider.of<Notices>(context).items;
    print(items.length);
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: items.length,
            shrinkWrap: true,
            itemBuilder: (ctx, i) => NoticeItem(items[i]),
          );
  }
}
