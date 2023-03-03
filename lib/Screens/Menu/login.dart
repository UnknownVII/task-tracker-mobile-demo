import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_tracker_mobile_demo/Components/text-input-field.dart';
import 'package:task_tracker_mobile_demo/Models/login_model.dart';
import 'package:task_tracker_mobile_demo/Styles/text-styles.dart';

import '../../Services/api_services.dart';
import '../../Styles/button-styles.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late Image imageLogo;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalFormKey = new GlobalKey<FormState>();
  bool hidePassword = true;
  FocusNode emailFocus = new FocusNode();
  FocusNode passwordFocus = new FocusNode();

  late LoginRequestModel requestModel;
  bool isApiCallProcess = false;

  @override
  void initState() {
    super.initState();
    emailFocus = FocusNode();
    passwordFocus = FocusNode();
    requestModel = new LoginRequestModel(email: '', password: '');
    imageLogo = Image.asset(
      'assets/app_ico_foreground.png',
      height: 100,
      width: 100,
    );
  }

  @override
  void dispose() {
    emailFocus.dispose();
    passwordFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Timer _timer;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).primaryColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120.0),
          child: AppBar(
            leading: imageLogo,
            automaticallyImplyLeading: false,
            toolbarHeight: 120,
            flexibleSpace: Container(),
            title: Text(style: headerTextStyle, 'Login'),
            actions: <Widget>[
              IconButton(
                onPressed: () => {},
                icon: Icon(
                  Icons.arrow_back,
                  size: 24,
                  color: Color(0xFFE4EBF8),
                ),
              ),
            ],
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
        ),
        body: Center(
          child: Column(
            children: [
              Form(
                  key: globalFormKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 84,
                        width: 340,
                        child: textFormField(
                          focusNode: emailFocus,
                          onTap: _requestFocusEmail,
                          keyboardType: TextInputType.emailAddress,
                          keyboardAction: TextInputAction.next,
                          onSaved: (input) => requestModel.email = input!,
                          validator: (input) => !input!.contains("@") ? "Email Address invalid" : null,
                          label: 'Email',
                          prefix: Icon(Icons.email, color: Theme.of(context).primaryColor),
                        ),
                      ),
                      SizedBox(
                        height: 84,
                        width: 340,
                        child: textFormField(
                          focusNode: passwordFocus,
                          onTap: _requestFocusPassword,
                          keyboardType: TextInputType.text,
                          keyboardAction: TextInputAction.done,
                          obscure: hidePassword,
                          onSaved: (input) => requestModel.password = input!,
                          validator: (input) => input!.length < 6 ? "Password is less than 6 characters" : null,
                          label: 'Password',
                          prefix: Icon(Icons.lock, color: Theme.of(context).primaryColor),
                          suffix: IconButton(
                            onPressed: () {
                              setState(() {
                                hidePassword = !hidePassword;
                              });
                            },
                            color: Theme.of(context).primaryColor.withOpacity(0.5),
                            icon: Icon(hidePassword ? Icons.visibility : Icons.visibility_off),
                          ),
                        ),
                      ),
                    ],
                  )),
              SizedBox(
                height: 7,
              ),
              ElevatedButton(
                  style: elevatedBtnFilled,
                  onPressed: () async {
                    _timer = Timer(Duration(seconds: 20), () {
                      setState(
                        () {
                          isApiCallProcess = false;
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return new AlertDialog(
                                title: Row(
                                  children: [
                                    Icon(
                                      Icons.error,
                                      color: Color(0xFFFD5066),
                                    ),
                                    Text(
                                      "  Unexpected Error",
                                      style: TextStyle(
                                        color: Color(0xFF2E315A),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                content: Text('Connection Timeout [@_@]: Check your Internet Connection', textAlign: TextAlign.left),
                                actions: <Widget>[
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("OK", style: TextStyle(color: Color(0xFF2E315A)))),
                                ],
                              );
                            },
                          );
                        },
                      );
                    });
                    if (validateAndSave() == false) {
                      _timer.cancel();
                    }
                    FocusManager.instance.primaryFocus?.unfocus();
                    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                    if (validateAndSave()) {
                      setState(() {
                        isApiCallProcess = true;
                      });
                      LoginService apiService = new LoginService();
                      apiService.login(requestModel).then(
                        (value) {
                          setState(() {
                            isApiCallProcess = false;
                          });
                          if (value.authToken.isNotEmpty) {
                            _timer.cancel();
                            sharedPreferences.setString('data', requestModel.toJson().toString());
                            sharedPreferences.setString('authKey', value.authToken.toString());
                            sharedPreferences.setString('currentUser', value.message.toString());
                            sharedPreferences.setString('currentEmail', requestModel.email.toString());
                            globalFormKey.currentState!.reset();
                            Fluttertoast.showToast(msg: "Login Successful");
                            Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
                          } else {
                            _timer.cancel();
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return new AlertDialog(
                                  title: Row(
                                    children: [
                                      Icon(
                                        Icons.error,
                                        color: Color(0xFFFD5066),
                                      ),
                                      Text(
                                        "  Login",
                                        style: TextStyle(
                                          color: Color(0xFF2E315A),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  content: new Text(value.error),
                                  actions: <Widget>[
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("OK", style: TextStyle(color: Color(0xFF2E315A)))),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      );
                    }
                  },
                  child: Text(style: btnTextStyleDark, 'Login')),
            ],
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

  void _requestFocusEmail() {
    setState(() {
      FocusScope.of(context).requestFocus(emailFocus);
    });
  }

  void _requestFocusPassword() {
    setState(() {
      FocusScope.of(context).requestFocus(passwordFocus);
    });
  }
}
