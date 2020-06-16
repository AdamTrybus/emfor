import 'dart:io';

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
  String description = "";

  void _pickFiles() async {
    var files1 = await FilePicker.getMultiFile();
    setState(() {
      files = files1;
    });
    widget.filesFn(files1);
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        _pickFiles();
      },
      child: Text("Dodaj pliki",),
    );
  }
}
