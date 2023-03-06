import 'package:flutter/cupertino.dart';

class TaskResponseModel {
  TaskResponseModel({
    required this.tasks,
    required this.error,
    required this.message,
  });

  List<Task> tasks;
  String error;
  String message;

  factory TaskResponseModel.fromJson(Map<String, dynamic> json) {
    print(json['tasks'].length);
    return TaskResponseModel(tasks: List<Task>.from(json['tasks'].map((x) => Task.fromJson(x))), error: json['error'], message: json['message']);
  }
}

class Task {
  Task({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.startTime,
    required this.endTime,
    required this.prioritize,
    required this.status,
    this.dateTimeFinished,
    required this.id,
    required this.dateCreated,
  });

  String title;
  String description;
  DateTime dueDate;
  String startTime;
  String endTime;
  bool prioritize;
  String status;
  dynamic dateTimeFinished;
  String id;
  DateTime dateCreated;

  factory Task.fromJson(Map<String, dynamic> json) {
    print(json["_id"] );
    return Task(
      title: json["title"] ?? '',
      description: json["description"] ?? '',
      dueDate: DateTime.parse(json["due_date"] ?? ''),
      startTime: json["start_time"] ?? '',
      endTime: json["end_time"] ?? '',
      prioritize: json["prioritize"] ?? '',
      status: json["status"] ?? '',
      dateTimeFinished: json["date_time_finished"] ?? '',
      id: json["_id"] ?? '',
      dateCreated: DateTime.parse(json["date_created"] ?? ''),
    );
  }
}

class TaskRequestModel {
  String userID;
  String token;

  TaskRequestModel({required this.userID, required this.token});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'user_id': userID.trim() ?? null,
      'token': token.trim() ?? null,
    };
    return map;
  }
}
