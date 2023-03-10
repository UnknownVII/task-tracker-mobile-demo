import 'package:shared_preferences/shared_preferences.dart';

import '../Models/task_model.dart';
import '../Services/task_services.dart';

late List<Task> tasks;
late TaskGetAllRequestModel taskGetAllRequestModel = new TaskGetAllRequestModel(userID: '', token: '' , params: '');
late TaskGetSpecificRequestModel taskGetSpecificRequestModel = new TaskGetSpecificRequestModel(userID: '',taskID: '', token: '');
late TaskUpdateRequestModel taskUpdateRequestModel = new TaskUpdateRequestModel(userID: '', taskID: '', prioritize: false, token: '');
late TaskUpdateRequestModel taskUpdateSpecificRequestModel = new TaskUpdateRequestModel(userID: '', taskID: '', token: '', title: '', description: '', dueDate: '1199-01-01', prioritize: false, endTime: null, startTime: null, );

late TaskDeleteRequestModel taskDeleteRequestModel = new TaskDeleteRequestModel(userID: '', taskID: '', token: '');
late TaskCreateRequestModel taskCreateRequestModel = new TaskCreateRequestModel(userID: '', token: '', title: '', description: '', dueDate: '1199-01-01', prioritize: false, endTime: null, startTime: null);


Future getUserData(String params) async {
  List<dynamic> value = [];
  TaskService taskService = new TaskService();
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  var userID = sharedPreferences.getString('userID');
  var authKey = sharedPreferences.getString('authKey');

  taskGetAllRequestModel.userID = userID!;
  taskGetAllRequestModel.token = authKey!;
  taskGetAllRequestModel.params = params;

  await taskService.getAll(taskGetAllRequestModel).then(
    (_userData) {
      if (_userData.tasks.isNotEmpty) {
        value.addAll(_userData.tasks);
        tasks = _userData.tasks;
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

Future getSpecificData(String taskID) async {
  List<dynamic> value = [];
  TaskService taskService = new TaskService();
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  var userID = sharedPreferences.getString('userID');
  var authKey = sharedPreferences.getString('authKey');

  taskGetSpecificRequestModel.userID = userID!;
  taskGetSpecificRequestModel.taskID = taskID!;
  taskGetSpecificRequestModel.token = authKey!;

  await taskService.getSpecific(taskGetSpecificRequestModel).then(
        (_userData) {
      if (_userData.tasks.isNotEmpty) {
        value.addAll(_userData.tasks);
        tasks = _userData.tasks;
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

Future deleteTaskStatus(String taskID) async {
  List<dynamic> value = [];
  TaskService taskService = new TaskService();
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  var userID = sharedPreferences.getString('userID');
  var authKey = sharedPreferences.getString('authKey');

  taskDeleteRequestModel.userID = userID!;
  taskDeleteRequestModel.taskID = taskID;
  taskDeleteRequestModel.token = authKey!;

  await taskService.deleteTask(taskDeleteRequestModel).then(
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

Future createTask(String title, String description, String dueDate, String startTime, String endTime, bool prioritize) async {
  List<dynamic> value = [];
  TaskService taskService = new TaskService();
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  var userID = sharedPreferences.getString('userID');
  var authKey = sharedPreferences.getString('authKey');

  taskCreateRequestModel.userID = userID!;
  taskCreateRequestModel.token = authKey!;

  taskCreateRequestModel.title = title;
  taskCreateRequestModel.description = description;
  taskCreateRequestModel.dueDate = dueDate;
  taskCreateRequestModel.startTime = startTime;
  taskCreateRequestModel.endTime = endTime;
  taskCreateRequestModel.prioritize = prioritize;

  await taskService.createTask(taskCreateRequestModel).then(
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

Future updateSpecificTask(String title,String taskID, String description, String dueDate, String startTime, String endTime, bool prioritize) async {
  List<dynamic> value = [];
  TaskService taskService = new TaskService();
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  var userID = sharedPreferences.getString('userID');
  var authKey = sharedPreferences.getString('authKey');

  taskUpdateSpecificRequestModel.userID = userID!;
  taskUpdateSpecificRequestModel.taskID = taskID!;
  taskUpdateSpecificRequestModel.token = authKey!;

  taskUpdateSpecificRequestModel.title = title;
  taskUpdateSpecificRequestModel.description = description;
  taskUpdateSpecificRequestModel.dueDate = dueDate;
  taskUpdateSpecificRequestModel.startTime = startTime;
  taskUpdateSpecificRequestModel.endTime = endTime;
  taskUpdateSpecificRequestModel.prioritize = prioritize;

  await taskService.updateBody(taskUpdateSpecificRequestModel).then(
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

Future updateTaskStatus(String taskID, String status) async {
  List<dynamic> value = [];
  TaskService taskService = new TaskService();
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  var userID = sharedPreferences.getString('userID');
  var authKey = sharedPreferences.getString('authKey');

  taskUpdateRequestModel.userID = userID!;
  taskUpdateRequestModel.taskID = taskID;
  taskUpdateRequestModel.status = status;
  taskUpdateRequestModel.token = authKey!;

  await taskService.updateCompleted(taskUpdateRequestModel).then(
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

Future updateTaskPriority(String taskID, bool priority) async {
  List<dynamic> value = [];
  TaskService taskService = new TaskService();
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  var userID = sharedPreferences.getString('userID');
  var authKey = sharedPreferences.getString('authKey');

  taskUpdateRequestModel.userID = userID!;
  taskUpdateRequestModel.taskID = taskID;
  taskUpdateRequestModel.prioritize = priority;
  taskUpdateRequestModel.token = authKey!;

  await taskService.updatePrioritized(taskUpdateRequestModel).then(
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