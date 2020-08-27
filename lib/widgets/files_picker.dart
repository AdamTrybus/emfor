import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FilesPicker extends StatefulWidget {
  FilesPicker(this.filesFn);
  final void Function(List<File> files) filesFn;

  @override
  _FilesPickerState createState() => _FilesPickerState();
}

class _FilesPickerState extends State<FilesPicker> {
  void _pickFiles() async {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return SizedBox(
            height: 120,
            child: Column(
              children: [
                ListTile(
                  title: Text("Aparat"),
                  onTap: () async {
                    Navigator.of(context).pop();
                    final pickedImageFile =
                        await ImagePicker.pickImage(source: ImageSource.camera);
                    List<File> f = [];
                    f.add(pickedImageFile);
                    widget.filesFn(f);
                  },
                ),
                ListTile(
                  title: Text("Zapisane"),
                  onTap: () async {
                    Navigator.of(context).pop();
                    var files1 = await FilePicker.getMultiFile(
                        type: FileType.custom,
                        allowedExtensions: [
                          "tiff",
                          "jpg",
                          "jpeg",
                          "doc",
                          "pdf",
                          "mp4",
                          "mp3",
                          "webm",
                          "png",
                          "txt"
                        ]);
                    widget.filesFn(files1);
                  },
                ),
              ],
            ),
          );
        });
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
