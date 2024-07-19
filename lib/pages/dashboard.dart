import 'package:digimag/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

enum _SelectedTab { home, likes, search, profile }

class _DashboardPageState extends State<DashboardPage> {

     _SelectedTab _selectedTab = _SelectedTab.home;

     void _handleIndexChanged(int index) {
    setState(() {
      _selectedTab = _SelectedTab.values[index];
      // Add navigation logic here
      // For example, you can use Navigator to push new pages or use a PageController for a page view
    });
  }
  @override
  Widget build(BuildContext context) {
  Size size = MediaQuery.of(context).size;
    final themeModel = Provider.of<ThemeModel>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
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
          )
        ],
      ),
  body: Container(),
  extendBody: false,
   bottomNavigationBar:  DotNavigationBar(
          currentIndex: _SelectedTab.values.indexOf(_selectedTab),
          onTap: _handleIndexChanged,
          // dotIndicatorColor: Colors.black,
          items: [
            /// Home
            DotNavigationBarItem(
              icon: Icon(Icons.home),
              selectedColor: Colors.purple,
            ),

            /// Likes
            DotNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              selectedColor: Colors.pink,
            ),
    
            /// Search
            DotNavigationBarItem(
              icon: Icon(Icons.search),
              selectedColor: Colors.orange,
            ),

            /// Profile
            DotNavigationBarItem(
              icon: Icon(Icons.person),
              selectedColor: Colors.teal,
            ),
            
          ],
        ),
    );
  }
}
