import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_emfor/providers/chat.dart';
import 'package:new_emfor/providers/read.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../chat_detail_screen.dart';

class PrincipalChat extends StatefulWidget {
  @override
  _PrincipalChatState createState() => _PrincipalChatState();
}

class _PrincipalChatState extends State<PrincipalChat> {
  final List<Chat> notices = [];
  var range;
  final ids = [];
  var isLoading = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(microseconds: 0)).then((value) async {
      var prefs = await SharedPreferences.getInstance();
      var experts = await Firestore.instance
          .collectionGroup("eagers")
          .where("principal", isEqualTo: prefs.getString("phone"))
          .getDocuments();

      experts.documents.forEach((element) {
        Chat chat = Chat(
            expertImage: element["expertImage"],
            expertName: element["expertName"],
            estimate: element["estimate"],
            noticeTitle: element["noticeTitle"],
            noticeId: element["noticeId"],
            expertPhone: element["expertPhone"],
            principal: element["principal"],
            createdAt: element["createdAt"],
            read: element["read"]);

        var map = {
          "id": chat.noticeId,
          "title": chat.noticeTitle,
          "createdAt": chat.createdAt,
        };
        if (!ids.contains(map)) {
          ids.add(map);
        }
        notices.add(chat);
      });
      setState(() {
        isLoading = false;
      });
    });
  }

  int idsLength(i) {
    range =
        notices.where((element) => element.noticeId == ids[i]["id"]).toList();
    return range.length;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : 
        ListView.builder(
            itemCount: ids.length,
            itemBuilder: (ctx, i) => ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              ids[i]["title"],
                              style: TextStyle(
                                fontFamily: "Quicksand",
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.amber[500],
                            padding: EdgeInsets.all(6),
                            child: Text(
                              ids[i]["createdAt"],
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.black38,
                        thickness: 2,
                        endIndent: 4,
                        indent: 4,
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  itemCount: idsLength(i),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (ctx, x) => Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: range[x].expertImage != null
                                ? NetworkImage(
                                    range[x].expertImage,
                                  )
                                : AssetImage(
                                    "assets/user_image.png",
                                  ),
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    range[x].expertName,
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.button,
                                  ),
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: AlignmentDirectional.centerStart,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        range[x].estimate,
                                        maxLines: 1,
                                        textAlign: TextAlign.left,
                                        style:
                                            Theme.of(context).textTheme.subhead,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              RaisedButton(
                                color: Colors.black,
                                onPressed: () {
                                  Provider.of<Read>(context, listen: false)
                                      .setValues(
                                    chatId:
                                        "${ids[x]["id"]}-${range[x].expertPhone}",
                                    expertPhone: range[x].expertPhone,
                                    isExpert: false,
                                    noticeId: ids[x]["id"],
                                  );
                                  Navigator.of(context).pushNamed(
                                      ChatScreenDetail.routeName,
                                      arguments: {
                                        "noticeId": ids[x]["id"],
                                        "noticeTitle": ids[x]["title"],
                                        "phone": range[x].expertPhone,
                                        "name": range[x].expertName,
                                      });
                                },
                                child: Text(
                                  "Czat",
                                  style: TextStyle(
                                      color: Colors.white, fontFamily: "Lato"),
                                ),
                              ),
                              !range[x].read
                                  ? Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                        padding: EdgeInsets.all(6.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.amber[800],
                                        ),
                                        constraints: BoxConstraints(
                                          minWidth: 16,
                                          minHeight: 16,
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
