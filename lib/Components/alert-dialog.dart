import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class alertDialog extends StatelessWidget {
  final String content;
  final String header;

  const alertDialog({Key? key, required this.content, required this.header}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.error,
            color: Color(0xFFFD5066),
          ),
          SizedBox(width: 10,),
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
              Navigator.of(context).pop();
            },
            child: const Text("OK", style: TextStyle(color: Color(0xFF021632)))),
      ],
    );
  }
}
