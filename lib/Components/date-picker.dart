import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CalendarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.symmetric(vertical: 150, horizontal: 50),
      child: Container(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
        child: SfDateRangePicker(
          view: DateRangePickerView.month,
          selectionMode: DateRangePickerSelectionMode.single,
          showActionButtons: true,
          allowViewNavigation: true,
          enablePastDates: false,
          monthViewSettings: DateRangePickerMonthViewSettings(enableSwipeSelection: true, showTrailingAndLeadingDates: true, showWeekNumber: false),
          onCancel: () {
            Navigator.of(context).pop(false);
          },
          onSubmit: (value) {
            Navigator.of(context).pop(value);
          },
        ),
      ),
    );
  }
}
