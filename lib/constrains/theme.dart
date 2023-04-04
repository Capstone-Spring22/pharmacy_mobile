import 'package:flutter_neumorphic/flutter_neumorphic.dart';

final themeLight = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  primaryColor: const Color(0xFF82aae3),
  // buttonTheme: const ButtonThemeData(
  //   buttonColor: Color(0xFF82aae3),
  // ),
);

final themeDark = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
);

//Product Tile
const TextStyle tileTitle = TextStyle(
  fontSize: 16,
);
const TextStyle tilePrice = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
);

//Detail Page
const TextStyle detailPrice = TextStyle(
  fontSize: 25,
  fontWeight: FontWeight.bold,
);
