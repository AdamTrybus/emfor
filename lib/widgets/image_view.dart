import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  static const String routeName = "image-view";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: FadeInImage.assetNetwork(
          placeholder: "assets/user_image.png",
          image: ModalRoute.of(context).settings.arguments,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
