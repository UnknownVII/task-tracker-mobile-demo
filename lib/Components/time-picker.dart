import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:task_tracker_mobile_demo/Styles/text-styles.dart';

import '../Styles/button-styles.dart';

class timePIckerCuper extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateTimeChanged;
  final bool isFirst;

  timePIckerCuper({Key? key, required this.onDateTimeChanged, required this.selectedDate, required this.isFirst}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double itemExtent = 90;
    final int hours = 24;
    final int minutes = 60;

    final int initialHour = selectedDate.hour;
    final int initialMinute = selectedDate.minute;

    int selectedTimeHour = initialHour;
    int selectedTimeMin = initialMinute;

    return Card(
      elevation: 10,
      margin: EdgeInsets.symmetric(vertical: 120, horizontal: 50),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
            child: Text(
              'Select Start Time',
              style: headerTextStyleDark,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 140,
                    child: CupertinoPicker(
                      looping: true,
                      backgroundColor: CupertinoColors.white,
                      itemExtent: itemExtent,
                      onSelectedItemChanged: (int index) {
                        selectedTimeHour = index;
                      },
                      children: List<Widget>.generate(hours, (int index) {
                        final String hourText = '${index.toString().padLeft(2, '0')}';
                        return Center(
                          child: Text(hourText, style: TextStyle(fontSize: 24.0)),
                        );
                      }),
                      scrollController: FixedExtentScrollController(initialItem: initialHour),
                    ),
                  ),
                  Text(
                    ":",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  Container(
                    width: 140,
                    child: CupertinoPicker(
                      looping: true,
                      backgroundColor: CupertinoColors.white,
                      itemExtent: itemExtent,
                      onSelectedItemChanged: (int index) {
                        selectedTimeMin = index;
                      },
                      children: List<Widget>.generate(minutes, (int index) {
                        final String minuteText = '${index.toString().padLeft(2, '0')}';
                        return Center(
                          child: Text(minuteText, style: TextStyle(fontSize: 24.0)),
                        );
                      }),
                      scrollController: FixedExtentScrollController(initialItem: initialMinute),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          ElevatedButton(
              style: elevatedBtnFilled,
              onPressed: () async {
                if (isFirst == true){
                  DateTime newDateTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTimeHour, selectedTimeMin);
                  onDateTimeChanged(newDateTime);
                  Navigator.pop(context, newDateTime);
                } else {
                  if (selectedDate.hour == selectedTimeHour && selectedDate.minute == selectedTimeMin) {
                    Fluttertoast.showToast(msg: 'Time must not be equal to the start time which is ${selectedDate.hour.toString().padLeft(2, '0')}:${selectedDate.minute.toString().padLeft(2, '0')}');
                  } else {
                    DateTime newDateTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTimeHour, selectedTimeMin);
                    if (newDateTime.isBefore(selectedDate)) {
                      Fluttertoast.showToast(msg: 'Time must be greater than current time which is ${selectedDate.hour.toString().padLeft(2, '0')}:${selectedDate.minute.toString().padLeft(2, '0')}');
                    } else {
                      onDateTimeChanged(newDateTime);
                      Navigator.pop(context, newDateTime);
                    }
                  }
                }

              },
              child: Text(style: btnTextStyleDark, 'Select Time')),
          SizedBox(
            height: 15,
          ),
          ElevatedButton(
              style: elevatedBtnHollow,
              onPressed: () async {
                Navigator.pop(context, null);
              },
              child: Text(style: btnTextStyleDark, 'Cancel')),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
