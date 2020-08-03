import 'package:flutter/material.dart';
import 'package:new_emfor/providers/read.dart';
import 'package:new_emfor/widgets/chat/guarantee_window.dart';
import 'package:new_emfor/widgets/chat/shadow_sheet.dart';
import 'package:provider/provider.dart';

class SecondProcess extends StatelessWidget {
  bool exp;
  @override
  Widget build(BuildContext context) {
    exp = Provider.of<Read>(context).expanded;
    return ShadowSheet(
      color: Colors.red[300],
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Gwarancja usługi",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          SizedBox(
            height: 6,
          ),
          if (exp)
            Column(
              children: [
                Text(
                  "Oferta gwarancji usługi została odrzucona przez wykonawcę. Postarajcie się jeszcze raz ustalić szczegóły umowy, a następnie ją renegocjujcie",
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    Expanded(child: SizedBox()),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            GuaranteeWindow.routeName,
                            arguments: true);
                      },
                      child: Text(
                        "Renegocjuj gwarancje",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.yellow[600]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}
