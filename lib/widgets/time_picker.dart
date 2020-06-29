import 'package:flutter/material.dart';
import 'package:new_emfor/providers/work.dart';
import 'package:provider/provider.dart';

class TimePicker extends StatefulWidget {
  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  String group = "";
  String question = "Termin usługi";
  List<String> options = [
    "W ciągu kilku dni",
    "W ciągu 1-2 tygodni",
    "Dostosuje się do wykonawcy",
    "Dokładna data"
  ];
  List<String> choices = [];
  Widget radioButton(String title) {
    return Row(
      children: <Widget>[
        Radio(
          groupValue: group,
          value: title,
          onChanged: (value) {
            group = value;
            Provider.of<Work>(context, listen: false).setChoices("time", value);
          },
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.title,
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(microseconds: 0)).then((value) {
      Provider.of<Work>(context, listen: false).setQuestion("time");
      setState(() {
        choices = Provider.of<Work>(context, listen: false).getNotice();
        group = choices.first;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
          itemBuilder: (ctx, i) => radioButton(options[i]),
        )
      ],
    );
  }
}
