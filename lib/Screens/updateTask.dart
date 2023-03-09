import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:task_tracker_mobile_demo/Components/alert-dialog.dart';
import 'package:task_tracker_mobile_demo/Components/date-picker.dart';
import 'package:task_tracker_mobile_demo/Components/flutter-switch.dart';
import 'package:task_tracker_mobile_demo/Components/time-picker.dart';
import 'package:task_tracker_mobile_demo/Styles/text-styles.dart';
import 'package:task_tracker_mobile_demo/Utilities/check_login.dart';
import 'package:task_tracker_mobile_demo/Utilities/validators.dart';
import '../Components/text-input-field.dart';
import '../Models/task_model.dart';
import '../Styles/button-styles.dart';
import '../Utilities/progress_hud.dart';

class UpdateTask extends StatefulWidget {
  final String taskID;

  const UpdateTask({Key? key, required this.taskID}) : super(key: key);

  @override
  State<UpdateTask> createState() => _UpdateTaskState(taskID);
}

class _UpdateTaskState extends State<UpdateTask> {
  GlobalKey<FormState> globalFormKey = new GlobalKey<FormState>();
  final DateFormat formatter = DateFormat('MM-dd-yyyy');
  final DateFormat timeFormatter = DateFormat('HH:mm');
  final String specificID;
  FocusNode titleFocus = new FocusNode();
  FocusNode descriptionFocus = new FocusNode();

  FocusNode dateFocus = new FocusNode();
  FocusNode startFocus = new FocusNode();
  FocusNode endFocus = new FocusNode();

  var titleController = TextEditingController();
  var descriptionController = TextEditingController();

  var dateController = TextEditingController();
  var startController = TextEditingController();
  var endController = TextEditingController();

  late TaskCreateRequestModel taskCreateRequestModel;
  bool isApiCallProcess = true;
  bool isPrioritized = false;
  bool isTimed = false;
  bool check = false;

  List<Task> _tasks = [];
  String message = "";

  _UpdateTaskState(this.specificID);

