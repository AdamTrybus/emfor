import 'package:flutter/material.dart';
import 'package:new_emfor/providers/work.dart';
import 'package:provider/provider.dart';

class TimePicker extends StatefulWidget {
  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  String group = "";
  List<String> options = [
    "W ciągu kilku dni",
    "W ciągu 1-2 tygodni",
    "Dostosuje się do wykonawcy",
    "Dokładna data"
  ];
  Widget radioButton(String title) {
    return Row(
      children: <Widget>[
        Radio(
          groupValue: group,
          value: title,
          onChanged: (value) {
            group = value;
            Provider.of<Work>(context, listen: false).setNotice("time", value);
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
        group = Provider.of<Work>(context, listen: false).getNotice();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Text(
            "Termin usługi",
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
