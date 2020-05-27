import 'package:flutter/material.dart';
import 'package:new_emfor/screens/category_screen.dart';
import 'package:new_emfor/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        backgroundColor: Colors.amber[300],
        accentColor: Colors.amberAccent,
        accentColorBrightness: Brightness.dark,
        buttonTheme: ButtonTheme.of(context).copyWith(
          minWidth: 200,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          buttonColor: Colors.amber[500],
          textTheme: ButtonTextTheme.normal,
          // shape: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(26),
          //   borderSide: BorderSide(width: 1, color: Colors.amber[500]),
          // ),
        ),
        textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
              button: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
              headline: TextStyle(
                fontFamily: 'OpenSans',
                color: Colors.deepPurple[800],
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
      ),
      home: CategoryScreen(),
    );
  }
}
