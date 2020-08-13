import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_emfor/screens/support_screen.dart';
import 'package:new_emfor/widgets/rating_dialog.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:new_emfor/providers/depute.dart';
import 'package:new_emfor/providers/deputes.dart';
import 'package:new_emfor/widgets/depute/depute_detail_info.dart';
import 'package:new_emfor/widgets/depute/renegotiate_window.dart';
import 'package:new_emfor/widgets/depute/side_window.dart';
import 'package:provider/provider.dart';

class DeputeInfo extends StatefulWidget {
  @override
  _DeputeInfoState createState() => _DeputeInfoState();
}

class _DeputeInfoState extends State<DeputeInfo> {
  Depute depute;
  bool isExpert;
  Widget info(String text) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(2),
          child: Icon(
            Icons.stop,
            size: 12,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.overline,
          ),
        ),
      ],
    );
  }

  Widget view() {
    List<String> date = depute.meet.split("/").reversed.toList();
    print(date);
    var dt = DateTime.utc(
        int.parse(date[0]), int.parse(date[1]), int.parse(date[2]));
    print(dt);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 4,
        ),
        info(depute.noticeTitle),
        SizedBox(
          height: 1,
        ),
        info("${depute.estimate}zł"),
        SizedBox(
          height: 1,
        ),
        info(depute.meet),
        SizedBox(
          height: 1,
        ),
        info(depute.place),
        SizedBox(
          height: 3,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FlatButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              child: Text(
                "Przejrzyj",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(DeputeDetailInfo.routeName);
              },
            ),
            DateTime.now().isAfter(dt) && !isExpert
                ? InkWell(
                    child: Text(
                      "Oceń usługę",
                      style: TextStyle(
                        color: Colors.amber[600],
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(RatingDialog.routeName,
                          arguments: {
                            "expertPhone": depute.expertPhone,
                            "principalPhone": depute.principalPhone
                          });
                    })
                : FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    child: Text(
                      "Edytuj",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(RenegotiateWindow.routeName);
                    }),
            DateTime.now().isAfter(dt)
                ? FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    child: Text(
                      "Zgłoś problem",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(SupportScreen.routeName);
                    })
                : FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    child: Text(
                      "Odwołaj",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              elevation: 4,
                              content: Text(
                                "Czy pernamentnie chcesz anulować umowę?",
                                style: Theme.of(context).textTheme.subhead,
                              ),
                              actions: [
                                FlatButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text(
                                      "Nie",
                                      style: Theme.of(context).textTheme.title,
                                    )),
                                FlatButton(
                                    onPressed: () {
                                      Firestore.instance
                                          .collection("chat")
                                          .document(depute.chatId)
                                          .updateData({
                                        "estimate": "5",
                                        "meet": "-",
                                        "attentions": "-"
                                      });
                                    },
                                    child: Text(
                                      "Tak",
                                      style: Theme.of(context).textTheme.title,
                                    ))
                              ],
                            );
                          });
                    },
                  ),
          ],
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
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    depute = Provider.of<Deputes>(context).chosenDepute;
    isExpert = Provider.of<Deputes>(context).isExert;
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
        ),
        child: view());
  }
}
