import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_tracker_mobile_demo/Models/login_model.dart';
import 'package:task_tracker_mobile_demo/Styles/button-styles.dart';
import 'package:task_tracker_mobile_demo/Utilities/api_account.dart';
import 'package:task_tracker_mobile_demo/Utilities/hideEmailAddress.dart';
import '../../Components/alert-dialog.dart';
import '../../Styles/text-styles.dart';
import 'createTask.dart';

class UserAccount extends StatefulWidget {
  const UserAccount({Key? key}) : super(key: key);

  @override
  State<UserAccount> createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  late Image imageLogo;
  List<UserData> _user_data = [];
  final DateFormat formatter = DateFormat('MM-dd-yyyy');
  late DateTime dateTime = DateTime.now();
  late String formattedDate = '';

  String message = "";
  bool hideEmail = false;

  Future<void> _getUserSpecificData() async {
    List<dynamic> data = await getUserSpecificData();
    message = "";
    if (data.isNotEmpty) {
      if (data[0] is UserData) {
        _user_data = data.cast<UserData>();
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
          DateTime.parse(_user_data[0].date).toLocal();
          formattedDate = formatter.format(dateTime);
          Fluttertoast.showToast(
            msg: 'All tasks fetched',
            backgroundColor: Color(0xFF202342),
            textColor: Color(0xFFE4EBF8),
          );
        },
      );
    }
  }

  @override
  initState()  {
    super.initState();
    imageLogo = Image.asset(
      'assets/app_ico_foreground.png',
      height: 100,
      width: 100,
    );
    _getUserSpecificData();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120.0),
          child: AppBar(
            leading: imageLogo,
            automaticallyImplyLeading: false,
            toolbarHeight: 120,
            flexibleSpace: Container(),
            title: Text(style: headerTextStyle, 'Profile'),
            actions: <Widget>[
              IconButton(
                onPressed: () => {
                  setState(() {
                    Navigator.of(context).pop();
                  })
                },
                icon: Icon(
                  Icons.arrow_back,
                  size: 24,
                  color: Color(0xFFE4EBF8),
                ),
              ),
              SizedBox(
                width: 18,
              )
            ],
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 100),
          child: Column(
            children: [
              Container(
                height: 260,
                color: Color(0xFFE4EBF8),
                child: _user_data.isNotEmpty
                    ? Padding(
                      padding: const EdgeInsets.all(17.0),
                      child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Name:',
                                  style: headerTextStyleDark,
                                ),
                                SizedBox(width: 32,),
                                Text(_user_data[0].name,
                                    style: headerTextStyleDarkLite),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Email:',
                                  style: headerTextStyleDark,
                                ),
                                Text(hideEmail ? _user_data[0].email.toString() : hideEmailAddress(_user_data[0].email.toString()) ,
                                    style: headerTextStyleDarkLite),

                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      hideEmail = !hideEmail;
                                    });
                                  },
                                  icon: Icon(hideEmail ? Icons.visibility : Icons.visibility_off),
                                )
                              ],
                            ),
                            Divider(
                              color: Color(0xFF21e6c1),
                              height: 5,
                              thickness: 1,
                              indent: 25,
                              endIndent: 25,
                            ),
                            SizedBox(height: 18,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Account Created:',
                                  style: headerTextStyleDark,
                                ),
                                Text(formattedDate,
                                    style: headerTextStyleDarkLite),
                              ],
                            ),
                            SizedBox(height: 18,),
                            Divider(
                              color: Color(0xFF21e6c1),
                              height: 5,
                              thickness: 1,
                              indent: 25,
                              endIndent: 25,
                            ),
                            SizedBox(height: 18,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _user_data[0].taskCount == 0
                                      ? "Task empty"
                                      : _user_data[0].taskCount == 1
                                      ? "Total created task: "
                                      : "Total created tasks: ",
                                  style: headerTextStyleDark,
                                ),
                                if(_user_data[0].taskCount == 0)
                                InkWell(
                                  onTap: () {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => CreateTask()));
                                  },
                                  child: Text(
                                    'Create Task',
                                    style: underlinedTextStyleDark,
                                  ),
                                ),
                                if(_user_data[0].taskCount > 0)
                                Text(_user_data[0].taskCount.toString(),
                                    style: headerTextStyleDarkLite),
                              ],
                            ),
                            SizedBox(height: 18,),
                            InkWell(
                              onTap: () {
                                Fluttertoast.showToast(msg: 'Feature not yet integrated');
                                // do something when the text is clicked
                              },
                              child: Text(
                                'Change Password',
                                style: underlinedTextStyleDark,
                              ),
                            ),

                          ],
                        ),
                    )
                    : Padding(
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE4EBF8)),
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
              ),
              SizedBox(height: 24,),
              ElevatedButton(
                onPressed: () {
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
                },
                child: Text(style: btnTextStyleDark, 'Logout'),
                style: elevatedBtnFilled,
              ),
              SizedBox(height: 24,),
              ElevatedButton(
                onPressed: () {
                  Fluttertoast.showToast(msg: 'Feature not yet integrated');
                },
                child: Text(
                  style: btnTextStyleRed,
                  'Delete Account',
                ),
                style: elevatedBtnHollowRed,
              ),
            ],
          ),
        ));
  }
}
