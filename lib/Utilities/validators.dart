
import 'package:intl/intl.dart';

String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your name';
  }
  final nameRegExp = RegExp(r'^[a-zA-Z ]+$');
  if (!nameRegExp.hasMatch(value)) {
    return 'Please enter a valid name';
  }
  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your email address';
  }
  final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegExp.hasMatch(value)) {
    return 'Please enter a valid email address';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a password';
  }
  if (value.length < 6) {
    return 'Password must be at least 6 characters long';
  }
  if (!value.contains(RegExp(r'[A-Z]'))) {
    return 'Password must contain at least one uppercase letter';
  }
  if (!value.contains(RegExp(r'[a-z]'))) {
    return 'Password must contain at least one lowercase letter';
  }
  if (!value.contains(RegExp(r'[0-9]'))) {
    return 'Password must contain at least one number';
  }
  return null;
}

String? validateTitle(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a title';
  }
  if (value.length < 7) {
    return 'Title must be at least 7 characters long';
  }
  return null;
}

String? validateDescription(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a description';
  }
  if (value.length < 10) {
    return 'Description must be at least 10 characters long';
  }
  return null;
}

String? validateDate(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a date';
  }
  final dateFormat = DateFormat('MM-dd-yyyy');
  try {
    dateFormat.parseStrict(value);
  } catch (e) {
    return 'Please enter a valid date in the format MM-DD-YYYY';
  }
  return null;
}

String? validateTime(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a time';
  }
  final timeFormat = DateFormat('HH:mm');
  try {
    timeFormat.parseStrict(value);
  } catch (e) {
    return 'Please enter a valid time in the 24-hour format HH:MM';
  }
  return null;
}
