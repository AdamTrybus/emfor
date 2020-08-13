import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_emfor/providers/read.dart';
import 'package:new_emfor/widgets/chat/guarantee_window.dart';
import 'package:new_emfor/widgets/chat/shadow_sheet.dart';
import 'package:provider/provider.dart';

class InitialProcess extends StatelessWidget {
  bool exp;
  @override
  Widget build(BuildContext context) {
    exp = Provider.of<Read>(context).expanded;
    return ShadowSheet(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (exp)
            Column(
              children: [
                Text(
                  "Aby uzyskać gwarancję musisz podać nam jeszcze kilka informacji, takich jak cena czy termin - skonsultowanych z wykonawcą",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
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
                            arguments: false);
                      },
                      child: Text(
                        "Uzyskaj gwarancje",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.amber[600]),
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
