import 'package:flutter/material.dart';
import 'package:new_emfor/providers/categories.dart';
import 'package:new_emfor/providers/work.dart';
import 'package:new_emfor/screens/category_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final categories = Categories().workData.keys.toList();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: categories.length,
      itemBuilder: (ctx, i) => Card(
        elevation: 8,
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                categories[i],
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                Categories().workData[categories[i]].keys.toList().join(", "),
                style: Theme.of(context).textTheme.overline,
              ),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: RaisedButton(
                      onPressed: () {
                        Provider.of<Work>(context, listen: false)
                            .setCategory(categories[i]);
                        Navigator.of(context)
                            .pushNamed(CategoryScreen.routeName);
                      },
                      child: Text(
                        "Skorzystaj z usługi",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      color: Colors.amber[600],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
