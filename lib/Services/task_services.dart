import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import '../Models/task_model.dart';

class TaskService {
  var client = http.Client();

  Future<TaskResponseModel> getAll(
      TaskGetAllRequestModel taskRequestModel) async {
    String userID = taskRequestModel.userID.toString();
    String token = taskRequestModel.token.toString();
    String params = taskRequestModel.params.toString();

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
      final response = await client
          .get(
              Uri.parse('https://task-tracker-mobile-api.vercel.app/task/get/' +
                  userID +
                  "/all-tasks?" +
                  params),
              headers: authHeaders)
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200 ||
          response.statusCode == 400 ||
          response.statusCode == 404 ||
          response.statusCode == 500) {
        String jsonDataString = response.body.toString().replaceAll("\n", "");
        var _data = jsonDecode(jsonDataString);
        print(_data);
        return TaskResponseModel.fromJson(_data);
      } else {
        return TaskResponseModel.fromJson({"error": "Failed to load Data"});
      }
    } on TimeoutException {
      return TaskResponseModel.fromJson(
          {"error": "Connection Timed out. Please Try again"});
    } catch (error) {
      return TaskResponseModel.fromJson({"error": error.toString()});
    }
  }

  Future<TaskResponseModel> getSpecific(
      TaskGetSpecificRequestModel taskGetSpecificRequestModel) async {
    String userID = taskGetSpecificRequestModel.userID.toString();
    String taskID = taskGetSpecificRequestModel.taskID.toString();
    String token = taskGetSpecificRequestModel.token.toString();

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
      final response = await client
          .get(
              Uri.parse('https://task-tracker-mobile-api.vercel.app/task/get/' +
                  userID +
                  "/user-task/" +
                  taskID),
              headers: authHeaders)
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200 ||
          response.statusCode == 400 ||
          response.statusCode == 404 ||
          response.statusCode == 500) {
        String jsonDataString = response.body.toString().replaceAll("\n", "");
        var _data = jsonDecode('{"tasks": [$jsonDataString]}');
        return TaskResponseModel.fromJson(_data);
      } else {
        return TaskResponseModel.fromJson({"error": "Failed to load Data"});
      }
    } on TimeoutException {
      return TaskResponseModel.fromJson(
          {"error": "Connection Timed out. Please Try again"});
    } catch (error) {
      return TaskResponseModel.fromJson({"error": error.toString()});
    }
  }

  Future<TaskResponseModel> createTask(
      TaskCreateRequestModel TaskCreateRequestModel) async {
    String userID = TaskCreateRequestModel.userID.toString();
    String token = TaskCreateRequestModel.token.toString();

    String title = TaskCreateRequestModel.title.toString();
    String description = TaskCreateRequestModel.description.toString();
    String dueDate = TaskCreateRequestModel.dueDate.toString();
    String? startTime = TaskCreateRequestModel.startTime.toString();
    String? endTime = TaskCreateRequestModel.endTime.toString();
    String? prioritize = TaskCreateRequestModel.prioritize.toString();

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
      final response = await client
          .post(
              Uri.parse(
                  'https://task-tracker-mobile-api.vercel.app/task/create/' +
                      userID +
                      "/new-task"),
              headers: authHeaders,
              body: jsonEncode(
                <String, dynamic>{
                  "title": title,
                  "description": description,
                  "due_date": dueDate,
                  "start_time": startTime,
                  "end_time": endTime,
                  "prioritize": prioritize
                },
              ))
          .timeout(Duration(seconds: 10));
      if (response.statusCode == 200 ||
          response.statusCode == 400 ||
          response.statusCode == 404 ||
          response.statusCode == 500) {
        String jsonDataString = response.body.toString().replaceAll("\n", "");
        var _data = jsonDecode(jsonDataString);
        return TaskResponseModel.fromJson(_data);
      } else {
        return TaskResponseModel.fromJson({"error": "Failed to load Data"});
      }
    } on TimeoutException {
      return TaskResponseModel.fromJson(
          {"error": "Connection Timed out. Please Try again"});
    } catch (error) {
      return TaskResponseModel.fromJson({"error": error.toString()});
    }
  }

  Future<TaskResponseModel> updateCompleted(
      TaskUpdateRequestModel taskUpdateRequestModel) async {
    String userID = taskUpdateRequestModel.userID.toString();
    String taskID = taskUpdateRequestModel.taskID.toString();
    String token = taskUpdateRequestModel.token.toString();
    String status = taskUpdateRequestModel.status.toString();

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
      final response = await client
          .patch(
              Uri.parse(
                  'https://task-tracker-mobile-api.vercel.app/task/update/' +
                      userID +
                      "/user-task/" +
                      taskID),
              headers: authHeaders,
              body: jsonEncode(
                <String, dynamic>{
                  'status': status,
                },
              ))
          .timeout(Duration(seconds: 10));
      if (response.statusCode == 200 ||
          response.statusCode == 400 ||
          response.statusCode == 404 ||
          response.statusCode == 500) {
        String jsonDataString = response.body.toString().replaceAll("\n", "");
        var _data = jsonDecode(jsonDataString);
        return TaskResponseModel.fromJson(_data);
      } else {
        return TaskResponseModel.fromJson({"error": "Failed to load Data"});
      }
    } on TimeoutException {
      return TaskResponseModel.fromJson(
          {"error": "Connection Timed out. Please Try again"});
    } catch (error) {
      return TaskResponseModel.fromJson({"error": error.toString()});
    }
  }

  Future<TaskResponseModel> updatePrioritized(
      TaskUpdateRequestModel taskUpdateRequestModel) async {
    String userID = taskUpdateRequestModel.userID.toString();
    String taskID = taskUpdateRequestModel.taskID.toString();
    String token = taskUpdateRequestModel.token.toString();

    bool? prioritize = taskUpdateRequestModel.prioritize;

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
      final response = await client
          .patch(
              Uri.parse(
                  'https://task-tracker-mobile-api.vercel.app/task/update/' +
                      userID +
                      "/user-task/" +
                      taskID),
              headers: authHeaders,
              body: jsonEncode(
                <String, dynamic>{
                  'prioritize': prioritize,
                },
              ))
          .timeout(Duration(seconds: 10));
      if (response.statusCode == 200 ||
          response.statusCode == 400 ||
          response.statusCode == 404 ||
          response.statusCode == 500) {
        String jsonDataString = response.body.toString().replaceAll("\n", "");
        var _data = jsonDecode(jsonDataString);
        return TaskResponseModel.fromJson(_data);
      } else {
        return TaskResponseModel.fromJson({"error": "Failed to load Data"});
      }
    } on TimeoutException {
      return TaskResponseModel.fromJson(
          {"error": "Connection Timed out. Please Try again"});
    } catch (error) {
      return TaskResponseModel.fromJson({"error": error.toString()});
    }
  }

  Future<TaskResponseModel> updateBody(
      TaskUpdateRequestModel taskUpdateRequestModel) async {
    String userID = taskUpdateRequestModel.userID.toString();
    String taskID = taskUpdateRequestModel.taskID.toString();
    String token = taskUpdateRequestModel.token.toString();

    String title = taskUpdateRequestModel.title.toString();
    String description = taskUpdateRequestModel.description.toString();
    String dueDate = taskUpdateRequestModel.dueDate.toString();
    String? startTime = taskUpdateRequestModel.startTime.toString();
    String? endTime = taskUpdateRequestModel.endTime.toString();
    String? prioritize = taskUpdateRequestModel.prioritize.toString();

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
      final response = await client
          .patch(
              Uri.parse(
                  'https://task-tracker-mobile-api.vercel.app/task/update/' +
                      userID +
                      "/user-task/" +
                      taskID),
              headers: authHeaders,
              body: jsonEncode(
                <String, dynamic>{
                  'title': title,
                  'description': description,
                  'due_date': dueDate,
                  'start_time': startTime,
                  'end_time': endTime,
                  'prioritize': prioritize
                },
              ))
          .timeout(Duration(seconds: 10));
      if (response.statusCode == 200 ||
          response.statusCode == 400 ||
          response.statusCode == 404 ||
          response.statusCode == 500) {
        String jsonDataString = response.body.toString().replaceAll("\n", "");
        var _data = jsonDecode(jsonDataString);
print(_data);
        return TaskResponseModel.fromJson(_data);
      } else {
        return TaskResponseModel.fromJson({"error": "Failed to load Data"});
      }
    } on TimeoutException {
      return TaskResponseModel.fromJson(
          {"error": "Connection Timed out. Please Try again"});
    } catch (error) {
      return TaskResponseModel.fromJson({"error": error.toString()});
    }
  }

  Future<TaskResponseModel> deleteTask(
      TaskDeleteRequestModel taskDeleteRequestModel) async {
    String userID = taskDeleteRequestModel.userID.toString();
    String taskID = taskDeleteRequestModel.taskID.toString();
    String token = taskDeleteRequestModel.token.toString();

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
      final response = await client
          .delete(
            Uri.parse(
                'https://task-tracker-mobile-api.vercel.app/task/delete/' +
                    userID +
                    "/user-task/" +
                    taskID),
            headers: authHeaders,
          )
          .timeout(Duration(seconds: 10));
      if (response.statusCode == 200 ||
          response.statusCode == 400 ||
          response.statusCode == 404 ||
          response.statusCode == 500) {
        String jsonDataString = response.body.toString().replaceAll("\n", "");
        var _data = jsonDecode(jsonDataString);
        return TaskResponseModel.fromJson(_data);
      } else {
        return TaskResponseModel.fromJson({"error": "Failed to load Data"});
      }
    } on TimeoutException {
      return TaskResponseModel.fromJson(
          {"error": "Connection Timed out. Please Try again"});
    } catch (error) {
      return TaskResponseModel.fromJson({"error": error.toString()});
    }
  }
}
