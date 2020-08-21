import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_emfor/providers/depute.dart';
import 'package:new_emfor/providers/deputes.dart';
import 'package:new_emfor/widgets/display_file.dart';
import 'package:provider/provider.dart';

class ProblemWindow extends StatelessWidget {
  static const String routeName = "problem-window";
  String problem, description;
  Depute depute;
  List files = [];
  @override
  Widget build(BuildContext context) {
    depute = Provider.of<Deputes>(context, listen: false).chosenDepute;
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: Firestore.instance
              .collection("support")
              .document(depute.chatId)
              .snapshots(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            files = snapshot.data["files"] ?? [];
            description = snapshot.data["description"];
            problem = snapshot.data["problem"];
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        size: 50,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Zgłoszony problem",
                    style: Theme.of(context).textTheme.headline,
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Text(
                    "Problem:",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 13,
                        fontFamily: "OpenSans",
                        fontWeight: FontWeight.w300),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Container(
                    child: Text(
                      problem,
                      style: Theme.of(context).textTheme.title,
                    ),
                    padding: EdgeInsets.all(12.0),
                    color: Colors.grey[200],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Opis:",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 13,
                        fontFamily: "OpenSans",
                        fontWeight: FontWeight.w300),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Container(
                    constraints: BoxConstraints(minHeight: 150),
                    child: Text(
                      description,
                      style: Theme.of(context).textTheme.title,
                    ),
                    padding: EdgeInsets.all(12.0),
                    color: Colors.grey[200],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Załączniki:",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 13,
                        fontFamily: "OpenSans",
                        fontWeight: FontWeight.w300),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  SizedBox(
                    height: 70,
                    child: ListView.builder(
                        //padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: files.length,
                        itemBuilder: (ctx, i) {
                          var url = files[i];
                          return DisplayFile(url);
                        }),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
