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
    var tasksJson = json['tasks'] as List<dynamic>?;

    List<Task> tasks = tasksJson != null ? List<Task>.from(tasksJson.map((taskJson) => Task.fromJson(taskJson))) : [];

    String error = json['error'] ?? '';
    String message = json['message'] ?? '';

    return TaskResponseModel(
      tasks: tasks,
      error: error,
      message: message,
    );
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

class TaskCreateRequestModel  {
  String userID;
  String token;
  String title;
  String description;
  String dueDate;
  String? startTime;
  String? endTime;
  bool? prioritize;

  TaskCreateRequestModel({
    required this.userID,
    required this.token,
    required this.title,
    required this.description,
    required this.dueDate,
    this.startTime,
    this.endTime,
    this.prioritize,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'user_id': userID.trim() ?? null,
      'token': token.trim() ?? null,
      "title": title?.trim() ?? null,
      "description": description?.trim() ?? null,
      "dueDate": dueDate,
      "startTime": startTime?.trim() ?? null,
      "endTime": endTime?.trim() ?? null,
      "prioritize": prioritize,
    };
    return map;
  }
}

class TaskGetAllRequestModel {
  String userID;
  String token;
  String params;

  TaskGetAllRequestModel({
    required this.userID,
    required this.token,
    required this.params,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'user_id': userID.trim() ?? null,
      'token': token.trim() ?? null,
      'params': params.trim() ?? null,
    };
    return map;
  }
}
class TaskDeleteRequestModel {
  String userID;
  String taskID;
  String token;

  TaskDeleteRequestModel({
    required this.userID,
    required this.taskID,
    required this.token,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'user_id': userID.trim() ?? null,
      'token': taskID.trim() ?? null,
      'params': token.trim() ?? null,
    };
    return map;
  }
}

class TaskUpdateRequestModel {
  String userID;
  String taskID;
  String token;

  String? title;
  String? description;
  DateTime? dueDate;

  String? startTime;
  String? endTime;

  bool? prioritize;
  String? status;

  TaskUpdateRequestModel({
    required this.userID,
    required this.taskID,
    required this.token,
    this.title,
    this.description,
    this.dueDate,
    this.startTime,
    this.endTime,
    this.prioritize,
    this.status,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'user_id': userID.trim() ?? null,
      'task_id': taskID.trim() ?? null,
      'token': token.trim() ?? null,
      "title": title?.trim() ?? null,
      "description": description?.trim() ?? null,
      "dueDate": dueDate,
      "startTime": startTime?.trim() ?? null,
      "endTime": endTime?.trim() ?? null,
      "prioritize": prioritize,
      "status": status,
    };
    return map;
  }
}
