import 'dart:math';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final categories = [
    "Budowa domu",
    "Elektryk",
    "Hydraulik",
    "Malarz",
    "Ogród",
    "Remont",
    "Montaż i naprawy",
    "Meble i zabudowa",
    "Sprzątanie"
  ];
  final availableColors = [
    Colors.red,
    Colors.blue,
    Colors.pink,
    Colors.green,
    Colors.cyan,
    Colors.purple,
    Colors.amberAccent,
    Colors.deepOrange,
    Colors.tealAccent,
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: 9,
      itemBuilder: (ctx, i) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          gradient: LinearGradient(
            colors: [
              availableColors[i].withOpacity(0.4),
              availableColors[i].withOpacity(0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0, 1],
          ),
        ),
        child: Center(
          child: Text(
            categories[i],
            style: Theme.of(context).textTheme.title,
          ),
        ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
    );
  }
}
