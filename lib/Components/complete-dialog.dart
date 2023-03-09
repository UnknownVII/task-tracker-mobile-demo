import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:task_tracker_mobile_demo/Utilities/check_login.dart';
import '../Styles/button-styles.dart';
import 'alert-dialog.dart';

Future<void> _deleteData(String taskID) async {
  List<dynamic> data = await deleteTaskStatus(taskID);
  String message = "";
  if (data.isNotEmpty) {
    message = data[0];
  }
  if (message.isNotEmpty) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Color(0xFF202342),
      textColor: Color(0xFFE4EBF8),
    );
  } else {
    Fluttertoast.showToast(
      msg: 'Something went wrong',
      backgroundColor: Color(0xFF202342),
      textColor: Color(0xFFE4EBF8),
    );
  }
}

class confirmDialog extends StatelessWidget {
  final String userID;
  final String taskID;
  final String title;
  final String? status;
  final String dueDate;
  final String startTime;
  final String endTime;
  final bool prioritize;

  const confirmDialog({
    Key? key,
    required this.userID,
    required this.taskID,
    required this.title,
    required this.dueDate,
    required this.startTime,
    required this.endTime,
    required this.prioritize,
    this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: new AlertDialog(
        shape: Border(
          top: prioritize == true ? BorderSide(color: Color(0xFF21E6C1), width: 10) : BorderSide(),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            new Text(
              title,
              style: TextStyle(
                color: Color(0xFF021632),
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: () => {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alertDialog(
                        header: "Delete",
                        content: 'You will be deleting $title'
                            '${prioritize == true ? ",${status == 'Incomplete' ? " it is set as Prioritize" : " it is Completed"}" : "${status == 'Incomplete' ? "" : ", it is Completed"}"}',
                        choice: true,
                      );
                    }).then((value) {
                  if (value == true) {
                    _deleteData(taskID);
                    Navigator.of(context).pop('Deleted');
                  }
                })
              },
              icon: Icon(
                Icons.delete_forever,
                size: 24,
                color: Color(0xFF021632),
              ),
            ),
          ],
        ),
        content: Container(
          height: 60,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              new Text('Due date: $dueDate'),
              SizedBox(
                height: 15,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    new Text('Start time: ${startTime.isEmpty ? 'N/A' : startTime}'),
                    new Text('End time: ${endTime.isEmpty ? 'N/A' : endTime}'),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Center(
            child: Container(
              child: Column(
                children: [
                  if (status == 'Incomplete')
                    ElevatedButton(
                        style: elevatedBtnFilled,
                        onPressed: () async {
                          Navigator.of(context).pop(true);
                        },
                        child: Text(style: btnTextStyleDark, 'Mark as Complete')),
                  if (status == 'Incomplete')
                    SizedBox(
                      height: 15,
                    ),
                  if (status == 'Incomplete')
                    ElevatedButton(
                        style: elevatedBtnHollow,
                        onPressed: () async {
                          Navigator.of(context).pop(false);
                        },
                        child: Text(style: btnTextStyleDark, 'Cancel')),
                  if (status == 'Complete')
                    ElevatedButton(
                        style: elevatedBtnFilled,
                        onPressed: () async {
                          Navigator.of(context).pop(false);
                        },
                        child: Text(style: btnTextStyleDark, 'Close')),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
