import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_emfor/providers/deputes.dart';
import 'package:new_emfor/widgets/button.dart';
import 'package:new_emfor/widgets/files_picker.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class ReportProblem extends StatefulWidget {
  static const String routeName = "report-problem";
  @override
  _ReportProblemState createState() => _ReportProblemState();
}

class _ReportProblemState extends State<ReportProblem> {
  List<String> problems = [
    "Zlecenie nie zostało wykonane",
    "Wykonana praca ma wady",
    "Inne"
  ];
  List<File> files = [];
  String problem, description;
  final _form = GlobalKey<FormState>();

  void _pickedFiles(List<File> f) {
    f.forEach((file) {
      List<String> g = [];
      files.forEach((element) => g.add(element.path));
      if (!g.contains(file.path)) {
        if (file.lengthSync() > 20000000) {
          Toast.show("${file.path} - za duży rozmiar pliku", context,
              duration: 8);
        } else if (files.length >= 5) {
          Toast.show("Przekroczono liczbę plików (max 5)", context,
              duration: 8);
        } else {
          files.add(file);
        }
      }
    });
    setState(() {});
  }

  void onPressed() async {
    final isValid = _form.currentState.validate();
    FocusScope.of(context).unfocus();
    if (!isValid) {
      return;
    }
    var depute = Provider.of<Deputes>(context, listen: false).chosenDepute;
    List<String> fs = [];
    var phone = Provider.of<Deputes>(context, listen: false).phone;
    await Future.forEach(files, (File file) async {
      final ref = FirebaseStorage.instance
          .ref()
          .child(phone)
          .child("support")
          .child(file.path.replaceAll("/", ""));
      await ref.putFile(file).onComplete;
      var url = await ref.getDownloadURL();
      fs.add(url);
    });

    Firestore.instance.collection("support").document(depute.chatId).setData({
      "notifier": phone,
      "files": fs,
      "description": description,
      "problem": problem,
    });
    var list = new List.from(depute.activity);
    list.add({
      "choice": 1,
      "data": DateTime.now().toString(),
    });
    Firestore.instance.collection("chat").document(depute.chatId).updateData({
      "activity": list,
      "problem": true,
      "side": phone,
    });

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Form(
          key: _form,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Formularz zgłoszeniowy",
                  style: Theme.of(context).textTheme.headline,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Rodzaj problemu",
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                  ),
                  child: DropdownButtonFormField(
                    hint: Text("Wybierz"),
                    value: problem,
                    validator: (value) {
                      if (value == null) {
                        return 'Wybierz fach';
                      }
                      return null;
                    },
                    items: problems.map((value) {
                      return DropdownMenuItem(
                        child: Text(value),
                        value: value,
                      );
                    }).toList(),
                    isExpanded: true,
                    onChanged: (value) {
                      setState(() {
                        problem = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: TextFormField(
                    style: Theme.of(context).textTheme.subhead,
                    decoration: InputDecoration(
                      hintText: "Opis problemu",
                      contentPadding: EdgeInsets.all(12.0),
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    maxLines: 5,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Wprowadz opis';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      description = value;
                    },
                  ),
                ),
                Text(
                  "Twoje załączniki:",
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
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4, vertical: 2),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: files.length,
                            itemBuilder: (ctx, i) {
                              var l = files[i].path.split(".").last;
                              String asset = "";
                              if (l == "jpg" || l == "jpeg" || l == "png") {
                                asset = "jpg.png";
                              } else if (l == "pdf") {
                                asset = "pdf.png";
                              } else if (l == "tiff") {
                                asset = "tiff.png";
                              } else if (l == "doc") {
                                asset = "doc.png";
                              } else if (l == "txt") {
                                asset = "txt.png";
                              }
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 3.0),
                                child: Stack(children: [
                                  asset.isNotEmpty
                                      ? Image.asset(
                                          "assets/$asset",
                                          fit: BoxFit.cover,
                                          height: 70,
                                          width: 50,
                                        )
                                      : SizedBox(),
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    child: InkWell(
                                      onTap: () {
                                        setState(
                                          () {
                                            files.remove(files[i]);
                                          },
                                        );
                                      },
                                      child: Icon(
                                        Icons.cancel,
                                      ),
                                    ),
                                  ),
                                ]),
                              );
                            }),
                      ),
                      if (files.length < 5) FilesPicker(_pickedFiles),
                    ],
                  ),
                ),
                Expanded(child: SizedBox()),
                MyButton(
                  onPressed: onPressed,
                  text: "Zgłoś problem",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
