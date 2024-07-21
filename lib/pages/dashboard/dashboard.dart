import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:digimag/main.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    final isDarkMode = themeModel.mode == ThemeMode.dark;
    final iconColor = isDarkMode ? Colors.white : Colors.black;

    Color _getButtonBackgroundColor() {
      return isDarkMode ? Colors.black : Colors.white;
    }

    final items = [
      Icon(Icons.home, size: 30, color: iconColor),
      Icon(Icons.search, size: 30, color: iconColor),
      Icon(Icons.favorite, size: 30, color: iconColor),
      Icon(Icons.category_outlined, size: 30, color: iconColor),
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(125, 209, 191, 239), Colors.white],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Center(
          child: Text(
            'Page $_page',
            textScaleFactor: 2.0,
          ),
        ),
      ),
      extendBody: true,
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        backgroundColor: Colors.transparent,
        color: Colors.purple.withOpacity(0.1), // Background color
        buttonBackgroundColor: _getButtonBackgroundColor(), // Button color
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
    );
  }
}
