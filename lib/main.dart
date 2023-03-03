import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_tracker_mobile_demo/Screens/home.dart';
import 'package:task_tracker_mobile_demo/Screens/menu.dart';
import 'package:task_tracker_mobile_demo/Services/shared_services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const MaterialColor _darkBlueSwatch = MaterialColor(
      0xFF021632,
      <int, Color>{
        50: Color(0xFFe1e3e6),
        100: Color(0xFFb3b9c2),
        200: Color(0xFF818b99),
        300: Color(0xFF4e5c70),
        400: Color(0xFF283951),
        500: Color(0xFF021632),
        600: Color(0xFF02132d),
        700: Color(0xFF011026),
        800: Color(0xFF010c1f),
        900: Color(0xFF010613),
      },
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Tracker',
      theme: ThemeData(
        textTheme: GoogleFonts.robotoTextTheme(),
        primarySwatch: _darkBlueSwatch,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color(0xFF021632),
          selectionHandleColor: Color(0xFF21E6C1),
        ),
      ),
      home: SharedServices(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => const HomePage(),
        '/menu': (BuildContext context) => const MainMenu(),
      },
    );
  }
}
