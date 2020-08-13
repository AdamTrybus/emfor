import 'package:flutter/material.dart';
import 'package:new_emfor/widgets/button.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RatingDialog extends StatelessWidget {
  static const String routeName = "rating - dialog";
  double rate = 0.0;
  String comment = "", expertPhone, principalPhone, expertImage, expertName;
  @override
  Widget build(BuildContext context) {
    var map = ModalRoute.of(context).settings.arguments as Map<String, String>;
    expertPhone = map["expertPhone"];
    principalPhone = map["principalPhone"];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Oceń wykonawcę",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
            future: Firestore.instance
                .collection("users")
                .document(expertPhone)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              expertImage = snapshot.data["imageUrl"];
              expertName = snapshot.data["name"];
              return FutureBuilder(
                  future: Firestore.instance
                      .collection("users")
                      .document(expertPhone)
                      .collection("feedback")
                      .document(principalPhone)
                      .get(),
                  builder: (context, sp) {
                    if (sp.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (sp.data != null) {
                      comment = sp.data["comment"] ?? "";
                      rate = sp.data["rate"] ?? 0.0;
                    }

                    return Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 90,
                          width: 90,
                          child: CircleAvatar(
                            backgroundImage: expertImage != null
                                ? NetworkImage(
                                    expertImage,
                                  )
                                : AssetImage(
                                    "assets/user_image.png",
                                  ),
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        RatingBar(
                          onRatingChanged: (d) => rate = d,
                          size: 60,
                          filledIcon: Icons.star,
                          emptyIcon: Icons.star_border,
                          filledColor: Colors.amber,
                          emptyColor: Colors.amber[100],
                          initialRating: rate,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: TextField(
                            onChanged: (v) => comment = v,
                            style: Theme.of(context).textTheme.subhead,
                            controller: TextEditingController()..text = comment,
                            decoration: InputDecoration(
                              hintText: "Twoja opinia",
                              contentPadding: EdgeInsets.all(12.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        Expanded(child: SizedBox()),
                        MyButton(
                          text: "Zatwierdź",
                          onPressed: () async {
                            var prefs = await SharedPreferences.getInstance();
                            Firestore.instance
                                .collection("users")
                                .document(expertPhone)
                                .collection("feedback")
                                .document(principalPhone)
                                .setData({
                              "comment": comment,
                              "rate": rate,
                              "name": prefs.getString("name"),
                              "imageUrl": prefs.getString("image"),
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    );
                  });
            }),
      ),
    );
  }
}
