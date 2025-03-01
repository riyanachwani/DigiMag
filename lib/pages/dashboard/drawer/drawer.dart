import 'dart:developer';

import 'package:digimag/utils/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:digimag/utils/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({Key? key}) : super(key: key);

  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  Map<String, String?> _userInfo = {
    'name': 'Loading...',
    'email': 'Loading...'
  };

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      final userInfo = await UserService().getUserInfo();
      setState(() {
        _userInfo = userInfo;
      });
    } catch (e) {
      log("Failed to load user info: $e");
      setState(() {
        _userInfo = {
          'name': 'Error loading name',
          'email': 'Error loading email'
        };
      });
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false); // Update SharedPreferences
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(MyRoutes.landingRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Drawer(
      child: Container(
        color: theme.colorScheme.surface,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(
                _userInfo['Name'] ?? 'Name', // Correct key access
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              accountEmail: Text(
                _userInfo['Email'] ?? 'Email', // Correct key access
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.bookmark),
              title: const Text('Bookmarks'),
              onTap: () {
                Navigator.pushNamed(context, MyRoutes.bookmarksRoute);
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('Feedback'),
              onTap: () {
                Navigator.pushNamed(context, MyRoutes.feedbackRoute);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About Us'),
              onTap: () {
                Navigator.pushNamed(context, MyRoutes.aboutRoute);
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy Policy'),
              onTap: () {
                Navigator.pushNamed(context, MyRoutes.privacypolicyRoute);
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_mail),
              title: const Text('Contact Us'),
              onTap: () {
                Navigator.pushNamed(context, MyRoutes.contactRoute);
              },
            ),
            const Divider(), // Adds a divider above the Logout option
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }
}
