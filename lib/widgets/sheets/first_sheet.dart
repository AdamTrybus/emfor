import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_emfor/widgets/button.dart';
import 'package:new_emfor/widgets/sheets/second_sheet.dart';
import 'package:toast/toast.dart';

class FirstSheet extends StatefulWidget {
  final noticeId, expertPhone;
  FirstSheet(this.noticeId, this.expertPhone);
  @override
  _FirstSheetState createState() => _FirstSheetState();
}

class _FirstSheetState extends State<FirstSheet> {
  final _controller = TextEditingController();
  DateTime _selectedDate;
  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 90)),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Zatwierdź zlecenie",
            style: Theme.of(context).textTheme.headline,
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(12.0),
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.grey[200],
                hintText: "Wycena",
                suffixText: "zł",
              ),
              keyboardType: TextInputType.number,
              controller: _controller,
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  _selectedDate == null
                      ? 'Nie wybrałeś daty!'
                      : 'Wybrana data: ${DateFormat.yMd().format(_selectedDate)}',
                  style: Theme.of(context).textTheme.subhead,
                ),
              ),
              FlatButton(
                textColor: Theme.of(context).primaryColor,
                child: Text(
                  "Wybierz date",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: _presentDatePicker,
              ),
            ],
          ),
          SizedBox(
            height: 25 > MediaQuery.of(context).viewInsets.bottom
                ? 25
                : MediaQuery.of(context).viewInsets.bottom * 0.8,
          ),
          MyButton(onPressed: () async {
            if (_selectedDate == null || _controller.text.isEmpty) {
              Toast.show(
                "Uzupełnij wszystkie pola",
                context,
              );
            } else {
              Firestore.instance
                  .collection("notices")
                  .document(widget.noticeId)
                  .collection("eagers")
                  .document(widget.expertPhone)
                  .updateData({
                "estimate": _controller.text.trim(),
                "meet": _selectedDate.toString(),
              });
              showModalBottomSheet(
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25.0))),
                isScrollControlled: true,
                context: context,
                builder: (ctx) {
                  return SecondSheet(widget.noticeId);
                },
              );
            }
          }),
        ],
      ),
    );
  }
}
