import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:new_emfor/widgets/button.dart';
import 'package:new_emfor/widgets/code_input.dart';
import 'package:new_emfor/widgets/profile/verify_phone.dart';
import 'package:toast/toast.dart';
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
      uid,
      name,
      description,
      category,
      imageUrl,
      expierence,
      initialPhoneNumber;
  TextEditingController textGmail = TextEditingController(),
      textName = TextEditingController(),
      textDescription = TextEditingController(),
      textPhone = TextEditingController();
  File imageFile;
  List<File> files = [];
  bool loading = true, isExpert;
  final _form = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
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
  SharedPreferences prefs;
  void _saveForm(BuildContext context) async {
    final isValid = _form.currentState.validate();
    FocusScope.of(context).unfocus();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    prefs.setString("gmail", gmail);
    prefs.setString("name", name);
    final databaseReference = Firestore.instance;
    Map<String, dynamic> map = {
      'gmail': gmail.trim(),
      'name': name.trim(),
    };
    if (imageFile != null) {
      final ref =
          FirebaseStorage.instance.ref().child(uid).child("userImage.jpg");
      await ref.putFile(imageFile).onComplete;
      final url = await ref.getDownloadURL();
      prefs.setString("imageUrl", url);
      map.putIfAbsent("imageUrl", () => url);
    }
    if (isExpert) {
      map.putIfAbsent("category", () => category);
      prefs.setString("category", category);
      map.putIfAbsent("expierence", () => expierence);
      map.putIfAbsent("description", () => description);
      List<String> fs = [];
      await Future.forEach(files, (File file) async {
        final ref = FirebaseStorage.instance
            .ref()
            .child(uid)
            .child("documents")
            .child(file.path.replaceAll("/", ""));
        await ref.putFile(file).onComplete;
        var url = await ref.getDownloadURL();
        fs.add(url);
      });
      if (fs.isNotEmpty) map.putIfAbsent("files", () => fs);
    }
    await databaseReference.collection("users").document(uid).updateData(map);
    Navigator.of(context).pop();
  }

  void _pickedImage(File image) {
    imageFile = image;
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
  void initState() {
    super.initState();
    Future.delayed(Duration(microseconds: 0)).then((value) async {
      prefs = await SharedPreferences.getInstance();
      uid = prefs.getString("uid");
      Firestore.instance
          .collection("users")
          .document(uid)
          .get()
          .then((value) async {
        var file;
        List filesInString = value.data["files"] ?? [];
        try {
          await Future.forEach(filesInString, (element) async {
            http.Response response = await http.get(element);
            final Uint8List uint = response.bodyBytes;
            final appDir = await syspaths.getTemporaryDirectory();
            File f = await File('${appDir.path}/${element.split("/").last}')
                .create();
            f.writeAsBytesSync(uint);
            files.add(f);
          });
        } catch (e) {
          print("message - $e");
        }

        try {
          imageUrl = value.data["imageUrl"];
          http.Response response = await http.get(imageUrl);
          final Uint8List uint = response.bodyBytes;
          final appDir = await syspaths.getTemporaryDirectory();
          file = await File('${appDir.path}/${imageUrl.replaceAll("/", "")}')
              .create();
          file.writeAsBytesSync(uint);
        } catch (e) {}
        setState(() {
          textPhone.text = value.data["phone"];
          textGmail.text = value.data["gmail"];
          textDescription.text = value.data["description"];
          category = value.data["category"];
          expierence = value.data["expierence"];
          textName.text = value.data["name"];
          imageFile = file;
          if (category == null)
            isExpert = false;
          else
            isExpert = true;
          loading = false;
        });
      });
    });
  }

  Widget item(String name, String value, TextEditingController controller,
      Function onSaved,
      {bool gmail = false, phone = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 4,
              ),
              Text(
                name,
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 13,
                    fontFamily: "OpenSans",
                    fontWeight: FontWeight.w300),
              ),
            ],
          ),
          SizedBox(
            height: 2,
          ),
          TextFormField(
            controller: controller,
            maxLines: 5,
            minLines: 1,
            enabled: !phone,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(12.0),
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.grey[200],
            ),
            keyboardType: TextInputType.text,
            validator: (value) {
              if (gmail) {
                if (!RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value)) {
                  return 'Wprowadź prawidłowy adres email';
                }
                return null;
              } else {
                if (value.isEmpty) {
                  return 'Podaj $name';
                }
                return null;
              }
            },
            textInputAction: TextInputAction.done,
            onSaved: onSaved,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: true,
        body: SafeArea(
          child: loading
              ? Center(child: CircularProgressIndicator())
              : Form(
                  key: _form,
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 26),
                    children: [
                      UserImagePicker(_pickedImage, imageFile),
                      item("Imie", name, textName,
                          (val) => name = val.toString()),
                      InkWell(
                        onTap: () => Navigator.of(context)
                            .pushNamed(VerifyPhone.routeName),
                        child: item("Numer telefonu", prefs.getString("phone"),
                            textPhone, (val) {},
                            phone: true),
                      ),
                      item("Adres gmail", gmail, textGmail,
                          (val) => gmail = val.toString(),
                          gmail: true),
                      Visibility(
                        visible: isExpert,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        "Specjalizacja",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: "OpenSans",
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ],
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
                                    child: DropdownButton(
                                      hint: Text("Wybierz"),
                                      value: category,
                                      items: _categories.map((val) {
                                        return DropdownMenuItem(
                                          child: Text(val),
                                          value: val,
                                        );
                                      }).toList(),
                                      isExpanded: true,
                                      underline: Divider(
                                        height: 2,
                                      ),
                                      onChanged: (v) {
                                        setState(() {
                                          category = v;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        "Lata w zawodzie",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: "OpenSans",
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ],
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
                                    child: DropdownButton(
                                      hint: Text("Wybierz"),
                                      value: expierence,
                                      items: _expierence.map((val) {
                                        return DropdownMenuItem(
                                          child: Text(val),
                                          value: val,
                                        );
                                      }).toList(),
                                      isExpanded: true,
                                      underline: Divider(
                                        height: 2,
                                      ),
                                      onChanged: (v) {
                                        setState(() {
                                          expierence = v;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            item("Opis", description, textDescription,
                                (val) => description = val.toString()),
                            SizedBox(
                              height: 8,
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
                                          var l = files[i]
                                              .path
                                              .toString()
                                              .split(".")
                                              .last
                                              .split("?")
                                              .first;
                                          print(l);
                                          String asset = "";
                                          if (l == "jpg" ||
                                              l == "jpeg" ||
                                              l == "png") {
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
                                  if (files.length < 5)
                                    FilesPicker(_pickedFiles),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      MyButton(
                        onPressed: () => _saveForm(context),
                        text: "Zapisz",
                      ),
                    ],
                  ),
                ),
        ));
  }
}
