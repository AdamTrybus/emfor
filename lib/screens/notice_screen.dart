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
  bool _isInit = true, _isLoading = true;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      Provider.of<Notices>(context).fetchAndSetItems().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    List<Notice> items = Provider.of<Notices>(context).items;
    print(items.length);
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : GridView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 30,
            ),
            itemBuilder: (ctx, i) => NoticeItem(items[i]),
          );
  }
}
