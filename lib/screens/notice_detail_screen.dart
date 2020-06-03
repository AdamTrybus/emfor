import 'package:provider/provider.dart';
import '../providers/notice.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NoticeDetailScreen extends StatelessWidget {
  static const routeName = '/notice_detail-screen';
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height * 0.3 > 190.0
        ? MediaQuery.of(context).size.height * 0.3
        : 200.0;
    Notice notice = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
              target: LatLng(52.237049, 21.017532),
              zoom: 16,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 15, left: 16, right: 16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Pralka nie działa",
                        //notice.title,
                        style: TextStyle(fontFamily: "Quicksand", fontSize: 22),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "79.99",
                        //notice.price.toStringAsFixed(2),
                        style: TextStyle(
                            fontFamily: "OpenSans",
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Nie działa mi pralka, proszę o pomoc",
                        //notice.description,
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w300,
                            fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      Expanded(child: SizedBox()),
                      FlatButton(
                          onPressed: () {},
                          child: Text(
                            "Wybierz termin spotkania",
                            style: TextStyle(
                              color: Colors.amber[700],
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                      SizedBox(
                        height: 4,
                      ),
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
