import 'package:flutter/material.dart';
import 'package:new_emfor/providers/work.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:toast/toast.dart';
import '../widgets/files_picker.dart';

class Description extends StatefulWidget {
  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  String value = "";
  List<File> files = [];
  bool isLoading = true;
  TextEditingController _controller;
  final _form = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(microseconds: 0)).then((value) async {
      Provider.of<Work>(context, listen: false).setQuestion("description");
      setState(() {
        value = Provider.of<Work>(context, listen: false).getNotice();
        files = Provider.of<Work>(context, listen: false).files;
        print(value);
        _controller = TextEditingController(text: value);
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _pickedFiles(List<File> f) {
    f.forEach((file) {
      List<String> g = [];
      files.forEach((element) => g.add(element.path));
      if (!g.contains(file.path)) {
        if (file.lengthSync() > 20000000) {
          Toast.show("${file.path} - za duży rozmiar pliku", context,
              duration: 5);
        } else if (files.length >= 5) {
          Toast.show("Przekroczono liczbę plików (max 5)", context,
              duration: 5);
        } else {
          files.add(file);
        }
      }
    });
    Provider.of<Work>(context, listen: false).setFiles(files);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _form,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              maxLines: 5,
              controller: _controller,
              enableSuggestions: true,
              keyboardType: TextInputType.text,
              onChanged: (val) {
                Provider.of<Work>(context, listen: false)
                    .setNotice("description", val);
              },
              decoration: InputDecoration(
                hintText:
                    "Dodaj krótki opis oraz wyszczegól najważniejsze informacje. Możesz dodać również załączniki",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 70,
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: 24,
            ),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: [
              SizedBox(
                height: 50,
                child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
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
                        padding: const EdgeInsets.symmetric(horizontal: 3.0),
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
    );
  }
}
