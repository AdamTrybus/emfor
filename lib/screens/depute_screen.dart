import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_emfor/providers/depute.dart';
import 'package:new_emfor/providers/deputes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/depute/depute_item.dart';
import 'package:provider/provider.dart';

class DeputeScreen extends StatefulWidget {
  static const String routeName = "depute-screen";
  @override
  _DeputeScreenState createState() => _DeputeScreenState();
}

class _DeputeScreenState extends State<DeputeScreen> {
  List<Depute> chats = [];
  String phone = "";
  var isLoading = true, expert;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(microseconds: 0)).then((value) async {
      var prefs = await SharedPreferences.getInstance();
      phone = prefs.getString("phone");
      expert = prefs.getBool("expert");
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Moje ogłoszenia"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : StreamBuilder(
              stream: Firestore.instance
                  .collection("chat")
                  .where(expert ? "expertPhone" : "principalPhone",
                      isEqualTo: phone)
                  .where("process", isGreaterThanOrEqualTo: 4)
                  .orderBy("process", descending: true)
                  .orderBy("createdAt", descending: true)
                  .snapshots(),
              builder: (ctx, deputeSnapshot) {
                if (deputeSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                chats = [];
                deputeSnapshot.data.documents.forEach(
                  (element) {
                    chats.add(
                      Depute(
                        chatId: element.documentID,
                        expertImage: element["expertImage"],
                        expertName: element["expertName"],
                        noticeTitle: element["noticeTitle"],
                        noticeId: element["noticeId"],
                        expertPhone: element["expertPhone"],
                        principalPhone: element["principalPhone"],
                        createdAt: element["createdAt"],
                        expertRead: element["expertRead"],
                        principalImage: element["principalImage"],
                        principalName: element["principalName"],
                        principalRead: element["principalRead"],
                        process: element["process"],
                        attentions: element["attentions"],
                        estimate: element["estimate"],
                        meet: element["meet"],
                        description: element["description"],
                        files: element["files"],
                        lat: element["lat"],
                        lng: element["lng"],
                        place: element["place"],
                        variety: element["variety"],
                        cancel: element["cancel"],
                        problem: element["problem"] ?? false,
                        activity: element["activity"] ?? [],
                        supportExpertRead: element["supportExpertRead"] ?? true,
                        supportPrincipalRead:
                            element["supportPrincipalRead"] ?? true,
                      ),
                    );
                  },
                );
                return ListView.builder(
                  itemCount: chats.length,
                  shrinkWrap: true,
                  itemBuilder: (ctx, i) =>
                      DeputeItem(chats[i], phone == chats[i].expertPhone),
                );
              },
            ),
    );
  }
}
