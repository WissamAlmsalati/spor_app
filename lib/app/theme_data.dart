import 'dart:ui';

import 'package:sport/app/status_bar_color.dart';

import '../utilits/responsive.dart';
import 'app_packges.dart';

class CustomThemeData {
  static ThemeData getThemeData(BuildContext context) {
    // Set the system status bar and navigation bar color
    setStatusBarColor(Constants.backGroundColor);

    return ThemeData(

      appBarTheme: AppBarTheme(
        scrolledUnderElevation: 0,
        backgroundColor: Constants.backGroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontFamily: GoogleFonts.cairo().fontFamily,
        ),
      ),
      primaryColor: const Color(0xFF95CA5B),
      hintColor: Colors.grey,
      scaffoldBackgroundColor: Constants.backGroundColor,
      tabBarTheme: TabBarTheme(
        labelColor: Constants.mainColor,
        indicator: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Constants.mainColor,
              width: 3,
            ),
          ),
        ),
        unselectedLabelColor: Constants.thirdColor,
        labelStyle: GoogleFonts.cairo(color: Constants.mainColor),
        unselectedLabelStyle: GoogleFonts.cairo(color: Constants.thirdColor),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Constants.mainColor,
        unselectedItemColor: Constants.thirdColor,
        type: BottomNavigationBarType.fixed,
        elevation: 5,
      ),
      textTheme: TextTheme(
        bodyLarge: GoogleFonts.cairo(
          color: Colors.black,
        ),
        bodyMedium: GoogleFonts.cairo(
          color: Colors.black,
        ),
        displayLarge: GoogleFonts.cairo( // Formerly headline1
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        displayMedium: GoogleFonts.cairo( // Formerly headline2
          fontSize: 28.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        displaySmall: GoogleFonts.cairo( // Formerly headline3
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        headlineMedium: GoogleFonts.cairo( // Formerly headline4
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        headlineSmall: GoogleFonts.cairo( // Formerly headline5
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        titleLarge: GoogleFonts.cairo( // Formerly headline6
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),

      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.all(10),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          textStyle: WidgetStateProperty.all<TextStyle>(GoogleFonts.cairo()),
          backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
          foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
          shadowColor: WidgetStateProperty.all<Color>(Colors.black.withOpacity(0.5)),
          elevation: WidgetStateProperty.all<double>(0),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          padding: WidgetStateProperty.all<EdgeInsets>(
            EdgeInsets.symmetric(
                vertical: Responsive.screenHeight(context) * 0.01,
                horizontal: Responsive.screenWidth(context) * 0.032
            ),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.grey[200],
        filled: true,
        hintStyle: GoogleFonts.cairo(
          color: Colors.grey[400],
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        labelStyle: GoogleFonts.cairo(
          color: Colors.grey[600],
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        prefixIconColor: Colors.grey[400],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Constants.mainColor, width: 2.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[700]!),
        ),
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontSize: Responsive.textSize(context, 4.5),
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: TextStyle(
          fontSize: Responsive.textSize(context, 3.5),
          color: Constants.txtColor,
        ),
      ),
    );
  }

  static ThemeData getDarkThemeData(BuildContext context) {
    return ThemeData(
      primaryColor: const Color(0xFF95CA5B),
      hintColor: Colors.grey[600],
      scaffoldBackgroundColor: const Color(0xFF121212),
      tabBarTheme: TabBarTheme(
        labelColor: Constants.mainColor,
        indicator: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Constants.mainColor,
              width: 3,
            ),
          ),
        ),
        unselectedLabelColor: Colors.grey[400],
        labelStyle: GoogleFonts.cairo(color: Constants.mainColor),
        unselectedLabelStyle: GoogleFonts.cairo(color: Colors.grey[400]),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFF1F1F1F),
        selectedItemColor: Constants.mainColor,
        unselectedItemColor: Colors.grey[500],
        type: BottomNavigationBarType.fixed,
        elevation: 5,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          textStyle: WidgetStateProperty.all<TextStyle>(GoogleFonts.cairo()),
          backgroundColor: WidgetStateProperty.all<Color>(const Color(0xFF272829)),
          foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
          shadowColor: WidgetStateProperty.all<Color>(Colors.black.withOpacity(0.5)),
          elevation: WidgetStateProperty.all<double>(0),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          padding: WidgetStateProperty.all<EdgeInsets>(
            EdgeInsets.symmetric(
                vertical: Responsive.screenHeight(context) * 0.01,
                horizontal: Responsive.screenWidth(context) * 0.032
            ),
          ),
        ),
      ),textTheme: TextTheme(
    bodyLarge: GoogleFonts.cairo(
    color: Colors.black,
    ),
    bodyMedium: GoogleFonts.cairo(
    color: Colors.black,
    ),
      bodySmall: GoogleFonts.cairo(
      color: Colors.grey[600],
      fontWeight: FontWeight.w500,
      fontSize: 16,
    ),

      titleSmall: GoogleFonts.cairo(
      color: Colors.grey[600],
      fontWeight: FontWeight.w500,
      fontSize: 16,
    ),

    displayLarge: GoogleFonts.cairo( // Formerly headline1
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
    ),
    displayMedium: GoogleFonts.cairo( // Formerly headline2
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
    ),
    displaySmall: GoogleFonts.cairo( // Formerly headline3
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
    ),
    headlineMedium: GoogleFonts.cairo( // Formerly headline4
    fontSize: 22.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
    ),
    headlineSmall: GoogleFonts.cairo( // Formerly headline5
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: Colors.black,
    ),
    titleLarge: GoogleFonts.cairo( // Formerly headline6
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: Colors.black,
    ),
      titleMedium: GoogleFonts.cairo( // Formerly headline6
      fontSize: 8.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
      ),



    ),


      inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.grey[800],
        filled: true,
        hintStyle: TextStyle(
          color: Colors.grey[400],
          fontWeight: FontWeight.w500,
          fontFamily: GoogleFonts.cairo().fontFamily,
          fontSize: 16,
        ),
        prefixIconColor: Colors.grey[400],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[700]!, width: 0.01),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Constants.mainColor, width: 2.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[700]!),
        ),
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF272829),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.all(10),
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: const Color(0xFF1F1F1F),
        titleTextStyle: TextStyle(
          fontSize: Responsive.textSize(context, 4.5),
          fontWeight: FontWeight.bold,
        ),

        contentTextStyle: TextStyle(
          fontSize: Responsive.textSize(context, 3.5),
          color: Constants.txtColor,
        ),
      ),
    );
  }
}
