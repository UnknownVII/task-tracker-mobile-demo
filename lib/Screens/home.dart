import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_tracker_mobile_demo/Components/alert-dialog.dart';
import 'package:task_tracker_mobile_demo/Components/complete-dialog.dart';
import 'package:task_tracker_mobile_demo/Components/pop-up-items.dart';
import 'package:task_tracker_mobile_demo/Components/view-dialog.dart';
import 'package:task_tracker_mobile_demo/Models/task_model.dart';
import 'package:task_tracker_mobile_demo/Screens/Home/createTask.dart';
import 'package:task_tracker_mobile_demo/Styles/text-styles.dart';
import 'package:intl/intl.dart';
import '../Styles/button-styles.dart';
import '../Utilities/api_userTask.dart';
import 'package:grouped_list/grouped_list.dart';

import 'Home/userAccount.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

late Image imageLogo;
var _isVisible = true;

class _HomePageState extends State<HomePage> {
  late int defaultChoiceIndex = 0;
  DateTime? lastPressed;
  var _searchEmpty = false;
  var stringVal = "";

  List<String> _choicesList = ['All Pending', 'Prioritized', 'Completed'];
  final DateFormat formatter = DateFormat('MM-dd-yyyy');
  final DateFormat formatterWithTime = DateFormat('MM-dd-yyyy HH:mm');
  var dateNow = new DateTime.now();
  late String strDateNow;
  TextEditingController editingController = TextEditingController();
  late String formattedDate;
  List<Task> _tasks = [];
  List<Task> _duplicatedData = [];
  bool isNowEmpty = false;
  bool isEmpty = false;
  bool isPrio = false;
  String _selectedTaskId = '';
  String message = "";
  String params = '';
  var lengthList = 0;
  var scrollController = ScrollController();

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchEmpty = false;
        _tasks = _duplicatedData;
      });
      return;
    }
    query = query.toLowerCase();
    List<Task> result = [];

    _duplicatedData.forEach((p) {
      var title = p.title.toString().toLowerCase();
      var description = p.description.toString().toLowerCase();
      var status = p.status.toString().toLowerCase();
      var dueDate = p.dueDate.toString().toLowerCase();

      if (title.contains(query) || description.contains(query) || status.contains(query) || dueDate.contains(query)) {
        result.add(p);
      }
    });

    if (result.isEmpty) {
      setState(
        () {
          _searchEmpty = true;
        },
      );
    } else {
      setState(
        () {
          _searchEmpty = false;
          _tasks = result;
        },
      );
    }
  }

  Future<void> _getData(String params) async {
    List<dynamic> data = await getUserData(params);
    message = "";
    if (data.isNotEmpty) {
      if (data[0] is Task) {
        _tasks = data.cast<Task>();
      } else if (data[0] is String) {
        setState(() {
          message = data[0];
        });
      }
    }
    if (message.isNotEmpty) {
      setState(
        () {
          isEmpty = true;
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
          isEmpty = false;
          setState(() {
            _duplicatedData = _tasks;
          });
          Fluttertoast.showToast(
            msg: 'All tasks fetched',
            backgroundColor: Color(0xFF202342),
            textColor: Color(0xFFE4EBF8),
          );
        },
      );
    }
  }

  Future<void> _updateData(String taskID, String status) async {
    List<dynamic> data = await updateTaskStatus(taskID, status);
    String message = "";
    if (data.isNotEmpty) {
      message = data[0];
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
          Fluttertoast.showToast(
            msg: 'Something went wrong',
            backgroundColor: Color(0xFF202342),
            textColor: Color(0xFFE4EBF8),
          );
        },
      );
    }
  }

  Future<void> _updateDataTask(String taskID, bool priority) async {
    List<dynamic> data = await updateTaskPriority(taskID, priority);
    String message = "";
    if (data.isNotEmpty) {
      message = data[0];
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
  initState() {
    super.initState();
    scrollController.addListener(() async {
      if (_tasks.length <= 5) {
        setState(() {
          _isVisible = true;
        });
      } else {
        if (scrollController.position.atEdge) {
          if (scrollController.position.pixels > 0) {
            if (_isVisible) {
              setState(() {
                _isVisible = false;
              });
            }
          }
        } else {
          if (!_isVisible) {
            setState(() {
              _isVisible = true;
            });
          }
        }
      }
    });
    params = "status=Incomplete";
    _getData(params);
    strDateNow = formatter.format(dateNow);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: WillPopScope(
        onWillPop: () async {
          final now = DateTime.now();
          final maxDuration = const Duration(seconds: 1);
          final isWarning = lastPressed == null || now.difference(lastPressed!) > maxDuration;
          if (isWarning) {
            lastPressed = DateTime.now();
            Fluttertoast.showToast(msg: "Double Tap to Close App", backgroundColor: Color(0xFF071E3D), textColor: Color(0xFFE4EBF8), toastLength: Toast.LENGTH_SHORT);
            return false;
          } else {
            Fluttertoast.cancel();
            return true;
          }
        },
        child: Stack(
          children: <Widget>[
            Scaffold(
              backgroundColor: Color(0xFF577399),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 160,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 26,
                        ),
                        Wrap(
                          spacing: 8,
                          children: List.generate(_choicesList.length, (index) {
                            return ChoiceChip(
                              labelPadding: defaultChoiceIndex != index ? EdgeInsets.all(0.0) : EdgeInsets.all(2.0),
                              label: Text(
                                _choicesList[index],
                                style: defaultChoiceIndex == index ? TextStyle(color: Color(0xFF021632), fontSize: 14, fontWeight: FontWeight.w700) : TextStyle(color: Color(0xFFE4EBF8), fontSize: 14),
                              ),
                              shape: defaultChoiceIndex != index ? StadiumBorder(side: BorderSide(color: Color(0xFFE4EBF8), width: 2, strokeAlign: StrokeAlign.inside)) : StadiumBorder(),
                              selected: defaultChoiceIndex == index,
                              selectedColor: Color(0xFFE4EBF8),
                              onSelected: (value) {
                                setState(
                                  () {
                                    defaultChoiceIndex = value ? index : defaultChoiceIndex;
                                    switch (defaultChoiceIndex) {
                                      case 0:
                                        setState(
                                          () {
                                            _tasks = [];
                                            isEmpty = false;
                                            isNowEmpty = false;
                                            _selectedTaskId = '';
                                            params = "status=Incomplete";
                                            _getData(params);
                                            if (_tasks.length <= 5) {
                                              _isVisible = true;
                                            }
                                            ;
                                          },
                                        );
                                        break;
                                      case 1:
                                        setState(
                                          () {
                                            _tasks = [];
                                            isEmpty = false;
                                            isNowEmpty = false;
                                            _selectedTaskId = '';
                                            params = "prioritize=true&status=Incomplete";
                                            _getData(params);
                                            if (_tasks.length <= 5) {
                                              _isVisible = true;
                                            }
                                            ;
                                          },
                                        );
                                        break;
                                      case 2:
                                        setState(
                                          () {
                                            _tasks = [];
                                            isEmpty = false;
                                            isNowEmpty = false;
                                            _selectedTaskId = '';
                                            params = "status=Complete";
                                            _getData(params);
                                            if (_tasks.length <= 5) {
                                              _isVisible = true;
                                            }
                                            ;
                                          },
                                        );
                                        break;
                                      default:
                                        setState(
                                          () {
                                            isEmpty = false;
                                            isNowEmpty = false;
                                            _selectedTaskId = '';
                                            params = "status=Incomplete";
                                            _getData(params);
                                            if (_tasks.length <= 5) {
                                              _isVisible = true;
                                            }
                                            ;
                                          },
                                        );
                                    }
                                    ;
                                  },
                                );
                              },
                              // backgroundColor: color,
                              elevation: 1,
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              backgroundColor: Color(0xFF577399),
                            );
                          }),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.zero,
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height - 223,
                      // color: Colors.white,
                      child: !_searchEmpty
                          ? FutureBuilder<List<dynamic>>(
                              builder: (context, snapshot) {
                                this.lengthList = _tasks.length;
                                return _tasks.length != 0
                                    ? RefreshIndicator(
                                        color: Theme.of(context).primaryColor,
                                        onRefresh: () {
                                          return _getData(params);
                                        },
                                        child: GroupedListView<dynamic, String>(
                                          physics: AlwaysScrollableScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          elements: _tasks,
                                          groupBy: (task) => formatter.format(task.dueDate),
                                          groupComparator: (value1, value2) {
                                            if (value1 == strDateNow) {
                                              return 1; // Today's date is first
                                            }
                                            if (value2 == strDateNow) {
                                              return -1; // Today's date is second
                                            }
                                            return value2.compareTo(value1); // Sort by descending date order
                                          },
                                          itemComparator: (item1, item2) => item1.title.compareTo(item2.title),
                                          order: GroupedListOrder.DESC,
                                          useStickyGroupSeparators: false,
                                          controller: scrollController,
                                          groupSeparatorBuilder: (String value) => Padding(
                                            padding: const EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                if (value == strDateNow) ...[
                                                  Text(
                                                    'Today',
                                                    textAlign: TextAlign.center,
                                                    style: headerTextStyle,
                                                  ),
                                                  Text(
                                                    value,
                                                    textAlign: TextAlign.center,
                                                    style: headerSubTextStyle,
                                                  ),
                                                ],
                                                if (value != strDateNow)
                                                  Text(
                                                    value,
                                                    textAlign: TextAlign.center,
                                                    style: headerSubTextStyle,
                                                  ),
                                              ],
                                            ),
                                          ),
                                          indexedItemBuilder: (c, task, count) {
                                            String date = formatter.format(task.dueDate);
                                            String doneDate = task.dateTimeFinished;

                                            if (doneDate != null && doneDate.isNotEmpty) {
                                              DateTime dateTime = DateTime.parse(doneDate).toLocal();
                                              formattedDate = formatterWithTime.format(dateTime);
                                            }

                                            return Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 8.5, horizontal: 15.0),
                                              child: Dismissible(
                                                key: Key(task.id.toString()),
                                                direction: DismissDirection.endToStart,
                                                child: Card(
                                                  margin: EdgeInsets.zero,
                                                  child: ClipPath(
                                                    child: InkWell(
                                                      onTap: () => {
                                                        showDialog(
                                                            context: context,
                                                            builder: (BuildContext context) {
                                                              return viewDialog(
                                                                userID: taskGetAllRequestModel.userID.toString(),
                                                                taskID: task.id,
                                                                title: task.title,
                                                                description: task.description,
                                                                status: task.status.toString(),
                                                                dueDate: date,
                                                                startTime: task.startTime,
                                                                endTime: task.endTime,
                                                                prioritize: task.prioritize,
                                                                indexPosition: defaultChoiceIndex,
                                                              );
                                                            })
                                                      },
                                                      onLongPress: () => {
                                                        if (task.status != 'Complete')
                                                          {
                                                            _updateDataTask(task.id, task.prioritize == true ? false : true),
                                                            setState(() {
                                                              if (defaultChoiceIndex == 1) {
                                                                _tasks.remove(task);
                                                                isNowEmpty = true;
                                                              }
                                                              _selectedTaskId = task.id;
                                                              task.prioritize = !task.prioritize;
                                                              isPrio = task.prioritize;
                                                            })
                                                          }
                                                        else
                                                          {
                                                            Fluttertoast.showToast(
                                                              msg: "Task is already Completed",
                                                              backgroundColor: Color(0xFF202342),
                                                              textColor: Color(0xFFE4EBF8),
                                                            ),
                                                          }
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          border: Border(
                                                            left: task.id == _selectedTaskId
                                                                ? isPrio
                                                                    ? BorderSide(color: Color(0xFF21E6C1), width: 8)
                                                                    : BorderSide()
                                                                : task.prioritize
                                                                    ? BorderSide(color: Color(0xFF21E6C1), width: 8)
                                                                    : BorderSide(),
                                                          ),
                                                        ),
                                                        child: ListTile(
                                                          title: Text(
                                                            task.title,
                                                            style: cardTitleTextStyle,
                                                          ),
                                                          subtitle: Text(
                                                            date,
                                                          ),
                                                          trailing: task.status.toString() == 'Complete'
                                                              ? Text(
                                                                  'Completed at: ${formattedDate}',
                                                                  style: cardSubTitleTextStyle,
                                                                )
                                                              : Text(''),
                                                          tileColor: Color(0xFFE4EBF8),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                background: Container(
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFF21E6C1),
                                                  ),
                                                ),
                                                onDismissed: (direction) {
                                                  _tasks.remove(task);
                                                  setState(() {
                                                    if (_tasks.length <= 5) {
                                                      setState(
                                                        () {
                                                          _isVisible = true;
                                                        },
                                                      );
                                                    }
                                                    if (_tasks.length == 0 || _tasks.isEmpty) {
                                                      isNowEmpty = true;
                                                    }
                                                  });
                                                },
                                                confirmDismiss: (DismissDirection direction) async {
                                                  return await showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return confirmDialog(
                                                          userID: taskGetAllRequestModel.userID.toString(),
                                                          taskID: task.id,
                                                          title: task.title,
                                                          status: task.status.toString(),
                                                          dueDate: date,
                                                          startTime: task.startTime,
                                                          endTime: task.endTime,
                                                          prioritize: task.prioritize);
                                                    },
                                                  ).then((value) {
                                                    if (value is bool) {
                                                      if (value == true) {
                                                        _updateData(task.id, 'Complete');
                                                      }
                                                      return value;
                                                    }
                                                    if (value is String) {
                                                      return true;
                                                    }
                                                  });
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    : isEmpty == false
                                        ? isNowEmpty == false
                                            ? Center(
                                                child: CircularProgressIndicator(
                                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE4EBF8)),
                                                  backgroundColor: Theme.of(context).primaryColor,
                                                ),
                                              )
                                            : Center(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      defaultChoiceIndex == 0
                                                          ? 'No Pending Task'
                                                          : defaultChoiceIndex == 1
                                                              ? 'No Prioritized Task'
                                                              : defaultChoiceIndex == 2
                                                                  ? 'No Completed Task'
                                                                  : '',
                                                      style: headerTextStyle,
                                                    ),
                                                  ],
                                                ),
                                              )
                                        : Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  defaultChoiceIndex == 0
                                                      ? 'No Pending Task'
                                                      : defaultChoiceIndex == 1
                                                          ? 'No Prioritized Task'
                                                          : defaultChoiceIndex == 2
                                                              ? 'No Completed Task'
                                                              : '',
                                                  style: headerTextStyle,
                                                ),
                                                if (message == '"error": "Connection Timed out. Please Try again"' ||
                                                    message.contains('Connection Timed out') ||
                                                    message.compareTo('"error": "Connection Timed out. Please Try again"') == 0) ...[
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  ElevatedButton(
                                                      style: elevatedBtnFilled,
                                                      onPressed: () async {
                                                        _getData(params);
                                                      },
                                                      child: Text(style: btnTextStyleDark, 'Retry')),
                                                  SizedBox(
                                                    height: 80,
                                                  ),
                                                ]
                                              ],
                                            ),
                                          );
                              },
                            )
                          : Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Container(
                                child: Column(
                                  children: [
                                    Text(
                                      "Search " + "'" + stringVal + "'" + " does not exists",
                                      style: TextStyle(color: Color(0xFFE4EBF8)),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Query can be of title, description, Due date, or Status ",
                                      style: TextStyle(color: Color(0xFFE4EBF8)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    )
                  ],
                ),
              ),
              floatingActionButton: Visibility(
                visible: _isVisible,
                child: FloatingActionButton(
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CreateTask()));
                  },
                  child: Icon(
                    Icons.add,
                  ),
                  foregroundColor: Color(0xFFE4EBF8),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Container(
                height: 120,
                child: AppBar(
                  leading: Image.asset(
                    'assets/app_ico_foreground.png',
                    height: 100,
                    width: 100,
                  ),
                  title: Text(
                    "Task Tracker",
                    style: headerTextStyle,
                  ),
                  actions: [
                    PopUpMenu(
                      onSelected: (item) => selectedItem(context, item),
                    ),
                  ],
                )),
            Container(),
            Positioned(
              top: 90.0,
              left: 24.0,
              right: 24.0,
              child: AppBar(
                backgroundColor: Color(0xFFE4EBF8),
                leading: Icon(Icons.search, color: Color(0xFF021632)),
                primary: false,
                title: TextField(
                    controller: editingController,
                    onChanged: (value) {
                      filterSearchResults(value);
                      stringVal = value;
                    },
                    decoration: InputDecoration(hintText: "Search", border: InputBorder.none, hintStyle: TextStyle(color: Colors.grey))),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: Color(0xFF021632)),
                    onPressed: () {
                      editingController.clear();
                      filterSearchResults("");
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      setState(() {
                        _tasks = _duplicatedData;
                      });

                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    },
                  ),
                ],
                elevation: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  selectedItem(BuildContext context, Object? item) {
    switch (item) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserAccount(),
          ),
        );
        break;
      case 1:
        break;
      case 2:
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alertDialog(content: 'Are you sure you want to log out?', header: 'Logout', choice: true);
          },
        ).then(
          (value) async {
            if (value) {
              final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
              sharedPreferences.remove('data');
              sharedPreferences.remove('authKey');
              sharedPreferences.remove('currentUser');
              sharedPreferences.remove('currentEmail');
              sharedPreferences.remove('userID');
              Fluttertoast.showToast(
                msg: "Logged out Successfully",
                backgroundColor: Color(0xFF202342),
                textColor: Color(0xFFE4EBF8),
              );
              Navigator.pushNamedAndRemoveUntil(context, '/menu', (_) => false);
            }
          },
        );
        break;
      case 3:
        setState(() {
          Fluttertoast.showToast(msg: "App ver.1.0.0-alpha", backgroundColor: Color(0xFF202342), textColor: Color(0xFFE4EBF8), toastLength: Toast.LENGTH_SHORT);
        });
    }
  }
}
