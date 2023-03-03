import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Models/login_model.dart';

class LoginService {
  var client = http.Client();

  Future<LoginResponseModel> login(LoginRequestModel loginRequestModel) async {
    print(loginRequestModel.toJson());
    String email = loginRequestModel.email.toString();
    String password = loginRequestModel.password.toString();
    final response = await client.post(Uri.parse('https://task-tracker-mobile-api.vercel.app/user/login'),
        headers: <String, String>{
          "Accept": "application/json",
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{'email': email, 'password': password}));
    if (response.statusCode == 200 || response.statusCode == 400) {
      String jsonDataString = response.body.toString().replaceAll("\n", "");
      var _data = jsonDecode(jsonDataString);
      return LoginResponseModel.fromJson(_data);
    } else {
      throw Exception('Failed to load data');
    }
  }
}

class RegisterService {
  var client = http.Client();

  Future<LoginResponseModel> register(RegisterRequestModel registerRequestModel) async {
    print(registerRequestModel.toJson());
    String name = registerRequestModel.name.toString();
    String email = registerRequestModel.email.toString();
    String password = registerRequestModel.password.toString();
    final response = await client.post(Uri.parse('https://task-tracker-mobile-api.vercel.app/user/register'),
        headers: <String, String>{
          "Accept": "application/json",
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{'name': name, 'email': email, 'password': password}));
    if (response.statusCode == 200 || response.statusCode == 400) {
      String jsonDataString = response.body.toString().replaceAll("\n", "");
      var _data = jsonDecode(jsonDataString);
      return LoginResponseModel.fromJson(_data);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
