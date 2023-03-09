import 'dart:ui';
import 'package:flutter/material.dart';

class alertDialog extends StatelessWidget {
  final String content;
  final String header;
  final bool choice;

  const alertDialog({Key? key, required this.content, required this.header, required this.choice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: new AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.error,
              color: Color(0xFFFD5066),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              header,
              style: TextStyle(
                color: Color(0xFF021632),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: new Text(content),
        actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text("OK", style: TextStyle(color: Color(0xFF021632), fontWeight: FontWeight.bold))),
          if (choice)
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("CANCEL", style: TextStyle(color: Color(0xFF021632)))),
        ],
      ),
    );
  }
}
