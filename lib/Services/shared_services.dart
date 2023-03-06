import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_tracker_mobile_demo/Screens/home.dart';
import 'package:task_tracker_mobile_demo/Screens/menu.dart';

class SharedServices extends StatefulWidget {
  const SharedServices({Key? key}) : super(key: key);

  @override
  State<SharedServices> createState() => _SharedServicesState();
}

class _SharedServicesState extends State<SharedServices> {
  late String finalEmail = '';

  Future getValidationData() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var obtainedData = sharedPreferences.getString('data');
    setState(() {
      if (obtainedData != null) {
        finalEmail = obtainedData;
      }
    });
  }

  @override
  void initState() {
    getValidationData().whenComplete(() async {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => finalEmail.isEmpty ? const MainMenu() : HomePage() ), (_) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: WillPopScope(
        onWillPop: () async => false,
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Color(0xFFE4EBF8),
            ),
            backgroundColor: Color(0xFF2E315A),
          ),
        ),
      ),
    );
  }
}
