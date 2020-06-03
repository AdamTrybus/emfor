import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import './user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class PersonalInfo extends StatefulWidget {
  static const routeName = "/personal-info";

  @override
  _PersonalInfoState createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  String gmail, name;
  File imageFile;
  final _form = GlobalKey<FormState>();
  final _gmailFocusNode = FocusNode();

  void _saveForm(BuildContext context) async {
    final isValid = _form.currentState.validate();
    FocusScope.of(context).unfocus();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    var phone = ModalRoute.of(context).settings.arguments;
    final appDir = await syspaths.getApplicationDocumentsDirectory();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("phone", phone);
    prefs.setString("gmail", gmail);
    prefs.setString("name", name);
    if (imageFile != null) {
      final savedImage = await imageFile.copy('${appDir.path}/emfor-userImage');
      prefs.setString("image", savedImage.path);
    }
    final databaseReference = Firestore.instance;
    await databaseReference.collection("users").document(phone).setData({
      'phone': phone,
      'gmail': gmail.trim(),
      'name': name.trim(),
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Form(
        key: _form,
        child: Column(
          children: [
            SizedBox(
              height: 60,
            ),
            UserImagePicker(_pickedImage),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: TextFormField(
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
                  FocusScope.of(context).requestFocus(_gmailFocusNode);
                },
                onSaved: (value) => name = value,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: TextFormField(
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
            Expanded(child: SizedBox()),
            Container(
              width: 200,
              child: RaisedButton(
                onPressed: () {
                  _saveForm(context);
                },
                color: Colors.amber[500],
                elevation: 6,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(26),
                  borderSide: BorderSide(width: 1, color: Colors.amber[500]),
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
      ),
    );
  }
}
