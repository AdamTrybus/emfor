import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String userPhone = "", chatId = "no path";
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(microseconds: 0)).then((value) async {
      var prefs = await SharedPreferences.getInstance();
      userPhone = prefs.getString("phone");
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : FutureBuilder(
            future: Firestore.instance
                .collection("chat")
                .where("phones", arrayContains: userPhone)
                .getDocuments(),
            builder: (ctx, futureSnapshot) {
              if (futureSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              List<String> contacts = [];
              futureSnapshot.data.documents.forEach((res) {
                var phones = res["phones"].toList();
                phones.remove(userPhone);
                contacts.add(phones[0]);
              });
              print(contacts);
              return ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (ctx, i) => Column(
                  children: [
                    ListTile(
                      title: Text(
                        contacts[i],
                        style: Theme.of(context).textTheme.title,
                      ),
                      onTap: (){
                        
                      },
                    ),
                    Divider(
                      thickness: 2,
                    ),
                  ],
                ),
              );
            },
          );
  }
}
