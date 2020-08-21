import 'dart:math';

import 'package:flutter/material.dart';
import 'package:new_emfor/providers/depute.dart';
import 'package:new_emfor/providers/deputes.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:intl/intl.dart';

class DeputeTimeline extends StatefulWidget {
  static const String routeName = "depute-timeline";

  @override
  _DeputeTimelineState createState() => _DeputeTimelineState();
}

class _DeputeTimelineState extends State<DeputeTimeline> {
  Depute depute;
  bool loading = true;
  List activities = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration()).then((value) {
      depute = Provider.of<Deputes>(context, listen: false).chosenDepute;
      activities = Provider.of<Deputes>(context, listen: false).getActivities();
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                shrinkWrap: true,
                children: [
                  Text(
                    "Oś czasu",
                    style: Theme.of(context).textTheme.headline,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ListView.builder(
                      itemCount: activities.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, i) {
                        var d = DateFormat("dd/MM/yyyy HH:mm")
                            .parse(activities[i]["data"]);
                        bool before = d.isBefore(DateTime.now());
                        return TimelineTile(
                          alignment: TimelineAlign.left,
                          isFirst: i == 0,
                          isLast: i + 1 == activities.length,
                          indicatorStyle: IndicatorStyle(
                            width: 20,
                            color: before ? Colors.blue : Colors.black54,
                            padding: EdgeInsets.all(6),
                          ),
                          rightChild: Container(
                            constraints: BoxConstraints(
                              minHeight: 50,
                            ),
                            padding: EdgeInsets.only(
                                left: 6, right: 6, top: 4, bottom: 2),
                            margin: EdgeInsets.symmetric(
                                horizontal: 6, vertical: 12),
                            decoration: BoxDecoration(
                              color: activities[i]["color"] ?? Colors.white,
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
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    activities[i]["text"] ?? "",
                                    style: Theme.of(context).textTheme.overline,
                                  ),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(activities[i]["data"] ?? "",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w200,
                                          fontFamily: "OpenSans")),
                                )
                              ],
                            ),
                          ),
                          topLineStyle: LineStyle(
                            color: before ? Colors.blue : Colors.grey,
                          ),
                        );
                      }),
                ],
              ),
      ),
    );
  }
}
