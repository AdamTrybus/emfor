import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class WaitingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[500],
              spreadRadius: 0,
              blurRadius: 8,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
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
            Row(
              children: [
                Expanded(
                  child: SizedBox(),
                  flex: 4,
                ),
                GestureDetector(
                  onTap: () {},
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
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 3,
                width: 80,
                child: Divider(
                  thickness: 3,
                ),
              ),
            ),
          ],
        ));
  }
}
