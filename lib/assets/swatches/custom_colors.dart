import 'package:flutter/material.dart';

class Swatch {
  static const MaterialColor prime = MaterialColor(_primePrimaryValue, <int, Color>{
     50: Color(0xFFFFF7E0),
    100: Color(0xFFFFECB3),
    200: Color(0xFFFFDF80),
    300: Color(0xFFFFD24D),
    400: Color(0xFFFFC926),
    500: Color(_primePrimaryValue),
    600: Color(0xFFFFB900),
    700: Color(0xFFFFB100),
    800: Color(0xFFFFA900),
    900: Color(0xFFFF9B00),
  });
  static const int _primePrimaryValue = 0xFFFFBF00;

  static const MaterialColor buttons = MaterialColor(_buttonsPrimaryValue, <int, Color>{
     50: Color(0xFFE8E7E5),
    100: Color(0xFFC6C4BE),
    200: Color(0xFFA09D93),
    300: Color(0xFF797568),
    400: Color(0xFF5D5847),
    500: Color(_buttonsPrimaryValue),
    600: Color(0xFF3A3423),
    700: Color(0xFF322C1D),
    800: Color(0xFF2A2517),
    900: Color(0xFF1C180E),
  });
  static const int _buttonsPrimaryValue = 0xFF403A27;

  static const MaterialColor buttonsAccent = MaterialColor(_buttonsAccentValue, <int, Color>{
    100: Color(0xFFFFD35E),
    200: Color(_buttonsAccentValue),
    400: Color(0xFFF7B400),
    700: Color(0xFFDEA100),
  });
  static const int _buttonsAccentValue = 0xFFFFC52B;
}

class SigCol {
  static const Color  green = Color(0xFF04EE51);
  static const Color    red = Color(0xFFFF0000);
  static const Color orange = Color(0xFFFFC400);
}

