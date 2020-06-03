import '../providers/notice.dart';
import '../screens/notice_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NoticeItem extends StatelessWidget {
  final Notice notice;
  NoticeItem(this.notice);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 10,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: GridTile(
        child: GoogleMap(
          mapType: MapType.normal,
          zoomControlsEnabled: false,
          initialCameraPosition: CameraPosition(
            target: LatLng(52.237049, 21.017532),
            zoom: 16,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Color.fromRGBO(245, 247, 250, 1),
          title: Text(
            "Nie działa pralka",
            //notice.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: "OpenSans",
            ),
          ),
          leading: Text(
            "79.99",
            //notice.price.toStringAsFixed(2),
            style: TextStyle(
              fontFamily: "Lato",
              fontSize: 14,
            ),
          ),
          trailing: RaisedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(NoticeDetailScreen.routeName, arguments: notice);
            },
            child: Text(
              "szczegóły",
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w400,
                  fontSize: 14),
            ),
            color: Colors.amber[400],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
        ),
      ),
    );
  }
}
