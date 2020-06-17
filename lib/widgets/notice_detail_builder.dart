import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_emfor/providers/notice.dart';
import 'package:new_emfor/widgets/list_item.dart';

class InfoDetailBuilder extends StatelessWidget {
  InfoDetailBuilder({this.notice, this.height});
  final Notice notice;
  final double height;

  Widget varieties(context) {
    var variety = notice.variety;
    var keys = variety.keys.toList();
    var values = variety.values.toList();
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: keys.length,
          itemBuilder: (ctx, i) =>
              ListItem(baseText: keys[i], infoText: values[i]),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: height * 0.5,
          child: GoogleMap(
            mapType: MapType.normal,
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
              target: LatLng(52.237049, 21.017532),
              zoom: 16,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
          child: Column(children: [
            ListItem(baseText: "Usługa", infoText: notice.service),
            ListItem(baseText: "Miejsce", infoText: notice.place),
            ListItem(
              baseText: "Termin",
              infoText: notice.time,
            ),
            varieties(context),
            ListItem(
                baseText: "Opis", divider: false, infoText: notice.description),
          ]),
        ),
      ],
    );
  }
}
