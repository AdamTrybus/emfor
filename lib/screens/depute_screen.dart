import 'package:flutter/material.dart';
import '../widgets/depute_item.dart';
import '../providers/notice.dart';
import '../providers/notices.dart';
import 'package:provider/provider.dart';

class DeputeScreen extends StatefulWidget {
  static const String routeName = "depute-screen";
  @override
  _DeputeScreenState createState() => _DeputeScreenState();
}

class _DeputeScreenState extends State<DeputeScreen> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Moje ogłoszenia"),
      ),
      body: notices.isEmpty
          ? Center(
              child: Image.asset("assets/emfor_logo.png"),
            )
          : ListView.builder(
              itemCount: notices.length,
              shrinkWrap: true,
              itemBuilder: (ctx, i) => DeputeItem(notices[i]),
            ),
    );
  }
}
