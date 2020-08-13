import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double pctOfTotal;

  const ChartBar(this.label, this.pctOfTotal);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Row(
          children: <Widget>[
            Text(
              label,
              style: Theme.of(context).textTheme.title,
            ),
            SizedBox(
              width: 3,
            ),
            Container(
              height: 12,
              width: 180,
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.0),
                      color: Color.fromRGBO(220, 220, 220, 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: pctOfTotal,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.amber[400],
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 5,
            ),
          ],
        );
      },
    );
  }
}
