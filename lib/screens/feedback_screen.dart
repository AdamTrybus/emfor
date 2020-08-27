import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:new_emfor/providers/rate.dart';
import 'package:new_emfor/widgets/chart_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackScreen extends StatelessWidget {
  static const String routeName = "Feedback-screen";
  List<Rate> rates = [];
  List<Map<String, Object>> get groupedRates {
    return List.generate(5, (index) {
      var amount = 0;

      for (var i = 0; i < rates.length; i++) {
        if (rates[i].rate == index + 1) {
          amount++;
        }
      }

      return {
        'rate': index + 1,
        'amount': amount,
      };
    }).reversed.toList();
  }

  double get overall {
    var s = rates.fold(0.0, (sum, item) {
      return sum + item.rate;
    });
    if (rates.isNotEmpty)
      return s / rates.length;
    else
      return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Opinie"),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop()),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder: (ctx, s) {
            if (s.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return FutureBuilder(
                future: Firestore.instance
                    .collection("users")
                    .document(s.data.getString("uid"))
                    .collection("feedback")
                    .getDocuments(),
                builder: (ctx, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  rates = [];
                  snap.data.documents.forEach((element) {
                    rates.add(Rate(
                        imageUrl: element["imageUrl"],
                        comment: element["comment"],
                        rate: element["rate"].toDouble(),
                        name: element["name"],
                        uid: element["uid"],
                        createdAt: element["createdAt"]));
                  });
                  return ListView(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    children: [
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: groupedRates.map((data) {
                                  return Flexible(
                                    fit: FlexFit.tight,
                                    child: ChartBar(
                                      data['rate'].toString(),
                                      rates.length == 0.0
                                          ? 0.0
                                          : (data['amount'] as int) /
                                              rates.length,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                overall.toStringAsFixed(2),
                                style: TextStyle(
                                    fontFamily: "OpenSans",
                                    fontSize: 54,
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
                      Divider(
                        indent: 8,
                        endIndent: 8,
                        thickness: 2,
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
                                    backgroundImage: rates[i].imageUrl != null
                                        ? NetworkImage(
                                            rates[i].imageUrl,
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
                                  rating: rates[i].rate,
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  rates[i].createdAt,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                });
          },
        ),
      ),
    );
  }
}
