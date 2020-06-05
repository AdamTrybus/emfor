import 'package:new_emfor/widgets/price_sheet.dart';
import 'package:provider/provider.dart';
import '../providers/notice.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NoticeDetailScreen extends StatelessWidget {
  static const routeName = '/notice_detail-screen';
  Notice notice;
  Widget varieties() {
    var variety = notice.variety;
    var keys = variety.keys.toList();
    var values = variety.values.toList();
    return ListView.builder(
      shrinkWrap: true,
      itemCount: keys.length,
      itemBuilder: (ctx, i) => Column(
        children: [
          Text(
            keys[i],
            style: Theme.of(ctx).textTheme.subhead,
          ),
          SizedBox(
            height: 2,
          ),
          Text(
            values[i],
            style: Theme.of(ctx).textTheme.title,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height * 0.45 > 280.0
        ? MediaQuery.of(context).size.height * 0.45
        : 280.0;
    notice = ModalRoute.of(context).settings.arguments;
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
                        notice.service,
                        style: TextStyle(fontFamily: "Quicksand", fontSize: 22),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        notice.place,
                        style: TextStyle(
                            fontFamily: "OpenSans",
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      varieties(),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        notice.description,
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w300,
                            fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      Expanded(child: SizedBox()),
                      FlatButton(
                          onPressed: () {
                            showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(25.0))),
                              isScrollControlled: true,
                              context: context,
                              builder: (ctx) {
                                return PriceSheet(notice);
                              },
                            );
                          },
                          child: Text(
                            "Wyceń usługę",
                            style: TextStyle(
                              color: Colors.amber[700],
                              fontSize: 18,
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
