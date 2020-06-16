import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final Color textColor, backgroundColor;
  final Function onPressed;

  const MyButton(
      {this.text,
      this.textColor,
      this.backgroundColor,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: RaisedButton(
        onPressed: onPressed ?? (){},
        color: backgroundColor ?? Colors.black,
        elevation: 4,
        child: Text(
          text ?? "Dalej",
          style: TextStyle(
            fontFamily: "Gotham",
            color: textColor ?? Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
