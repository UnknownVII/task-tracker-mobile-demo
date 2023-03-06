class LoginResponseModel {
  String authToken;
  String error;
  String message;
  String userID;

  LoginResponseModel({required this.userID,required this.authToken, required this.error, required this.message});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      authToken: json['auth-token']  ??  '',
      userID: json['_id']  ??  '',
      error: json['error'] ??  '',
      message: json['message'] ??  '',
    );
  }
}

class LoginRequestModel {
  String email;
  String password;

  LoginRequestModel({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'email': email?.trim()  ??   null,
      'password': password?.trim() ?? null ,
    };
    return map;
  }
}

class RegisterRequestModel {
  String name;
  String email;
  String password;

  RegisterRequestModel({required this.name, required this.email, required this.password});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'name': email == null ? null : email.trim(),
      'email': email == null ? null : email.trim(),
      'password': password == null ? null : password.trim(),
    };
    return map;
  }
}
