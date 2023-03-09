import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_tracker_mobile_demo/Models/login_model.dart';

import '../Services/api_services.dart';

late RegisterRequestModel registerRequestModel =
    new RegisterRequestModel(name: '', email: '', password: '');
late LoginRequestModel loginRequestModel =
    new LoginRequestModel(email: '', password: '');

Future registerAccount(String name, String email, String password) async {
  List<dynamic> value = [];
  LoginService loginService = new LoginService();

  registerRequestModel.name = name!;
  registerRequestModel.email = email!;
  registerRequestModel.password = password!;

  await loginService.register(registerRequestModel).then(
    (_userData) {
      if (_userData.error.isNotEmpty) {
        value.add(_userData.error.replaceAll('\n', ''));
      }
      if (_userData.message.isNotEmpty) {
        value.add(_userData.message.replaceAll('\n', ''));
      }
    },
  );
  return value;
}

Future loginAccount(String email, String password) async {
  List<dynamic> value = [];
  LoginService loginService = new LoginService();

  loginRequestModel.email = email!;
  loginRequestModel.password = password!;

  await loginService.login(loginRequestModel).then(
    (_userData) async {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      if (_userData.authToken.isNotEmpty) {
        sharedPreferences.setString(
            'data', loginRequestModel.toJson().toString());
        sharedPreferences.setString('authKey', _userData.authToken.toString());
        sharedPreferences.setString(
            'currentUser', _userData.message.toString());
        sharedPreferences.setString(
            'currentEmail', loginRequestModel.email.toString());
        sharedPreferences.setString('userID', _userData.userID.toString());
      }
      if (_userData.error.isNotEmpty) {
        value.add(_userData.error.replaceAll('\n', ''));
      }
      if (_userData.message.isNotEmpty) {
        value.add(_userData.message.replaceAll('\n', ''));
      }
    },
  );
  return value;
}
