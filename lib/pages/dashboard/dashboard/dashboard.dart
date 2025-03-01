import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:digimag/pages/dashboard/dashboard/categories.dart';
import 'package:digimag/pages/dashboard/dashboard/home.dart';
import 'package:digimag/pages/dashboard/dashboard/search.dart';
import 'package:digimag/pages/dashboard/drawer/drawer.dart';
import 'package:provider/provider.dart';
import 'package:digimag/main.dart'; // Import your ThemeModel here

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _page = 0; // Track the selected page
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
      builder: (context, themeModel, child) {
        final isDarkMode = themeModel.mode == ThemeMode.dark;

        // This ensures the text color changes based on the theme
        final textStyle = isDarkMode
            ? Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Colors.white)
            : Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Colors.black);

        Color _getButtonBackgroundColor() {
          return isDarkMode
              ? const Color.fromARGB(255, 94, 91, 91)
              : Colors.white;
        }

        final items = [
          Icon(Icons.home,
              size: 30, color: isDarkMode ? Colors.white : Colors.black),
          Icon(Icons.search,
              size: 30, color: isDarkMode ? Colors.white : Colors.black),
          Icon(Icons.category_rounded,
              size: 30, color: isDarkMode ? Colors.white : Colors.black),
        ];

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "DigiMag",
              style: TextStyle(
                  fontFamily: 'RosebayRegular',
                  color: isDarkMode ? Colors.white : Colors.black),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  themeModel.toggleTheme(); // Switch theme when tapped
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
              HomePage(), // Home Page widget
              SearchPage(), // Search Page widget
              CategoriesPage(), // Categories Page widget
            ],
          ),
          extendBody: false,
          bottomNavigationBar: CurvedNavigationBar(
            key: _bottomNavigationKey,
            backgroundColor: Colors.transparent,
            color: Colors.purple.withOpacity(0.1),
            buttonBackgroundColor:
                _getButtonBackgroundColor(), // Adjust based on theme
            height: 60.0,
            items: items,
            onTap: (index) {
              setState(() {
                _page = index; // Update the selected page index
              });
            },
            index: _page, // Active page index
            animationDuration: Duration(milliseconds: 300),
            animationCurve: Curves.easeInOut,
          ),
          drawer: const DrawerPage(), // Drawer widget
        );
      },
    );
  }
}
