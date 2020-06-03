import 'package:flutter/material.dart';
import 'package:new_emfor/providers/work.dart';
import 'package:provider/provider.dart';

class Description extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<Work>(context, listen: false)
        .setQuestion("description");
    String value =
        Provider.of<Work>(context, listen: false).getChoices().join(",");
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            maxLines: 5,
            enableSuggestions: true,
            controller: TextEditingController(text: value),
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
        FlatButton(
          child: Text("Dodaj załączniki"),
          onPressed: null,
        ),
      ],
    );
  }
}
