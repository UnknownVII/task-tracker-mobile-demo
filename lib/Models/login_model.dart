class UserResponseModel {
  UserResponseModel({
    required this.user_data,
    required this.error,
    required this.message,
  });

  List<UserData> user_data;
  String error;
  String message;

  factory UserResponseModel.fromJson(Map<String, dynamic> json) {
    var userDataJson = json['user_data'];

    List<UserData> user_data = [];
    if (userDataJson is List) {
      user_data = List<UserData>.from(
          userDataJson.map((userDataJson) => UserData.fromJson(userDataJson)));
    } else if (userDataJson is Map<String, dynamic>) {
      user_data = [UserData.fromJson(userDataJson)];
    }

    String error = json['error'] ?? '';
    String message = json['message'] ?? '';

    return UserResponseModel(
      user_data: user_data,
      error: error,
      message: message,
    );
  }
}
class UserData {
  UserData({
    required this.name,
    required this.email,
    required this.date,
    required this.taskCount
  });

  String name;
  String email;
  String date;
  int taskCount;

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json["name"] ?? '',
      email: json["email"] ?? '',
      date: json["date"] ?? '',
      taskCount: json["taskCount"] ?? '',
    );
  }
}

class UseRequestModel {
  String userID;
  String token;

  UseRequestModel({
    required this.userID,
    required this.token,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'user_id': userID.trim() ?? null,
      'token': token.trim() ?? null,
    };
    return map;
  }
}

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



