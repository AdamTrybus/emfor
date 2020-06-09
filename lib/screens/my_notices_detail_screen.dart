import 'package:flutter/material.dart';
import 'package:new_emfor/screens/chat_detail_screen.dart';
import '../providers/notice.dart';

class MyNoticesDetailScreen extends StatefulWidget {
  static const routeName = "/mynoticesdetail-screen";
  @override
  _MyNoticesDetailScreenState createState() => _MyNoticesDetailScreenState();
}

class _MyNoticesDetailScreenState extends State<MyNoticesDetailScreen> {
  var prices = [];
  var phones = [];
  Notice notice;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(microseconds: 0)).then((value) {
      notice = ModalRoute.of(context).settings.arguments as Notice;
      var interests = notice.interests;
      setState(() {
        phones = interests.keys.toList() ?? [];
        prices = interests.values.toList() ?? [];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Moje Ogłoszenia"),
      ),
      body: phones.isEmpty
          ? Center(
              child: Image.asset("assets/emfor_logo.png"),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: phones.length,
              shrinkWrap: true,
              itemBuilder: (ctx, i) => Column(
                children: [
                  ListTile(
                    leading: Text(
                      prices[i],
                      style: Theme.of(context).textTheme.headline,
                    ),
                    title: Text(
                      phones[i],
                      style: Theme.of(context).textTheme.title,
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(ChatScreenDetail.routeName, arguments: {
                        "phone": phones[i],
                        "noticeId": notice.id,
                      });
                    },
                  ),
                  Divider(
                    indent: 8,
                    endIndent: 8,
                    thickness: 2,
                  ),
                ],
              ),
            ),
    );
  }
}
