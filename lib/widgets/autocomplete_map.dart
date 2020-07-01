import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location/location.dart' as loc;
import 'package:new_emfor/providers/work.dart';
import 'package:provider/provider.dart';

class AutocompleteMap extends StatefulWidget {
  @override
  _AutocompleteMapState createState() => _AutocompleteMapState();
}

class _AutocompleteMapState extends State<AutocompleteMap> {
  String userLocation = "Twoja lokalizacja";
  GoogleMapsPlaces _places =
      GoogleMapsPlaces(apiKey: "AIzaSyB2RixKsuCGgMrF7n7BgrGKqCzuYaoU0MY");

  Future<void> _getUserLocation(Prediction p) async {
    try {
      Coordinates coordinates;
      if (p == null) {
        final locData = await loc.Location().getLocation();
        coordinates = new Coordinates(locData.latitude, locData.longitude);
      } else {
        PlacesDetailsResponse detail =
            await _places.getDetailsByPlaceId(p.placeId);
        final lat = detail.result.geometry.location.lat;
        final lng = detail.result.geometry.location.lng;
        coordinates = new Coordinates(lat, lng);
      }
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      userLocation =
          "${first.thoroughfare} ${first.subThoroughfare ?? ""}, ${first.locality}";
      Provider.of<Work>(context, listen: false)
          .setNotice("place", userLocation);
      print(userLocation);
    } catch (error) {
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(microseconds: 0)).then((value) async {
      Provider.of<Work>(context, listen: false).setQuestion("place");
      setState(() {
        userLocation =
            Provider.of<Work>(context, listen: false).getNotice() ?? "";
      });
      print(userLocation);
      if (userLocation == "") {
        _getUserLocation(null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        border: Border.all(color: Colors.grey[300], width: 2),
        borderRadius: BorderRadius.all(
          Radius.circular(16.0),
        ),
      ),
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(12),
      child: ListTile(
        leading: Icon(Icons.location_city),
        title: Text(
          userLocation,
          style: Theme.of(context).textTheme.title,
        ),
        trailing: Icon(Icons.arrow_right),
        onTap: () async {
          Prediction p = await PlacesAutocomplete.show(
              context: context,
              apiKey: "AIzaSyB2RixKsuCGgMrF7n7BgrGKqCzuYaoU0MY",
              mode: Mode.overlay, // Mode.fullscreen
              language: "pl",
              components: [new Component(Component.country, "pl")]);
          _getUserLocation(p);
        },
      ),
    );
  }
}
