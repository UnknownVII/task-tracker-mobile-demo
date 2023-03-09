import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:task_tracker_mobile_demo/Screens/updateTask.dart';
import 'package:task_tracker_mobile_demo/Utilities/check_login.dart';
import 'alert-dialog.dart';

// Future<void> _editData(String taskID) async {
//   List<dynamic> data = await deleteTaskStatus(taskID);
//   String message = "";
//   if (data.isNotEmpty) {
//     message = data[0];
//   }
//   if (message.isNotEmpty) {
//     Fluttertoast.showToast(
//       msg: message,
//       backgroundColor: Color(0xFF202342),
//       textColor: Color(0xFFE4EBF8),
//     );
//   } else {
//     Fluttertoast.showToast(
//       msg: 'Something went wrong',
//       backgroundColor: Color(0xFF202342),
//       textColor: Color(0xFFE4EBF8),
//     );
//   }
// }

class viewDialog extends StatelessWidget {
  final String userID;
  final String taskID;
  final String title;
  final String description;
  final String? status;
  final String dueDate;
  final String startTime;
  final String endTime;
  final bool prioritize;

  const viewDialog({
    Key? key,
    required this.userID,
    required this.taskID,
    required this.title,
    required this.description,
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
          top: prioritize == true
              ? BorderSide(color: Color(0xFF21E6C1), width: 10)
              : BorderSide(),
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
                        header: "Edit",
                        content: 'You will be editing $title'
                            '${prioritize == true ? ",${status == 'Incomplete' ? " it is set as Prioritize" : " it is Completed"}" : "${status == 'Incomplete' ? "" : ", it is Completed"}"}',
                        choice: true,
                      );
                    }).then((value) {
                  if (value == true) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UpdateTask(taskID: taskID.toString()),
                      ),
                    );
                  }
                })
              },
              icon: Icon(
                Icons.edit,
                size: 24,
                color: Color(0xFF021632),
              ),
            ),
          ],
        ),
        content: Container(
          height: 220,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  new Text(
                    'Due date: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  new Text(dueDate),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        new Text(
                          'Start time: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        new Text('${startTime.isEmpty ? 'N/A' : startTime}'),
                      ],
                    ),
                    Row(
                      children: [
                        new Text(
                          'End time: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        new Text(' ${endTime.isEmpty ? 'N/A' : endTime}'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              new Text(
                'Description:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15,
              ),
              new Text(
                description,
                textAlign: TextAlign.justify,
                style: TextStyle(height: 1.5),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("OKAY",
                  style: TextStyle(
                      color: Color(0xFF021632), fontWeight: FontWeight.w900))),
        ],
      ),
    );
  }
}
