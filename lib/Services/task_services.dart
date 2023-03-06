import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import '../Models/task_model.dart';

class TaskService {
  var client = http.Client();

  Future<TaskResponseModel> getAll(TaskRequestModel taskRequestModel) async {
    String userID = taskRequestModel.userID.toString();
    String token = taskRequestModel.token.toString();
    var authHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'auth-token': token.toString(),
    };

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return TaskResponseModel.fromJson({"error": "No internet connection"});
    }

    try {
      final response = await client.get(Uri.parse('https://task-tracker-mobile-api.vercel.app/task/get/' + userID + "/all-tasks"), headers: authHeaders).timeout(Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 400 || response.statusCode == 404 || response.statusCode == 500) {
        String jsonDataString = response.body.toString().replaceAll("\n", "");
        var _data = jsonDecode(jsonDataString);
        return TaskResponseModel.fromJson(_data);
      } else {
        return TaskResponseModel.fromJson({"error": "Failed to load Data"});
      }
    } on TimeoutException {
      return TaskResponseModel.fromJson({"error": "Connection Timed out. Please Try again"});
    } catch (error) {
      return TaskResponseModel.fromJson({"error": error.toString()});
    }
  }
}
