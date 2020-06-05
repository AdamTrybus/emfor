import 'package:flutter/material.dart';
import 'package:new_emfor/providers/work.dart';
import 'package:provider/provider.dart';

class TimePicker extends StatefulWidget {
  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  String question = "Termin usługi";
  List<String> options = [
    "W ciągu kilku dni",
    "W ciągu 1-2 tygodni",
    "Dostosuje się do wykonawcy",
    "Dokładna data"
  ];
  List<String> choices = [];
  Widget checkbox(String title) {
    return Row(
      children: <Widget>[
        Checkbox(
          value: choices.contains(title),
          onChanged: (bool value) {
            if (value) {
              choices.add(title);
              Provider.of<Work>(context, listen: false)
                  .setNotice("time", choices.join(","));
            } else {
              choices.remove(title);
              Provider.of<Work>(context, listen: false)
                  .setNotice("time", choices.join(","));
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

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(microseconds: 0)).then((value) async {
      Provider.of<Work>(context, listen: false).setQuestion("time");
      setState(() {
        choices = Provider.of<Work>(context, listen: false).getNotice();
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
          itemBuilder: (ctx, i) => checkbox(options[i]),
        )
      ],
    );
  }
}
