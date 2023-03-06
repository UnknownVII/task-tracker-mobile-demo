import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_tracker_mobile_demo/Models/task_model.dart';
import 'package:task_tracker_mobile_demo/Services/task_services.dart';
import 'package:task_tracker_mobile_demo/Styles/text-styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

late Image imageLogo;
var _isVisible = true;

class _HomePageState extends State<HomePage> {
  late int defaultChoiceIndex = 0;
  List<String> _choicesList = ['All', 'Prioritized', 'Completed'];

  late TaskRequestModel taskRequestModel;

  late var authHeaders;
  List<dynamic> _userTasks = [];

  Future getUserData() async {
    TaskService taskService = new TaskService();
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var userID = sharedPreferences.getString('userID');
    var authKey = sharedPreferences.getString('authKey');

    taskRequestModel.userID = userID!;
    taskRequestModel.token = authKey!;

    taskService.getAll(taskRequestModel).then((_userData) {
      if (_userData.tasks != null) {
        // print(_userData.tasks);
        print("HERE");
      } else {
        print("Error: " + _userData.error.toString());
        print("Message: " + _userData.message.toString());
        print(_userData.tasks ?? 'No Tasks');
      }
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    taskRequestModel = new TaskRequestModel(userID: '', token: '');
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          backgroundColor: Color(0xFF071E3D),
          body: Column(
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
                          setState(() {
                            defaultChoiceIndex = value ? index : defaultChoiceIndex;
                          });
                        },
                        // backgroundColor: color,
                        elevation: 1,
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        backgroundColor: Color(0xFF071E3D),
                      );
                    }),
                  ),
                ],
              ),
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () async {
                        getUserData();
                      },
                      child: Container(
                        width: 70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '  Test',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF202342),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          floatingActionButton: Visibility(
            visible: _isVisible,
            child: FloatingActionButton(
              onPressed: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => CreateNewContact()));
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
                PopupMenuButton<int>(
                  icon: Icon(
                    Icons.menu_rounded,
                    color: Color(0xFFE4EBF8),
                  ),
                  color: Color(0xFFE4EBF8),
                  itemBuilder: (context) => [
                    PopupMenuItem<int>(
                      value: 0,
                      child: Text('Account'),
                    ),
                    // PopupMenuItem<int>(
                    //   value: 1,
                    //   child: Text('About'),
                    // ),
                    // PopupMenuItem<int>(
                    //   value: 3,
                    //   //enabled: false,
                    //   child: new Container(width: 95, child: Text('App version')),
                    // ),
                    PopupMenuDivider(),
                    PopupMenuItem<int>(
                      value: 2,
                      child: Row(
                        children: [
                          Icon(Icons.logout, color: Color(0xFFFD5066)),
                          const SizedBox(
                            width: 7,
                          ),
                          Text(
                            "Logout",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFD5066),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
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
            title: TextField(decoration: InputDecoration(hintText: "Search", border: InputBorder.none, hintStyle: TextStyle(color: Colors.grey))),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.close_rounded, color: Color(0xFF021632)),
                onPressed: () {},
              ),
            ],
            elevation: 2,
          ),
        ),
      ],
    );
  }

  selectedItem(BuildContext context, Object? item) {
    switch (item) {
      case 0:
        //print("Account is Pressed");
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => AccountScreen(currentUser: currentUser, lengthList: lengthList),
        //     ),
        //   );
        break;
      case 1:
        //print("About is Pressed");
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => AboutScreen(),
        //     ),
        //   );
        break;
      case 2:
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return new AlertDialog(
              title: const Text("Logout",
                  style: TextStyle(
                    color: Color(0xFF5B3415),
                    fontWeight: FontWeight.bold,
                  )),
              content: const Text("Are you sure to Logout?"),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
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
                  },
                  child: const Text("LOGOUT", style: TextStyle(color: Color(0xFFFD5066))),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    "CANCEL",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            );
          },
        );
        break;
      case 3:
        setState(() {
          Fluttertoast.showToast(msg: "App ver.0.2.1-alpha", backgroundColor: Color(0xFF202342), textColor: Color(0xFFE4EBF8), toastLength: Toast.LENGTH_SHORT);
        });
    }
  }
}
