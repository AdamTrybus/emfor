import 'package:flutter/material.dart';
import 'package:new_emfor/widgets/autocomplete_map.dart';
import 'package:new_emfor/widgets/description.dart';
import 'package:new_emfor/widgets/time_picker.dart';
import '../providers/work.dart';
import 'package:provider/provider.dart';

class SubcategoryScreen extends StatefulWidget {
  static const routeName = "/subcategory-screen";
  @override
  _SubcategoryScreenState createState() => _SubcategoryScreenState();
}

class _SubcategoryScreenState extends State<SubcategoryScreen> {
  String question;
  List<String> options;
  List<String> choices = [];
  bool multi;
  String group = "";
  int i = 0, length;
  void _onBackPressed() {
    i -= 1;
    if (i < 0) {
      Provider.of<Work>(context, listen: false).setOptions();
      Navigator.of(context).pop();
    } else if (i >= length - 3) {
      setState(() {});
    } else {
      Provider.of<Work>(context, listen: false).setSubCollection(i);
    }
  }

  Widget checkbox(String title) {
    return Row(
      children: <Widget>[
        Checkbox(
          value: choices.contains(title),
          onChanged: (bool value) {
            if (value) {
              choices.add(title);
              Provider.of<Work>(context, listen: false)
                  .setChoices(question, choices.join(","));
            } else {
              choices.remove(title);
              Provider.of<Work>(context, listen: false)
                  .setChoices(question, choices.join(","));
            }
          },
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.title,
        ),
      ],
    );
  }

  Widget radioButton(String title) {
    return Row(
      children: <Widget>[
        Radio(
          groupValue: group,
          value: title,
          onChanged: (value) {
            group = value;
            Provider.of<Work>(context, listen: false)
                .setChoices(question, value);
          },
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.title,
        ),
      ],
    );
  }

  Widget mainView() {
    if (i < length - 3) {
      return Column(
        children: [
          Container(
            child: Text(
              question,
              style: Theme.of(context).textTheme.headline,
            ),
            padding: EdgeInsets.all(8),
          ),
          SizedBox(
            height: 40,
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: options.length,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            itemBuilder: (ctx, i) =>
                multi ? checkbox(options[i]) : radioButton(options[i]),
          )
        ],
      );
    } else if (i < length - 2) {
      return TimePicker();
    } else if (i < length - 1) {
      return Description();
    } else
      return AutocompleteMap();
  }

  @override
  Widget build(BuildContext context) {
    options = Provider.of<Work>(context).options;
    question = Provider.of<Work>(context).question;
    length = Provider.of<Work>(context).length;
    choices = Provider.of<Work>(context).getChoices();
    multi = Provider.of<Work>(context).multi;
    if (choices.isNotEmpty) {
      group = choices.first;
    }
    return WillPopScope(
      onWillPop: () {
        _onBackPressed();
        return Future.value(false);
      },
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            mainView(),
            Expanded(child: SizedBox()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  onPressed: _onBackPressed,
                  child: Text("Cofnij"),
                ),
                RaisedButton(
                  onPressed: choices.length == 0 && i < length - 3
                      ? null
                      : () async {
                          i++;
                          if (i < length - 3) {
                            Provider.of<Work>(context, listen: false)
                                .setSubCollection(i);
                            Provider.of<Work>(context, listen: false)
                                .setChoices(question, choices.join(","));
                            choices = [];
                          } else if (i == length) {
                            //sprawdzamy czy to koniec
                            Provider.of<Work>(context, listen: false).publish();
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                            Navigator.of(context).pushReplacementNamed("/");
                          } else {
                            setState(() {});
                          }
                        },
                  child: Text(i == length ? "Zakończ" : "Dalej"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
