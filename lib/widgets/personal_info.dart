import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:new_emfor/providers/user.dart';
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
  String gmail, name, description, category;
  File imageFile;
  List<File> files;
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
    prefs.setBool("expert", false);
    final databaseReference = Firestore.instance;
    var map = {
      'phone': phone,
      'gmail': gmail.trim(),
      'name': name.trim(),
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
      if (category == null) {
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text("Wybierz fach")));
        return;
      }
      map.putIfAbsent("category", () => category);
      map.putIfAbsent("description", () => description);
      if (files != null) {
        prefs.setBool("expert", true);
        files.forEach((file) async {
          await FirebaseStorage.instance
              .ref()
              .child(phone)
              .child("documents")
              .child(file.toString().replaceAll("/", ""))
              .putFile(file)
              .onComplete;
        });
      } else {
        Toast.show(
          "Dodaj jeszcze pliki potwierdzające twoje umiejętności",
          context,
          duration: Toast.LENGTH_LONG,
        );
        return;
      }
    }
    await databaseReference.collection("users").document(phone).setData(map);
    Navigator.of(context).pushNamed("/");
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
    files = f;
    files.forEach((file) {
      if (file.lengthSync() > 10240) {
        print("siema byku $file");
      }
    });
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              UserImagePicker(_pickedImage),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: TextFormField(
                  style: Theme.of(context).textTheme.subhead,
                  decoration: InputDecoration(
                    hintText: "Imie",
                    contentPadding: EdgeInsets.all(12.0),
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Podaj imię';
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
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
              SizedBox(
                height: 6,
              ),
              switched
                  ? Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 24,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                          ),
                          child: DropdownButtonFormField(
                            hint: Text("Wybierz fach"),
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
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          child: TextFormField(
                            style: Theme.of(context).textTheme.subhead,
                            decoration: InputDecoration(
                              hintText:
                                  "Krótki opis, opisz swoje doświadzczenie oraz lata w zawodzie",
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
                        FilesPicker(_pickedFiles)
                      ],
                    )
                  : SizedBox(),
              SizedBox(
                height: 20,
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
      ),
    );
  }
}
