import 'dart:io';
import 'package:toast/toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FilesPicker extends StatefulWidget {
  FilesPicker(this.filesFn);
  final void Function(List<File> files) filesFn;

  @override
  _FilesPickerState createState() => _FilesPickerState();
}

class _FilesPickerState extends State<FilesPicker> {
  List<File> files = [];

  void _pickFiles() async {
    var files1 = await FilePicker.getMultiFile(
        type: FileType.custom,
        allowedExtensions: ["tiff", "jpg", "jpeg", "doc", "pdf", "png", "txt"]);
    setState(() {
      files = files1;
    });
    widget.filesFn(files1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: FlatButton(
        onPressed: () {
          _pickFiles();
        },
        child: Image.asset(
          "assets/add_file.png",
          height: 50,
        ),
      ),
    );
  }
}
