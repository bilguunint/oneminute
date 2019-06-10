import 'dart:ui';

import 'package:flutter/cupertino.dart';

class Colors {

  const Colors();

  static const Color loginGradientStart = const Color(0xFF59499E);
  static const Color loginGradientEnd = const Color(0xFF59499E);
  static const Color mainColor = const Color(0xFFF71634);
  static const Color successGreen =const Color(0xFF32CD32);
  static const Color secondaryColor = const Color(0xFFF75454);
  static const Color thirdColor = const Color(0xFFFFD684);
  static const Color fourthColor = const Color(0xFF8FDCFF);
  static const Color elementBack = const Color(0xfff1efef);
  static const Color titleBlack = const Color(0xFF242424);
  static const Color textMain = const Color(0xFF848484);
  static const Color greyBack = const Color(0xFFced4db); 
  static const Color grey = const Color(0xFFb0b0b0);
  static const Color red = const Color(0xFFff4d4d); 
  static const Color orange = const Color(0xFFff6348);
  static const Color strongGrey = const Color(0xFFced4db);
  static const primaryGradient = const LinearGradient(
    colors: const [mainColor, mainColor],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
