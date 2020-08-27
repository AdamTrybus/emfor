import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final Color textColor, backgroundColor;
  final Function onPressed;
  final double horizontalPadding;

  const MyButton({
    this.text = "Dalej",
    this.textColor = Colors.white,
    this.backgroundColor = Colors.black,
    this.onPressed,
    this.horizontalPadding = 25,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: RaisedButton(
        onPressed: onPressed ?? () {},
        color: backgroundColor,
        elevation: 4,
        child: Text(
          text,
          style: TextStyle(
            fontFamily: "Quicksand",
            color: textColor,
            fontSize: 32,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
