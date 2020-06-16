import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickFn, [this.image]);

  final void Function(File pickedImage) imagePickFn;
  final File image;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;

  void _pickImage() async {
    final pickedImageFile =
        await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    widget.imagePickFn(pickedImageFile);
  }

  @override
  void initState() {
    super.initState();
    _pickedImage = widget.image;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: _pickImage,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image(
              fit: BoxFit.cover,
              height: 130,
              width: 130,
              image: _pickedImage != null
                  ? FileImage(_pickedImage)
                  : AssetImage("assets/user_image.png"),
            ),
          ),
        ),
      ],
    );
  }
}
