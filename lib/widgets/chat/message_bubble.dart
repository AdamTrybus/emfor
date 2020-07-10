import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(
    this.message,
    this.isMe,
  );

  final String message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
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
      ],
    );
  }
}
