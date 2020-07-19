import 'package:flutter/material.dart';
import 'package:new_emfor/widgets/chat/confirm_window.dart';
import 'package:new_emfor/widgets/chat/shadow_sheet.dart';

class ConfirmProcess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ShadowSheet(
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
          Text(
            "Została przysłana oferta gwarancji usługi. Oferta obejmuje gwarancje wypłaty pieniędzy przez wykonawce oraz pracy wykonanej zgodnie z opisem przez ciebie",
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
                  Navigator.of(context)
                      .pushNamed(ConfirmWindow.routeName, arguments: false);
                },
                child: Text(
                  "Zobacz ofertę",
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
    );
  }
}
