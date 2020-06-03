
import 'package:flutter/material.dart';
import 'package:new_emfor/providers/work.dart';
import 'package:new_emfor/screens/subcategory_screen.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String question;
  List<String> options;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(microseconds: 0)).then((value) async {
      Provider.of<Work>(context, listen: false).setOptions();
    });
  }

  @override
  Widget build(BuildContext context) {
    options = Provider.of<Work>(context).options;
    question = Provider.of<Work>(context).question;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 40,
          ),
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
            itemBuilder: (ctx, i) => ListTile(
              title: Text(
                options[i],
                style: Theme.of(context).textTheme.title,
              ),
              onTap: () async {
                Provider.of<Work>(context, listen: false)
                    .setSubcategory(options[i]);
                Provider.of<Work>(context,listen: false).setNotice("service", options[i]);
                await Provider.of<Work>(context, listen: false)
                    .setSubCollection(1);
                Navigator.of(context).pushNamed(SubcategoryScreen.routeName);
              },
            ),
          ),
        ],
      ),
    );
  }
}
