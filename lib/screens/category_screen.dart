import 'package:flutter/material.dart';
import 'package:new_emfor/providers/work.dart';
import 'package:new_emfor/screens/subcategory_screen.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  static const String routeName = "/category-screen";
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
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
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Container(
            child: Text(
              "Jaka usługa cię interesuje?",
              style: Theme.of(context).textTheme.headline,
            ),
            padding: EdgeInsets.only(left: 24),
          ),
          SizedBox(
            height: 40,
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: options.length,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            itemBuilder: (ctx, i) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 10),
                  child: InkWell(
                    child: Text(
                      options[i],
                      style: Theme.of(context).textTheme.subhead,
                    ),
                    onTap: () async {
                      Provider.of<Work>(context, listen: false)
                          .setSubcategory(options[i]);
                      await Provider.of<Work>(context, listen: false)
                          .setSubCollection(0);
                      Navigator.of(context)
                          .pushReplacementNamed(SubcategoryScreen.routeName);
                    },
                  ),
                ),
                SizedBox(
                  height: 6,
                  child: Divider(
                    thickness: 2,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
