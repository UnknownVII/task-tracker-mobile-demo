import 'package:flutter/material.dart';

final ButtonStyle elevatedBtnFilled = ElevatedButton.styleFrom(
  foregroundColor: Color(0xFF021632),
  backgroundColor: Color(0xFF21e6c1),
  minimumSize: Size(200, 50),
  padding: EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(5)),
  ),
  elevation: 0.0,
  shadowColor: Colors.transparent,
);

final ButtonStyle elevatedBtnHollow= ElevatedButton.styleFrom(
  side: const BorderSide(
    width: 2,
    color: Color(0xFF21e6c1),
  ),
  foregroundColor: Color(0xFFE4EBF8),
  backgroundColor: Colors.transparent,
  minimumSize: Size(200, 50),
  padding: EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(5)),
  ),
  elevation: 0.0,
  shadowColor: Colors.transparent,
);

final TextStyle btnTextStyleDark = TextStyle(
  color: Color(0xFF021632),
  fontSize: 14,
  fontWeight: FontWeight.w700,
);

final TextStyle btnTextStyleWhite = TextStyle(
  color: Color(0xFFE4EBF8),
  fontSize: 14,
  fontWeight: FontWeight.w700,
);
