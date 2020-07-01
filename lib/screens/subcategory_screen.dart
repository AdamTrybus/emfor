import 'package:flutter/material.dart';
import 'package:new_emfor/widgets/autocomplete_map.dart';
import 'package:new_emfor/widgets/description.dart';
import 'package:new_emfor/widgets/time_picker.dart';
import '../providers/work.dart';
import './category_screen.dart';
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
  int i = 0, length = 0;

  void _onPressed(bool backPressed) {
    if (backPressed)
      i--;
    else
      i++;

    if (i < 0) {
      Navigator.of(context).pushReplacementNamed(CategoryScreen.routeName);
    } else if (i < length - 3) {
      Provider.of<Work>(context, listen: false).setSubCollection(i);
    } else if (i == length) {
      Provider.of<Work>(context, listen: false).publish();
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      setState(() {});
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
        Flexible(
          child: Text(
            title,
            style: Theme.of(context).textTheme.overline,
          ),
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
          style: Theme.of(context).textTheme.overline,
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
              style: Theme.of(context).textTheme.display1,
            ),
            padding: EdgeInsets.all(16),
          ),
          SizedBox(
            height: 40,
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: options.length,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
    length = Provider.of<Work>(context, listen: false).length;
    choices = Provider.of<Work>(context).getChoices();
    multi = Provider.of<Work>(context).multi;
    if (choices.isNotEmpty) {
      group = choices.first;
    }
    return WillPopScope(
      onWillPop: () {
        _onPressed(true);
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
                Container(
                  height: 50,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                        side: BorderSide(color: Colors.black, width: 4)),
                    color: Colors.white,
                    onPressed: () => _onPressed(true),
                    child: Text(
                      "Cofnij",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Quicksand",
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: !(choices.isEmpty && i < length - 3),
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: Container(
                    height: 50,
                    child: RaisedButton(
                      color: Colors.black,
                      disabledColor: Colors.black26,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                          side: BorderSide(color: Colors.black, width: 4)),
                      onPressed: () => _onPressed(false),
                      child: Text(
                        i == length - 1 ? "Zakończ" : "Dalej",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Quicksand",
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            )
          ],
        ),
      ),
    );
  }
}
