import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:task_tracker_mobile_demo/Styles/button-styles.dart';

import 'Menu/login.dart';
import 'Menu/register.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> with TickerProviderStateMixin {
  late DateTime currentBackPressTime;
  late Image imageLogo;
  late final _controllerAnimation;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controllerAnimation = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_controllerAnimation);
    imageLogo = Image.asset(
      'assets/app_splash_foreground.png',
      height: 150.0,
      width: 150.0,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controllerAnimation.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime? lastPressed;
    _controllerAnimation.forward();
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: WillPopScope(
        onWillPop: () async {
          final now = DateTime.now();
          final maxDuration = const Duration(seconds: 1);
          final isWarning = lastPressed == null || now.difference(lastPressed!) > maxDuration;
          if (isWarning) {
            lastPressed = DateTime.now();
            Fluttertoast.showToast(msg: "Double Tap to Close App", backgroundColor: Color(0xFF071E3D), textColor: Color(0xFFE4EBF8), toastLength: Toast.LENGTH_SHORT);
            return false;
          } else {
            Fluttertoast.cancel();
            return true;
          }
        },
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                FadeTransition(
                  opacity: _animation,
                  child: imageLogo,
                ),
                SizedBox(height: 51.86),
                FadeTransition(
                  opacity: _animation,
                  child: Container(
                    child: Column(
                      children: [
                        ElevatedButton(
                            style: elevatedBtnFilled,
                            onPressed: (() => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const Login()),
                                  )
                                }),
                            child: Text(style: btnTextStyleDark, 'Login')),
                        SizedBox(height: 25),
                        ElevatedButton(
                            style: elevatedBtnHollow,
                            onPressed: (() => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const RegisterAccount()),
                                  )
                                }),
                            child: Text(style: btnTextStyleWhite, 'Create Account'))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