  Future<void> _getSpecificData(String taskID) async {
    List<dynamic> data = await getSpecificData(taskID);
    message = "";
    if (data.isNotEmpty) {
      if (data[0] is Task) {
        _tasks = data.cast<Task>();
      } else if (data[0] is String) {
        setState(() {
          message = data[0];
          print(message);
        });
      }
    }
    if (message.isNotEmpty) {
      setState(
        () {

          Fluttertoast.showToast(
            msg: message,
            backgroundColor: Color(0xFF202342),
            textColor: Color(0xFFE4EBF8),
          );
        },
      );
    } else {
      setState(
        () {
          print(_tasks);
          titleController.text = _tasks[0].title.toString();
          descriptionController.text = _tasks[0].description.toString();
          dateController.text = DateFormat('MM-dd-yyyy').format(_tasks[0].dueDate);
          startController.text = _tasks[0].startTime.toString();
          endController.text = _tasks[0].endTime.toString();
          isPrioritized = _tasks[0].prioritize;
          isTimed =
              (_tasks[0].startTime.isNotEmpty && _tasks[0].endTime.isNotEmpty);
          isApiCallProcess = false;
          Fluttertoast.showToast(
            msg: 'Specific task fetched',
            backgroundColor: Color(0xFF202342),
            textColor: Color(0xFFE4EBF8),
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getSpecificData(specificID);
    // Start listening to changes.
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    titleFocus.dispose();
    descriptionFocus.dispose();
    dateFocus.dispose();
    startFocus.dispose();
    endFocus.dispose();

    titleController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    startController.dispose();
    endController.dispose();

    super.dispose();
  }

  Future<void> _updateSpecificData(String taskID) async {
    isApiCallProcess = true;
    FocusManager.instance.primaryFocus?.unfocus();
    List<dynamic> data = await updateSpecificTask(
        titleController.text.toString(),
        taskID,
        descriptionController.text.toString(),
        dateController.text.toString(),
        startController.text.toString(),
        endController.text.toString(),
        isPrioritized);
    String message = "";

    if (data.isNotEmpty) {
      message = data[0];
    }
    if (message.isNotEmpty) {
      setState(
        () {   print("hello");
          Fluttertoast.showToast(
            msg: message,
            backgroundColor: Color(0xFF202342),
            textColor: Color(0xFFE4EBF8),
          );

          if (message == 'message: "ID[$specificID] Updated Successfully"' ||
              message.contains('ID[$specificID] Updated Successfully') ||
              message.compareTo('message: "ID[$specificID] Updated Successfully"') == 0) {
            globalFormKey.currentState!.reset();
            isApiCallProcess = false;
            Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
          }
        },
      );
    } else {
      setState(
        () {
          Fluttertoast.showToast(
            msg: 'Something went wrong',
            backgroundColor: Color(0xFF202342),
            textColor: Color(0xFFE4EBF8),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: buildUI(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget buildUI(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (titleController.text.isNotEmpty ||
            descriptionController.text.isNotEmpty ||
            dateController.text.isNotEmpty ||
            startController.text.isNotEmpty ||
            endController.text.isNotEmpty) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return alertDialog(
                    content: "You have unsaved changes. Discard changes?",
                    header: 'Unsaved changes',
                    choice: true);
              }).then(
            (value) {
              if (value == null) {
                return check = false;
              }
              if (value) {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/home', (_) => false);
              } else {
                return check = false;
              }
            },
          );
        } else {
          return check = true;
        }
        return check;
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Create Task",
              style: headerTextStyle,
            ),
            centerTitle: true,
            actions: [
              if (isTimed == true)
                TextButton(
                    onPressed: (titleController.text.isNotEmpty &&
                            descriptionController.text.isNotEmpty &&
                            dateController.text.isNotEmpty &&
                            startController.text.isNotEmpty &&
                            endController.text.isNotEmpty)
                        ? () {
                            if (validateAndSave()) {
                              _updateSpecificData(specificID);
                            }
                          }
                        : null,
                    child: Text(
                        style: (titleController.text.isNotEmpty &&
                                descriptionController.text.isNotEmpty &&
                                dateController.text.isNotEmpty &&
                                startController.text.isNotEmpty &&
                                endController.text.isNotEmpty)
                            ? btnTextStyleWhite
                            : btnTextStyleDark,
                        'Save')),
              if (isTimed == false)
                TextButton(
                  onPressed: (titleController.text.isNotEmpty &&
                          descriptionController.text.isNotEmpty &&
                          dateController.text.isNotEmpty)
                      ? () {
                          if (validateAndSave()) {
                            _updateSpecificData(specificID);
                          }
                        }
                      : null,
                  child: Text(
                      style: (titleController.text.isNotEmpty &&
                              descriptionController.text.isNotEmpty &&
                              dateController.text.isNotEmpty)
                          ? btnTextStyleWhite
                          : btnTextStyleDark,
                      'Save'),
                ),
            ],
          ),
          backgroundColor: Color(0xFF072B5A),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Container(
                child: Form(
                  key: globalFormKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 80,
                        child: textFormField(
                          controller: titleController,
                          readOnly: false,
                          focusNode: titleFocus,
                          onTap: _requestFocusTitle,
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.text,
                          keyboardAction: TextInputAction.next,
                          onSaved: (input) => titleController.text = input!,
                          validator: (input) => validateTitle(input!),
                          label: 'Title',
                          maxLength: 20,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 150,
                        child: textFormField(
                          controller: descriptionController,
                          readOnly: false,
                          alignLabelWithHint: true,
                          focusNode: descriptionFocus,
                          onTap: _requestFocusDescription,
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.multiline,
                          keyboardAction: TextInputAction.done,
                          onSaved: (input) =>
                              descriptionController.text = input!,
                          validator: (input) => validateDescription(input!),
                          label: 'Description',
                          maxLength: 250,
                          maxLine: 10,
                          textAlignVertical: TextAlignVertical.top,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 80,
                        child: textFormField(
                          readOnly: true,
                          enableInteractiveSelection: false,
                          textCapitalization: TextCapitalization.none,
                          onTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CalendarWidget();
                                }).then(
                              (value) {
                                setState(
                                  () {
                                    if (value == false) {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    }
                                    if (value != false && value != null) {
                                      dateController.text =
                                          formatter.format(value).toString();
                                      print(formatter.format(value).toString());
                                    }
                                    if (value == null &&
                                        dateController.text.isEmpty) {
                                      Fluttertoast.showToast(
                                          msg: 'Please select date');
                                    }
                                  },
                                );
                              },
                            );
                          },
                          controller: dateController,
                          focusNode: dateFocus,
                          keyboardType: TextInputType.datetime,
                          keyboardAction: TextInputAction.done,
                          onSaved: (input) => dateController.text = input!,
                          validator: (input) => validateDate(input!),
                          label: 'Due date',
                          prefix: Icon(Icons.calendar_month_rounded,
                              color: Theme.of(context).primaryColor),
                          suffix: IconButton(
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CalendarWidget();
                                  }).then(
                                (value) {
                                  setState(
                                    () {
                                      if (value == false) {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                      }
                                      if (value != false && value != null) {
                                        dateController.text =
                                            formatter.format(value).toString();
                                      }
                                      if (value == null &&
                                          dateController.text.isEmpty) {
                                        Fluttertoast.showToast(
                                            msg: 'Please select date');
                                      }
                                    },
                                  );
                                },
                              );
                            },
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.5),
                            icon: Icon(Icons.arrow_drop_down_sharp,
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 80,
                            width: 180,
                            child: textFormField(
                              enabled: isTimed,
                              readOnly: true,
                              enableInteractiveSelection: false,
                              textCapitalization: TextCapitalization.none,
                              onTap: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return timePIckerCuper(
                                      isFirst: true,
                                      selectedDate: DateTime.now(),
                                      onDateTimeChanged: (newTime) => setState(
                                        () {
                                          startController.text =
                                              timeFormatter.format(newTime);
                                          endController.clear();
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                              controller: startController,
                              focusNode: startFocus,
                              keyboardType: TextInputType.datetime,
                              keyboardAction: TextInputAction.done,
                              onSaved: (input) => startController.text = input!,
                              validator: (input) =>
                                  isTimed ? validateTime(input!) : null,
                              label: 'Start',
                              prefix: Icon(Icons.access_time_filled_rounded,
                                  color: Theme.of(context).primaryColor),
                              suffix: IconButton(
                                onPressed: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return timePIckerCuper(
                                        isFirst: true,
                                        selectedDate: DateTime.now(),
                                        onDateTimeChanged: (newTime) =>
                                            setState(
                                          () {
                                            startController.text =
                                                timeFormatter.format(newTime);
                                            endController.clear();
                                          },
                                        ),
                                      );
                                    },
                                  );
                                },
                                icon: Icon(Icons.arrow_drop_down_sharp,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 80,
                            width: 180,
                            child: textFormField(
                              enabled: isTimed,
                              readOnly: true,
                              enableInteractiveSelection: false,
                              textCapitalization: TextCapitalization.none,
                              onTap: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    String timeString =
                                        startController.text.toString();
                                    DateTime parsedTime =
                                        DateFormat('HH:mm').parse(timeString);
                                    return timePIckerCuper(
                                      isFirst: false,
                                      selectedDate: parsedTime,
                                      onDateTimeChanged: (newTime) => setState(
                                        () {
                                          endController.text =
                                              timeFormatter.format(newTime);
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                              controller: endController,
                              focusNode: endFocus,
                              keyboardType: TextInputType.datetime,
                              keyboardAction: TextInputAction.done,
                              onSaved: (input) => endController.text = input!,
                              validator: (input) =>
                                  isTimed ? validateTime(input!) : null,
                              label: 'End',
                              prefix: Icon(Icons.access_time_filled_rounded,
                                  color: Theme.of(context).primaryColor),
                              suffix: IconButton(
                                onPressed: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      String timeString =
                                          startController.text.toString();
                                      DateTime parsedTime =
                                          DateFormat('HH:mm').parse(timeString);
                                      return timePIckerCuper(
                                        isFirst: false,
                                        selectedDate: parsedTime,
                                        onDateTimeChanged: (newTime) =>
                                            setState(
                                          () {
                                            endController.text =
                                                timeFormatter.format(newTime);
                                          },
                                        ),
                                      );
                                    },
                                  );
                                },
                                icon: Icon(Icons.arrow_drop_down_sharp,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 270,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Prioritized',
                                  style: headerMinTextStyle,
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                                  style: headerSubMinTextStyle,
                                ),
                              ],
                            ),
                          ),
                          flutterSwitch(
                            values: isPrioritized,
                            onToggle: (newTest) => setState(
                              () {
                                isPrioritized = !isPrioritized;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 270,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Timed',
                                  style: headerMinTextStyle,
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                                  style: headerSubMinTextStyle,
                                ),
                              ],
                            ),
                          ),
                          flutterSwitch(
                            values: isTimed,
                            onToggle: (newTest) => setState(
                              () {
                                isTimed = !isTimed;
                                if (isTimed == false) {
                                  setState(() {
                                    startController.clear();
                                    endController.clear();
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void _requestFocusTitle() {
    setState(() {
      FocusScope.of(context).requestFocus(titleFocus);
    });
  }

  void _requestFocusDescription() {
    setState(() {
      FocusScope.of(context).requestFocus(descriptionFocus);
    });
  }
}
