import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:new_emfor/providers/rate.dart';
import 'package:new_emfor/widgets/chart_bar.dart';
import 'package:new_emfor/widgets/display_file.dart';
import 'package:new_emfor/widgets/list_item.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = "profile-screen";
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Rate> rates = [
    Rate(
        image: "assets/poland_icon.png",
        comment:
            "Rucham twoja matke na trzepaku gdy byla mala kurewka i ja wyzynam za 5 zl chuju, a i odpierdol sie od mojej rodziny",
        mark: 4,
        name: "Kurwa twoja stara XD",
        phone: "asdas",
        createdAt: "22/07/2020"),
    Rate(
        image: "assets/marker.png",
        comment:
            "Rucham twoja matke na trzepaku gdy  a i odpierdol sie od mojej rodziny",
        mark: 3,
        name: "Adam Gajewski",
        phone: "asdas",
        createdAt: "19/07/2020"),
    Rate(
        image: "assets/poland_icon.png",
        comment: "odpierdol sie od mojej rodziny",
        mark: 5,
        name: "twoja stara",
        phone: "asdas",
        createdAt: "21/07/2020"),
    Rate(
        image: "assets/emfor_logo.png",
        comment: "chuje jebane rucham was kurwy",
        mark: 4,
        name: "Chuj hihi",
        phone: "asdas",
        createdAt: "02/07/2020"),
  ];

  List<Map<String, Object>> get groupedRates {
    return List.generate(5, (index) {
      var amount = 0;

      for (var i = 0; i < rates.length; i++) {
        if (rates[i].mark == index + 1) {
          amount++;
        }
      }

      return {
        'mark': index + 1,
        'amount': amount,
      };
    }).reversed.toList();
  }

  double get overall {
    var s = rates.fold(0.0, (sum, item) {
      return sum + item.mark;
    });
    return s / rates.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder(
          future: Firestore.instance
              .collection("users")
              .document(ModalRoute.of(context).settings.arguments)
              .get(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            List<dynamic> files = snapshot.data["files"] ?? [];
            return ListView(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    height: 120,
                    width: 120,
                    child: Card(
                      elevation: 1.6,
                      shape: CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: CircleAvatar(
                        backgroundImage: snapshot.data["imageUrl"] != null
                            ? NetworkImage(
                                snapshot.data["imageUrl"],
                              )
                            : AssetImage(
                                "assets/user_image.png",
                              ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ListItem(
                  baseText: "Imię / firma",
                  infoText: snapshot.data["name"],
                ),
                ListItem(
                  baseText: "Zawód",
                  infoText:
                      "${snapshot.data["category"]}, od ${snapshot.data["expierence"]}",
                ),
                ListItem(
                  baseText: "Opis",
                  infoText: snapshot.data["description"],
                ),
                if (files.isNotEmpty)
                  Column(
                    children: [
                      Text(
                        "Załączniki:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      SizedBox(
                        height: 58,
                        child: ListView.builder(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: files.length,
                          itemBuilder: (ctx, i) => DisplayFile(
                            files[i].toString(),
                            profile: true,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 12,
                        child: Divider(
                          color: Colors.black38,
                          endIndent: 8,
                          indent: 8,
                          height: 2,
                        ),
                      ),
                    ],
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 130,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: groupedRates.map((data) {
                            return Flexible(
                              fit: FlexFit.tight,
                              child: ChartBar(
                                data['mark'].toString(),
                                rates.length == 0.0
                                    ? 0.0
                                    : (data['amount'] as int) / rates.length,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          "$overall",
                          style: TextStyle(
                              fontFamily: "OpenSans",
                              fontSize: 60,
                              fontWeight: FontWeight.w600),
                        ),
                        RatingBarIndicator(
                          rating: overall,
                          itemSize: 18,
                          unratedColor: Colors.amber[100],
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                        ),
                        Text(
                          "opinie: ${rates.length}",
                          style: Theme.of(context).textTheme.overline,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                ListView.builder(
                  itemCount: rates.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (ctx, i) => Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: 32,
                            width: 32,
                            child: CircleAvatar(
                              backgroundImage: rates[i].image != null
                                  ? NetworkImage(
                                      snapshot.data["imageUrl"],
                                    )
                                  : AssetImage(
                                      "assets/user_image.png",
                                    ),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                              rates[i].name,
                              style: Theme.of(context).textTheme.title,
                            ),
                          ),
                          RatingBarIndicator(
                            rating: rates[i].mark,
                            itemCount: 5,
                            itemSize: 18,
                            unratedColor: Colors.amber[100],
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 4),
                          child: Text(
                            rates[i].comment,
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Quicksand",
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            rates[i].createdAt,
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
