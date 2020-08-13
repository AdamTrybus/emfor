import 'package:flutter/material.dart';
import 'package:new_emfor/screens/questions_detail_screen.dart';

class QuestionsScreen extends StatefulWidget {
  static const String routeName = "questions-screen";
  @override
  _QuestionsScreenState createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  List<String> questions = [
    "Na czym polega Gwarancja?",
    "Na jakich zasadach działa gwarancja?",
    "Gdzie trafią moje pieniądze?",
    "Czy to rozwiązanie jest bezpieczne?"
  ];
  List<String> answers = [
    "Gwarancja polega na wkładaniu chuja w dupe tobe a potem wyjmowaniu z nalezyta pamiecia o ostroznosci. W przypadku za szybkiego wyciagniecia moze ci odciac siusiaczka - wiec uwazaj skurwysynie.",
    "Gwarancja polega na wkładaniu chuja w dupe tobe a potem wyjmowaniu z nalezyta pamiecia o ostroznosci. W przypadku za szybkiego wyciagniecia moze ci odciac siusiaczka - wiec uwazaj skurwysynie.",
    "Gwarancja polega na wkładaniu chuja w dupe tobe a potem wyjmowaniu z nalezyta pamiecia o ostroznosci. W przypadku za szybkiego wyciagniecia moze ci odciac siusiaczka - wiec uwazaj skurwysynie.",
    "Gwarancja polega na wkładaniu chuja w dupe tobe a potem wyjmowaniu z nalezyta pamiecia o ostroznosci. W przypadku za szybkiego wyciagniecia moze ci odciac siusiaczka - wiec uwazaj skurwysynie."
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          children: [
            Text(
              "Często zadawane pytania",
              style: Theme.of(context).textTheme.headline,
            ),
            SizedBox(
              height: 20,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: questions.length,
              itemBuilder: (ctx, i) => Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          questions[i],
                          style: Theme.of(context).textTheme.title,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward_ios),
                        onPressed: () => Navigator.of(context).pushNamed(
                            QuestionsDetailScreen.routeName,
                            arguments: {
                              "question": questions[i],
                              "answer": answers[i],
                            }),
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 1.4,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
