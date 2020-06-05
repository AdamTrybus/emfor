import 'package:flutter/material.dart';
import 'package:new_emfor/providers/work.dart';
import 'package:provider/provider.dart';

class Description extends StatefulWidget {
  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  String value = "";
  bool isLoading=true;
  TextEditingController _controller;
  final _form = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(microseconds: 0)).then((value) async {
      Provider.of<Work>(context, listen: false).setQuestion("description");
      setState(() {
        value = Provider.of<Work>(context, listen: false).getNotice().join(",");
        print(value);
        _controller = TextEditingController(text: value);
        isLoading =false;
      });
    });
  }
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
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
                      Provider.of<Work>(context, listen: false).setNotice("description", val);
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
        FlatButton(
          child: Text("Dodaj załączniki"),
          onPressed: null,
        ),
      ],
    );
  }
}
