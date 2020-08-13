import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_emfor/providers/notice.dart';
import 'package:new_emfor/widgets/list_item.dart';
import 'package:new_emfor/widgets/display_file.dart';

class InfoDetailBuilder extends StatefulWidget {
  InfoDetailBuilder({this.notice, this.height, this.estimate = ""});
  final Notice notice;
  final double height;
  final String estimate;

  @override
  _InfoDetailBuilderState createState() => _InfoDetailBuilderState();
}

class _InfoDetailBuilderState extends State<InfoDetailBuilder> {
  BitmapDescriptor pinLocationIcon;
  Set<Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();
  @override
  void initState() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.5), 'assets/marker.png')
        .then((onValue) {
      pinLocationIcon = onValue;
    });
  }

  Widget varieties(context) {
    var variety = widget.notice.variety;
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
          height: widget.height * 0.45,
          child: GoogleMap(
            mapType: MapType.normal,
            zoomControlsEnabled: false,
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              setState(() {
                _markers.add(Marker(
                    markerId: MarkerId("id"),
                    position: LatLng(
                      double.parse(widget.notice.lat),
                      double.parse(widget.notice.lng),
                    ),
                    icon: pinLocationIcon));
              });
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(
                double.parse(widget.notice.lat),
                double.parse(widget.notice.lng),
              ),
              zoom: 16,
            ),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
          child: Column(children: [
            widget.estimate.isNotEmpty
                ? ListItem(baseText: "Cena", infoText: widget.estimate)
                : SizedBox(),
            ListItem(baseText: "Usługa", infoText: widget.notice.service),
            ListItem(baseText: "Miejsce", infoText: widget.notice.place),
            ListItem(
              baseText: "Termin",
              infoText: widget.notice.time,
            ),
            varieties(context),
            ListItem(
                baseText: "Opis",
                divider: false,
                infoText: widget.notice.description),
            SizedBox(
              height: 70,
              child: ListView.builder(
                  //padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.notice.files.length,
                  itemBuilder: (ctx, i) {
                    var url = widget.notice.files[i];
                    return DisplayFile(url);
                  }),
            ),
          ]),
        ),
      ],
    );
  }
}
