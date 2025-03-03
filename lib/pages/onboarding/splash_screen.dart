import 'package:digimag/main.dart';
import 'package:digimag/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3)); // Simulate loading time

    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (mounted) {
      Navigator.pushReplacementNamed(
        context,
        isLoggedIn ? MyRoutes.dashboardRoute : MyRoutes.landingRoute,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    
    return Scaffold(
backgroundColor:
          themeModel.mode == ThemeMode.light ? Colors.white : Colors.black,
            body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/applogo.png", // Same logo file
              width: 300,
              height: 300,
              color: themeModel.mode == ThemeMode.light
                  ? Colors.black
                  : Colors.white, // 🟢 Tint logo based on theme
              colorBlendMode: BlendMode.srcIn, // Apply color tint
            ),
          ],
        ),
      ),
    );
  }
}
