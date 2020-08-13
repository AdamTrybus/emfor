import 'package:flutter/material.dart';

class SupportScreen extends StatefulWidget {
  static const String routeName = "support-screen";
  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  Widget issueCard(String asset, String title, String subtitle) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Image.asset(
              asset,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    style: TextStyle(
                        fontFamily: "Medium",
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                    softWrap: true,
                  ),
                ),
                SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    subtitle,
                    style: TextStyle(
                        fontFamily: "Quicksand",
                        fontSize: 14,
                        fontWeight: FontWeight.w300),
                    softWrap: true,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: 12,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          children: [
            Text(
              "Co się stało ?",
              style: Theme.of(context).textTheme.headline,
            ),
            SizedBox(
              height: 16,
            ),
            issueCard("assets/timeout.png", "Zlecenie nie zostało wykonane",
                "Wykonawca nie przyjechał / nie podjął się zadania"),
            issueCard("assets/leak_pipe.png", "Usterka przy pracy",
                "Praca nie została w pełni dobrze wykonane"),
            issueCard("assets/other_problem.png", "Inny problem",
                "Zgłoś problem, który nie został wymieniony powyżej"),
          ],
        ),
      ),
    );
  }
}
