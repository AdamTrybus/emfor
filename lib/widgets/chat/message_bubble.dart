import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(
    this.url,
    this.message,
    this.isMe,
  );
  final String url;
  final String message;
  final bool isMe;

  Widget exten(BuildContext context) {
    var l = url.split(".").last.split("?").first;
    var asset = "";
    if (l == "jpg" || l == "jpeg" || l == "png") {
      return InkWell(
          onTap: () => launch(
              url), //Navigator.of(context).pushNamed(NetworkView.routeName, arguments: url),
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
              constraints: BoxConstraints(
                maxHeight: 200,
                maxWidth: 200,
              ),
              child: Image.network(
                url,
                fit: BoxFit.cover,
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
    if (asset.isNotEmpty) {
      return InkWell(
        onTap: () => launch(
            url), //Navigator.of(context).pushNamed(NetworkView.routeName, arguments: url),
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
            constraints: BoxConstraints(
              maxHeight: 50,
              maxWidth: 30,
            ),
            child: Image.asset(
              "assets/$asset",
              fit: BoxFit.cover,
            )),
      );
    } else {
      return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        if (message != null)
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.8),
              decoration: BoxDecoration(
                color: isMe ? Colors.white : Colors.amber[400],
              ),
              padding: EdgeInsets.symmetric(
                vertical: 6,
                horizontal: 12,
              ),
              margin: EdgeInsets.symmetric(
                vertical: 1.8,
                horizontal: 8,
              ),
              child: Text(
                message,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  color: isMe ? Colors.black87 : Colors.white,
                ),
              ),
            ),
          ),
        if (url != null) exten(context)
      ],
    );
  }
}
