import 'package:flutter/material.dart';

class QuestionsDetailScreen extends StatelessWidget {
  static const String routeName = "questionsDetail-screen";
  String question, answer;

  @override
  Widget build(BuildContext context) {
    var map = ModalRoute.of(context).settings.arguments as Map<String, String>;
    question = map["question"];
    answer = map["answer"];
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            Text(
              question,
              style: Theme.of(context).textTheme.headline,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              answer,
              style: Theme.of(context).textTheme.title,
            ),
          ],
        ),
      )),
    );
  }
}
