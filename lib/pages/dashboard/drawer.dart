import 'package:digimag/utils/user_services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:digimag/utils/routes.dart';
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
      print("Failed to load user info: $e");
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
    Navigator.of(context).pushReplacementNamed(MyRoutes.landingRoute);
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(
                _userInfo['Name'] ?? 'Name',
                style: TextStyle(color: Colors.black),
              ),
              accountEmail: Text(
                _userInfo['Email'] ?? 'Email',
                style: TextStyle(color: Colors.black),
              ),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
              ),
            ),
            ListTile(
              title: Text('Logout'),
              leading: Icon(Icons.logout),
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }
}
