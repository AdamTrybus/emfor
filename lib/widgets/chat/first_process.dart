import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:new_emfor/providers/read.dart';
import 'package:new_emfor/widgets/chat/guarantee_window.dart';
import 'package:new_emfor/widgets/chat/shadow_sheet.dart';
import 'package:provider/provider.dart';

class FirstProcess extends StatelessWidget {
  bool exp;
  @override
  Widget build(BuildContext context) {
    exp = Provider.of<Read>(context).expanded;
    return ShadowSheet(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Oczekiwanie na odpowiedź wykonawcy",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Lato"),
              ),
              SpinKitWave(
                color: Colors.teal,
                size: 20,
                duration: Duration(milliseconds: 1500),
              ),
            ],
          ),
          SizedBox(
            height: 6,
          ),
          if (exp)
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(),
                      flex: 4,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            GuaranteeWindow.routeName,
                            arguments: true);
                      },
                      child: Text(
                        "Edytuj oferte",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.amber[700],
                            fontFamily: "Quicksand"),
                      ),
                    ),
                    Expanded(child: SizedBox()),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}
