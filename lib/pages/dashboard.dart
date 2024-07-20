import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:digimag/main.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

enum _SelectedTab { home, search, favorites, categories }

class _DashboardPageState extends State<DashboardPage> {
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  void _handleLogout() {
    // Handle the logout logic here
    print("Logout clicked");
  }

  void _handleRegister() {
    // Handle the register logic here
    print("Register clicked");
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    final isDarkMode = themeModel.mode == ThemeMode.dark;
    final iconColor = isDarkMode ? Colors.white : Colors.black;

    Color _getButtonBackgroundColor() {
      return isDarkMode ? Colors.grey[800]! : Colors.white;
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
          PopupMenuButton<String>(
            icon: Icon(Icons.person, color: iconColor),
            onSelected: (value) {
              if (value == 'logout') {
                _handleLogout();
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'logout',
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color.fromARGB(255, 217, 205, 237),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12.withOpacity(0.05),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(0, -1),
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () {
                        _handleLogout();
                      },
                      borderRadius: BorderRadius.circular(15),
                      splashColor: Colors.black.withOpacity(0.2),
                      highlightColor: Colors.black.withOpacity(0.1),
                      child: Container(
                        height: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(
                            "Logout",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16, // Adjusted size to fit better
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
