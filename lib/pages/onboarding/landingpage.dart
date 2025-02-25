import 'dart:ui';
import 'package:digimag/main.dart';
import 'package:digimag/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:digimag/utils/responsive.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
    if (_isLoggedIn) {
      Navigator.pushReplacementNamed(context, MyRoutes.dashboardRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final themeModel = Provider.of<ThemeModel>(context);
    bool isMobile = Responsive.isMobile(context); // Check screen type

    return Scaffold(
      backgroundColor:
          themeModel.mode == ThemeMode.light ? Colors.white : Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "DigiMag",
          style: TextStyle(fontFamily: 'RosebayRegular'),
        ),
        actions: [
          IconButton(
            onPressed: () {
              themeModel.toggleTheme();
            },
            icon: Icon(
              themeModel.mode == ThemeMode.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: isMobile
            ? _mobileLayout(size, themeModel.mode)
            : _webLayout(size, themeModel.mode),
      ),
    );
  }

  /// **Mobile Layout (Stacked)**
  Widget _mobileLayout(Size size, ThemeMode mode) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _imageContainer(size, 0.53), // Image on top
          _contentContainer(size, mode), // Welcome text & buttons
        ],
      ),
    );
  }

  /// **Web Layout (Split)**
  Widget _webLayout(Size size, ThemeMode mode) {
    return Row(
      children: [
        Expanded(
          flex: 1, // 50% width for image
          child: _imageContainer(size, 1.0), // Full height image
        ),
        Expanded(
          flex: 1, // 50% width for content
          child: _contentContainer(size, mode),
        ),
      ],
    );
  }

  /// **Image Container (Used in Both Layouts)**
  Widget _imageContainer(Size size, double heightFactor) {
    return Container(
      height: size.height * heightFactor,
      width: size.width, // Using MediaQuery directly
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        image: const DecorationImage(
          image: AssetImage("assets/images/bg.jpg"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  /// **Content Container (Used in Both Layouts)**
  Widget _contentContainer(Size size, ThemeMode mode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Welcome to DigiMag",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: mode == ThemeMode.light ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: Responsive.isMobile(context) ? 30 : 36,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Your go-to source for the latest news and articles from around the world.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 18,
              color: Color.fromARGB(255, 122, 122, 122),
              height: 1.5,
            ),
          ),
          SizedBox(height: Responsive.isMobile(context) ? 60 : 80),
          _buttonContainer(size),
        ],
      ),
    );
  }

  /// **Button Container**
  Widget _buttonContainer(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: size.height * 0.08,
        width: size
            .width, // Using MediaQuery instead of Responsive.widthOfScreen()
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color.fromARGB(255, 217, 205, 237).withOpacity(0.9),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _button("Register", MyRoutes.registerRoute),
            _button("Sign In", MyRoutes.signinRoute),
          ],
        ),
      ),
    );
  }

  /// **Reusable Button**
  Widget _button(String text, String route) {
    return Expanded(
      child: InkWell(
        onTap: () {
          Navigator.pushReplacementNamed(context, route);
        },
        borderRadius: BorderRadius.circular(15),
        splashColor: Colors.black,
        highlightColor: Colors.black,
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
