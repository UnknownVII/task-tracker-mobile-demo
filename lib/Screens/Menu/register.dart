import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:task_tracker_mobile_demo/Utilities/check_account.dart';
import '../../Components/text-input-field.dart';
import '../../Models/login_model.dart';
import '../../Styles/button-styles.dart';
import '../../Styles/text-styles.dart';
import '../../Utilities/progress_hud.dart';
import '../../Utilities/validators.dart';

class RegisterAccount extends StatefulWidget {
  const RegisterAccount({Key? key}) : super(key: key);

  @override
  State<RegisterAccount> createState() => _RegisterAccountState();
}

class _RegisterAccountState extends State<RegisterAccount> {
  late Image imageLogo;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalFormKey = new GlobalKey<FormState>();
  bool hidePassword = true;

  FocusNode usernameFocus = new FocusNode();
  FocusNode emailFocus = new FocusNode();
  FocusNode passwordFocus = new FocusNode();
  var usernameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  late RegisterRequestModel requestModel;
  bool isApiCallProcess = false;

  Future<void> _registerAccount() async {
    List<dynamic> data = await registerAccount(
      usernameController.text.toString(),
      emailController.text.toString(),
      passwordController.text.toString(),
    );
    String message = "";
    if (data.isNotEmpty) {
      message = data[0];
    }
    if (message.isNotEmpty) {
      setState(
        () {
          isApiCallProcess = false;
          Fluttertoast.showToast(
            msg: message,
            backgroundColor: Color(0xFF202342),
            textColor: Color(0xFFE4EBF8),
          );
          if(message == '"message": "Account Created Successfully"' || message.contains('Account Created Successfully') || message.compareTo('"message": "Account Created Successfully"') == 0){
            globalFormKey.currentState!.reset();
            Navigator.pushNamedAndRemoveUntil(context, '/menu', (_) => false);
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
  void initState() {
    super.initState();
    emailFocus = FocusNode();
    passwordFocus = FocusNode();
    usernameFocus = FocusNode();

    requestModel = new RegisterRequestModel(email: '', password: '', name: '');
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
    usernameFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: buildUIRegister(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget buildUIRegister(BuildContext context) {
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
            title: Text(style: headerTextStyle, 'Register'),
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
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Form(
                    key: globalFormKey,
                    child: Container(
                      width: 340,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 80,
                            child: textFormField(
                              readOnly: false,
                              focusNode: usernameFocus,
                              onTap: _requestFocusUsername,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.sentences,
                              keyboardAction: TextInputAction.next,
                              onSaved: (input) => usernameController.text = input!,
                              validator: (input) => validateName(input!),
                              label: 'Username',
                              prefix: Icon(Icons.person,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                          SizedBox(
                            height: 80,
                            child: textFormField(
                              readOnly: false,
                              focusNode: emailFocus,
                              onTap: _requestFocusEmail,
                              keyboardType: TextInputType.emailAddress,
                              textCapitalization: TextCapitalization.none,
                              keyboardAction: TextInputAction.next,
                              onSaved: (input) => emailController.text = input!,
                              validator: (input) => validateEmail(input!),
                              label: 'Email',
                              prefix: Icon(Icons.email,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                          SizedBox(
                            height: 80,
                            child: textFormField(
                              readOnly: false,
                              focusNode: passwordFocus,
                              onTap: _requestFocusPassword,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.none,
                              keyboardAction: TextInputAction.done,
                              obscure: hidePassword,
                              onSaved: (input) =>
                                  passwordController.text = input!,
                              validator: (input) => validatePassword(input!),
                              label: 'Password',
                              prefix: Icon(Icons.lock,
                                  color: Theme.of(context).primaryColor),
                              suffix: IconButton(
                                onPressed: () {
                                  setState(() {
                                    hidePassword = !hidePassword;
                                  });
                                },
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.5),
                                icon: Icon(hidePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ),
                              maxLine: 1,
                            ),
                          ),
                        ],
                      ),
                    )),
                SizedBox(
                  height: 7,
                ),
                ElevatedButton(
                    style: elevatedBtnFilled,
                    onPressed: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      setState(() {
                        hidePassword = true;
                        isApiCallProcess = true;
                        if(validateAndSave()){
                          _registerAccount();
                        }
                      });
                    },
                    child: Text(style: btnTextStyleDark, 'Register')),
              ],
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

  void _requestFocusUsername() {
    setState(() {
      FocusScope.of(context).requestFocus(usernameFocus);
    });
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
