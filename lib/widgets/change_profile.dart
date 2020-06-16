import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:new_emfor/widgets/code_input.dart';
import '../widgets/files_picker.dart';
import './user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:http/http.dart' as http;

class ChangeProfile extends StatefulWidget {
  static const routeName = "/change-profile";

  @override
  _ChangeProfileState createState() => _ChangeProfileState();
}

class _ChangeProfileState extends State<ChangeProfile> {
  String gmail,
      name,
      description,
      category,
      phone,
      imageUrl,
      initialPhoneNumber;
  TextEditingController textGmail = TextEditingController(),
      textName = TextEditingController(),
      textDescription = TextEditingController(),
      textPhone = TextEditingController();
  File imageFile;
  List<File> files;
  bool switched = false, loading = true;
  final _form = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _gmailFocusNode = FocusNode(), _phoneFocusNode = FocusNode();
  List _categories = [
    "Sprzątanie",
    "Montaż i naprawa",
    "Ogród",
    "Hydraulik",
    "Elektryk",
  ];
  void _saveForm(BuildContext context) async {
    final isValid = _form.currentState.validate();
    FocusScope.of(context).unfocus();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("phone", phone);
    prefs.setString("gmail", gmail);
    prefs.setString("name", name);
    final databaseReference = Firestore.instance;
    var map = {
      'phone': phone,
      'gmail': gmail.trim(),
      'name': name.trim(),
    };
    if (imageFile != null) {
      final ref =
          FirebaseStorage.instance.ref().child(phone).child("userImage.jpg");
      await ref.putFile(imageFile).onComplete;
      final url = await ref.getDownloadURL();
      prefs.setString("imageUrl", url);
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
        files.forEach((file) async {
          await FirebaseStorage.instance
              .ref()
              .child(phone)
              .child("documents")
              .child(file.toString().replaceAll("/", ""))
              .putFile(file)
              .onComplete;
        });
      }
    }
    print(map);
    await databaseReference.collection("users").document(phone).setData(map);
    initialPhoneNumber == phone
        ? Navigator.of(context).pushNamed("/")
        : Navigator.of(context)
            .pushNamed(CodeInput.routeName, arguments: phone);
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
  void initState() {
    super.initState();
    Future.delayed(Duration(microseconds: 0)).then((value) async {
      var prefs = await SharedPreferences.getInstance();
      Firestore.instance
          .collection("users")
          .document(prefs.getString("phone"))
          .get()
          .then((value) async {
        var file;
        try {
          imageUrl = value.data["imageUrl"];
          http.Response response = await http.get(imageUrl);
          final Uint8List uint = response.bodyBytes;
          final appDir = await syspaths.getTemporaryDirectory();
          file = await File('${appDir.path}/${imageUrl.replaceAll("/", "")}').create();
          file.writeAsBytesSync(uint);
        } catch (e) {}
        setState(() {
          textPhone.text = value.data["phone"];
          initialPhoneNumber = value.data["phone"];
          textGmail.text = value.data["gmail"];
          textDescription.text = value.data["description"];
          category = value.data["category"];
          textName.text = value.data["name"];
          imageFile = file;
          loading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: true,
        body: loading
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _form,
                child: ListView(
                  children: [
                    SizedBox(
                      height: 60,
                    ),
                    UserImagePicker(_pickedImage, imageFile),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      child: TextFormField(
                        controller: textName,
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
                            return 'Please provide a value.';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_phoneFocusNode);
                        },
                        onSaved: (value) => name = value,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      child: TextFormField(
                        controller: textPhone,
                        decoration: InputDecoration(
                          hintText: "Numer telefonu",
                          contentPadding: EdgeInsets.all(12.0),
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        focusNode: _phoneFocusNode,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_gmailFocusNode);
                        },
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a value.';
                          }
                          return null;
                        },
                        onSaved: (value) => phone = value,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      child: TextFormField(
                        controller: textGmail,
                        decoration: InputDecoration(
                          hintText: "Adres gmail",
                          contentPadding: EdgeInsets.all(12.0),
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        focusNode: _gmailFocusNode,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a value.';
                          }
                          return null;
                        },
                        onSaved: (value) => gmail = value,
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Rejestracja dla fachowca",
                          style: Theme.of(context).textTheme.title,
                        ),
                        Switch(
                            value: switched,
                            onChanged: (val) {
                              setState(() {
                                switched = val;
                              });
                            }),
                      ],
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
                                child: DropdownButton(
                                  hint: Text("Wybierz fach"),
                                  value: category,
                                  items: _categories.map((value) {
                                    return DropdownMenuItem(
                                      child: Text(value),
                                      value: value,
                                    );
                                  }).toList(),
                                  isExpanded: true,
                                  underline: Divider(
                                    height: 2,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      category = value;
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 8),
                                child: TextFormField(
                                  controller: textDescription,
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
                      height: 30,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 60),
                      child: RaisedButton(
                        onPressed: () {
                          _saveForm(context);
                          print(files);
                          print(imageFile);
                        },
                        color: Colors.amber[500],
                        elevation: 6,
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(26),
                          borderSide:
                              BorderSide(width: 1, color: Colors.amber[500]),
                        ),
                        child: Text(
                          "Dalej",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ));
  }
}
