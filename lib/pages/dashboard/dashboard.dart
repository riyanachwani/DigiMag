import 'package:digimag/pages/dashboard/categories.dart';
import 'package:digimag/pages/dashboard/drawer.dart';
import 'package:digimag/pages/dashboard/favorites.dart';
import 'package:digimag/pages/dashboard/home.dart';
import 'package:digimag/pages/dashboard/search.dart';
import 'package:digimag/utils/routes.dart';
import 'package:digimag/utils/user_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:digimag/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false); // Update SharedPreferences
    Navigator.of(context).pushReplacementNamed(MyRoutes.landingRoute);
  }

  Future<void> _saveLoginStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    final isDarkMode = themeModel.mode == ThemeMode.dark;
    final iconColor = isDarkMode ? Colors.white : Colors.black;

    Color _getButtonBackgroundColor() {
      return isDarkMode ? const Color.fromARGB(255, 94, 91, 91) : Colors.white;
    }

    final items = [
      Icon(Icons.home, size: 30, color: iconColor),
      Icon(Icons.search, size: 30, color: iconColor),
      Icon(Icons.favorite, size: 30, color: iconColor),
      Icon(Icons.category_rounded, size: 30, color: iconColor),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
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
          ),
        ],
      ),
      body: IndexedStack(
        index: _page,
        children: [
          HomePage(),
          SearchPage(),
          FavoritesPage(),
          CategoriesPage(),
        ],
      ),
      extendBody: false,
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        backgroundColor: Colors.transparent,
        color: Colors.purple.withOpacity(0.1),
        buttonBackgroundColor: _getButtonBackgroundColor(),
        height: 60.0,
        items: items,
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        index: _page,
        animationDuration: Duration(milliseconds: 300),
        animationCurve: Curves.easeInOut,
      ),
      drawer: const DrawerPage(),
    );
  }
}
