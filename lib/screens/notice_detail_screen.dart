import 'package:new_emfor/widgets/list_item.dart';
import 'package:new_emfor/widgets/price_sheet.dart';
import 'package:new_emfor/widgets/notice_detail_builder.dart';
import '../providers/notice.dart';
import 'package:flutter/material.dart';

class NoticeDetailScreen extends StatelessWidget {
  static const routeName = '/notice_detail-screen';
  Notice notice;
  
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    notice = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          InfoDetailBuilder(notice: notice, height: height),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20,bottom: 12),
            child: Row(
              children: [
                Expanded(
                  child: ListItem(
                      baseText: "Zleceniodawca",
                      divider: false,
                      infoText: notice.userName),
                ),
                RaisedButton(
                  color: Colors.black,
                  onPressed: () {
                    showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25.0))),
                      isScrollControlled: true,
                      context: context,
                      builder: (ctx) {
                        return PriceSheet(notice);
                      },
                    );
                  },
                  child: Text(
                    "Wyceń usługę",
                    style: TextStyle(color: Colors.white, fontFamily: "Lato"),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
