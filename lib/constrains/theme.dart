import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';

final themeLight = ThemeData.light().copyWith(
  brightness: Brightness.light,
  primaryColor: Colors.lightBlue[800],
  scaffoldBackgroundColor: Colors.white,
  // Define the default font family.
  // fontFamily: 'Ubuntu',
  // Define the default `TextTheme`. Use this to specify the default
  // text styling for headlines, titles, bodies of text, and more.
  textTheme: TextTheme(
    displayLarge: GoogleFonts.ubuntu(
      fontSize: 72.0,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: GoogleFonts.ubuntu(
      fontSize: 36.0,
      fontStyle: FontStyle.italic,
    ),
    bodyMedium: GoogleFonts.ubuntu(
      fontSize: 14.0,
      color: Colors.black,
    ),
    bodySmall:
        GoogleFonts.ubuntu(fontSize: 14.0, color: Colors.grey.withOpacity(.75)),
    headlineMedium: GoogleFonts.ubuntu(
        fontSize: 38.0,
        color: Colors.black.withOpacity(0.65),
        fontWeight: FontWeight.bold),
    labelLarge: GoogleFonts.ubuntu(
      fontSize: 18.0,
      color: Colors.black,
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      textStyle: MaterialStateProperty.resolveWith((states) {
        return GoogleFonts.ubuntu(
          fontSize: 15.0,
          color: Colors.black,
        );
      }),
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        // If the button is pressed, return green, otherwise blue
        if (states.contains(MaterialState.pressed)) {
          return const Color(0xFFFEC107);
        }
        return const Color(0xFFFEC107);
      }),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
  ),
);

final themeDark = ThemeData.dark().copyWith(
  // Define the default brightness and colors.
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  // backgroundColor: Colors.red,
  // Define the default font family.
  // fontFamily: 'Ubuntu',
  // Define the default `TextTheme`. Use this to specify the default
  // text styling for headlines, titles, bodies of text, and more.
  textTheme: TextTheme(
    displayLarge: GoogleFonts.ubuntu(
      fontSize: 72.0,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: GoogleFonts.ubuntu(
      fontSize: 36.0,
      fontStyle: FontStyle.italic,
    ),
    bodyMedium: GoogleFonts.ubuntu(
      fontSize: 14.0,
      color: Colors.white,
    ),
    headlineMedium: GoogleFonts.ubuntu(
        fontSize: 38.0,
        color: Colors.white.withOpacity(0.65),
        fontWeight: FontWeight.bold),
    labelLarge: GoogleFonts.ubuntu(
      fontSize: 18.0,
      color: Colors.white,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      textStyle: MaterialStateProperty.resolveWith((states) {
        return GoogleFonts.ubuntu(
          fontSize: 15.0,
          color: Colors.white,
        );
      }),
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        // If the button is pressed, return green, otherwise blue
        if (states.contains(MaterialState.pressed)) {
          return const Color(0xFFFEC107);
        }
        return const Color(0xFFFEC107);
        // return Colors.red;
      }),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
  ),
);
