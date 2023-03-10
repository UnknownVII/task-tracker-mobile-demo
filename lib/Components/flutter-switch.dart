import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class flutterSwitch extends StatelessWidget {
  late final bool values;
  final void Function(bool) onToggle;

  flutterSwitch({Key? key, required this.values, required this.onToggle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterSwitch(
        width: 60.0,
        height: 30,
        valueFontSize: 18.0,
        toggleSize: 32.0,
        value: values,
        borderRadius: 30.0,
        padding: 2.5,
        showOnOff: false,
        inactiveColor: Colors.transparent,
        inactiveSwitchBorder: Border.all(color: Color(0xFFE4EBF8), width: 2, strokeAlign: StrokeAlign.outside),
        activeColor: Colors.transparent,
        activeSwitchBorder: Border.all(color: Color(0xFF21E6C1), width: 2, strokeAlign: StrokeAlign.outside),
        activeToggleColor: Color(0xFF21E6C1),
        activeTextColor: Color(0x80000000),
        onToggle: onToggle,
    );
  }
}
