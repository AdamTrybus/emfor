import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:toast/toast.dart';
import '../widgets/files_picker.dart';
import './user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import '../widgets/button.dart';
import 'package:provider/provider.dart';

class PersonalInfo extends StatefulWidget {
  static const routeName = "/personal-info";

  @override
  _PersonalInfoState createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo>
    with TickerProviderStateMixin {
  String gmail, name, description, category, expierence;
  File imageFile;
  List<File> files = [];
  bool switched = false;
  final _form = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _gmailFocusNode = FocusNode();
  List _categories = [
    "Sprzątanie",
    "Montaż i naprawa",
    "Ogród",
    "Hydraulik",
    "Elektryk",
  ];
  List _expierence = [
    "1 rok",
    "2 lata",
    "3 lata",
    "4 lat",
    "5 lat",
    "6 lat",
    "7 lat",
    "8 lat",
    "9 lat",
    "10 lat",
    "+10 lat"
  ];
  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  void _saveForm(BuildContext context) async {
    final isValid = _form.currentState.validate();
    FocusScope.of(context).unfocus();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    var phone = ModalRoute.of(context).settings.arguments;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("phone", phone);
    prefs.setString("gmail", gmail.trim());
    prefs.setString("name", name.trim());
    prefs.setBool("expert", switched);
    final databaseReference = Firestore.instance;
    var map = {
      'phone': phone,
      'gmail': gmail.trim(),
      'name': name.trim(),
      "expert": switched,
    };
    var url;
    if (imageFile != null) {
      final ref =
          FirebaseStorage.instance.ref().child(phone).child("userImage.jpg");
      await ref.putFile(imageFile).onComplete;
      url = await ref.getDownloadURL();
      prefs.setString("image", url);
      map.putIfAbsent("imageUrl", () => url);
    }
    if (switched) {
      map.putIfAbsent("category", () => category);
      prefs.setString("category", category);
      map.putIfAbsent("expierence", () => expierence);
      map.putIfAbsent("description", () => description);
      List<String> fs = [];
      await Future.forEach(files, (File file) async {
        final ref = FirebaseStorage.instance
            .ref()
            .child(prefs.getString("phone"))
            .child("documents")
            .child(file.path.replaceAll("/", ""));
        await ref.putFile(file).onComplete;
        var url = await ref.getDownloadURL();
        fs.add(url);
      });
      if (fs.isNotEmpty) map.putIfAbsent("files", () => fs);
    }
    await databaseReference.collection("users").document(phone).setData(map);
    Navigator.of(context)
        .pushNamedAndRemoveUntil("/", (Route<dynamic> route) => false);
  }

  void _pickedImage(File image) {
    imageFile = image;
  }

  @override
  void dispose() {
    super.dispose();
    _gmailFocusNode.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(6.0), // here the desired height
          child: TabBar(
            isScrollable: true,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white60,
            labelColor: Colors.white,
            controller: _tabController,
            labelStyle: TextStyle(
              fontFamily: "Quicksand",
              fontSize: 22,
              color: Colors.black,
            ),
            onTap: (i) {
              setState(() {
                if (i == 0) {
                  switched = false;
                } else {
                  switched = true;
                }
              });
            },
            tabs: [
              Tab(
                text: "Zleceniodawca",
              ),
              Tab(
                text: "Fachowiec",
              ),
            ],
          ),
        ),
      ),
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: true,
      body: Form(
        key: _form,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24),
          children: [
            SizedBox(
              height: 30,
            ),
            UserImagePicker(_pickedImage),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: TextFormField(
                style: Theme.of(context).textTheme.subhead,
                decoration: InputDecoration(
                  hintText: "Imie / firma",
                  contentPadding: EdgeInsets.all(12.0),
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Podaj nazwę';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_gmailFocusNode);
                },
                onSaved: (value) => name = value,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: TextFormField(
                style: Theme.of(context).textTheme.subhead,
                decoration: InputDecoration(
                  hintText: "Adres email",
                  contentPadding: EdgeInsets.all(12.0),
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                focusNode: _gmailFocusNode,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value)) {
                    return 'Wprowadź prawidłowy adres email';
                  }
                  return null;
                },
                onSaved: (value) => gmail = value,
              ),
            ),
            switched
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Twoja specjalizacja",
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
                          value: category,
                          validator: (value) {
                            if (value == null) {
                              return 'Wybierz fach';
                            }
                            return null;
                          },
                          items: _categories.map((value) {
                            return DropdownMenuItem(
                              child: Text(value),
                              value: value,
                            );
                          }).toList(),
                          isExpanded: true,
                          onChanged: (value) {
                            setState(() {
                              category = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Lata w zawodzie",
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
                          value: expierence,
                          validator: (value) {
                            if (value == null) {
                              return 'Wybierz liczbę lat w zawodzie';
                            }
                            return null;
                          },
                          items: _expierence.map((value) {
                            return DropdownMenuItem(
                              child: Text(value),
                              value: value,
                            );
                          }).toList(),
                          isExpanded: true,
                          onChanged: (value) {
                            setState(() {
                              expierence = value;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: TextFormField(
                          style: Theme.of(context).textTheme.subhead,
                          decoration: InputDecoration(
                            hintText:
                                "Krótki opis, opisz to co uważasz, że byłoby ważne, gdybyś ty sam szukał wykonawcy",
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
                          onSaved: (value) {
                            description = value;
                          },
                        ),
                      ),
                      Text(
                        "Zdjęcia twoich realizacji:",
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.overline,
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
                                    if (l == "jpg" || l == "jpeg") {
                                      asset = "jpg.png";
                                    } else if (l == "pdf") {
                                      asset = "pdf.png";
                                    } else if (l == "png") {
                                      asset = "png.png";
                                    } else if (l == "tiff") {
                                      asset = "tiff.png";
                                    } else if (l == "doc") {
                                      asset = "doc.png";
                                    } else if (l == "txt") {
                                      asset = "txt.png";
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 3.0),
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
                    ],
                  )
                : SizedBox(),
            SizedBox(
              height: 25,
            ),
            MyButton(
              onPressed: () => _saveForm(context),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
