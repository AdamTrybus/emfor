import 'package:flutter/material.dart';
import 'package:new_emfor/providers/depute.dart';
import 'package:new_emfor/providers/deputes.dart';
import 'package:new_emfor/widgets/depute/depute_timeline.dart';
import 'package:new_emfor/widgets/depute/side_window.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

class DeputeInfo extends StatelessWidget {
  Depute depute;
  bool first = false, last = false;
  String data, text;

  void values(context) {
    Map act = Provider.of<Deputes>(context, listen: false).currentActivity();
    data = act["data"];
    text = act["text"];
    last = act["last"] ?? false;
    first = act["first"] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    depute = Provider.of<Deputes>(context).chosenDepute;
    values(context);
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(DeputeTimeline.routeName),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Column(
          children: [
            TimelineTile(
              alignment: TimelineAlign.left,
              isFirst: first,
              isLast: last,
              indicatorStyle: const IndicatorStyle(
                width: 20,
                color: Colors.blue,
                padding: EdgeInsets.all(6),
              ),
              rightChild: Container(
                constraints: BoxConstraints(
                  minHeight: 50,
                ),
                padding: EdgeInsets.only(left: 6, right: 6, top: 4, bottom: 2),
                margin: EdgeInsets.symmetric(horizontal: 6, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[300],
                      spreadRadius: 0,
                      blurRadius: 8,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      text,
                      style: Theme.of(context).textTheme.overline,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(data,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w200,
                              fontFamily: "OpenSans")),
                    )
                  ],
                ),
              ),
              topLineStyle: const LineStyle(
                color: Colors.blue,
              ),
            ),
            if (!Provider.of<Deputes>(context).side && depute.process == 5)
              Column(
                children: [
                  Divider(
                    thickness: 2,
                  ),
                  FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onPressed: () {
                      Navigator.of(context).pushNamed(SideWindow.routeName);
                    },
                    child: Text(
                      "Sprawdź nową ofertę",
                      style: Theme.of(context).textTheme.overline,
                    ),
                  )
                ],
              ),
          ],
        ),
      ),
    );
  }
}
