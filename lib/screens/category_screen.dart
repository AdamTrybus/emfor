import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  Widget checkbox(String title, bool boolValue) {
    return Row(
      children: <Widget>[
        Checkbox(
          value: boolValue,
          onChanged: (bool value) {},
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.title,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Container(
            child: Text(
              "Co się stało ?",
              style: Theme.of(context).textTheme.headline,
            ),
            padding: EdgeInsets.all(8),
          ),
          SizedBox(
            height: 40,
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: 4,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            itemBuilder: (ctx, i) => checkbox("hejka", true),
          ),
          Expanded(child: SizedBox()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton(
                onPressed: null,
                child: Text("Cofnij"),
              ),
              FlatButton(
                onPressed: null,
                child: Text("Następny"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
