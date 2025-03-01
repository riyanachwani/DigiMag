import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// **Theme Model for Managing Theme State**
class ThemeModel extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.system; // 🔄 Default: System theme

  ThemeMode get mode => _mode;

  /// **Toggle Theme with `setState` Trick**
  void toggleTheme() {
    _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners(); // 🔄 Force rebuild on theme change
  }
}

/// **Light and Dark Themes for the App**
class MyTheme {
  static ThemeData lightTheme(BuildContext context) => ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: GoogleFonts.arOneSans().fontFamily,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5), // 🔄 Light background
        drawerTheme: const DrawerThemeData(
          backgroundColor: Colors.white,
        ),
        textTheme: TextTheme(
          titleLarge: const TextStyle(
              color: Colors.black), // 🔄 Text color for light mode
          bodyMedium: const TextStyle(
              color: Colors.black87), // 🔄 Text color for light mode
        ),
        appBarTheme: const AppBarTheme(
          color: Color.fromARGB(125, 209, 191, 239),
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
          foregroundColor: Colors.black,
        ),
      );

  static ThemeData darkTheme(BuildContext context) => ThemeData(
        brightness: Brightness.dark,
        fontFamily: GoogleFonts.arOneSans().fontFamily,
        scaffoldBackgroundColor: Colors.black,
        drawerTheme: const DrawerThemeData(
          backgroundColor: Colors.black,
        ),
        textTheme: const TextTheme(
          titleLarge:
              TextStyle(color: Colors.white), // 🔄 Text color for dark mode
          bodyMedium:
              TextStyle(color: Colors.white70), // 🔄 Text color for dark mode
        ),
        appBarTheme: const AppBarTheme(
          color: Colors.black,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.white),
          foregroundColor: Colors.white,
        ),
      );
}
