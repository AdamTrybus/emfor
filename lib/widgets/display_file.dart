import 'package:flutter/material.dart';
import 'package:new_emfor/widgets/image_view.dart';
import 'package:url_launcher/url_launcher.dart';

class DisplayFile extends StatelessWidget {
  final String url;
  final chat, profile;
  DisplayFile(this.url, {this.chat = false, this.profile = false});
  @override
  Widget build(BuildContext context) {
    var l = url.toString().split(".").last.split("?").first;
    String asset = "";
    if (l == "jpg" || l == "jpeg" || l == "png") {
      return InkWell(
          onTap: () => Navigator.of(context)
              .pushNamed(ImageView.routeName, arguments: url),
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
              child: Image.network(
                url,
                fit: BoxFit.cover,
                width: chat ? 180 : 60,
                height: chat ? 200 : 80,
              )));
    } else if (l == "pdf") {
      asset = "pdf.png";
    } else if (l == "tiff") {
      asset = "tiff.png";
    } else if (l == "doc") {
      asset = "doc.png";
    } else if (l == "txt") {
      asset = "txt.png";
    }
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 4.0,
      ),
      child: asset.isNotEmpty
          ? InkWell(
              onTap: () => launch(url),
              child: Image.asset(
                "assets/$asset",
                fit: BoxFit.cover,
                height: profile ? 50 : 70,
                width: profile ? 40 : 50,
              ),
            )
          : SizedBox(
              height: 70,
              width: 50,
              child: CircularProgressIndicator(),
            ),
    );
  }
}
