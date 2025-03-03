import 'dart:developer';
import 'dart:io'; // For Platform check
import 'package:android_intent_plus/android_intent.dart'; // Import package
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:digimag/main.dart';
import 'package:digimag/pages/dashboard/drawer/privacy_policy.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true; // Default value

  @override
  void initState() {
    super.initState();
    _loadNotificationsPreference(); // Load notifications setting on startup
  }

  // 🟢 Load notifications setting from SharedPreferences
  Future<void> _loadNotificationsPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    });
  }

  // 🟡 Save notifications setting to SharedPreferences
  Future<void> _saveNotificationsPreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', value);
  }

  // 🟢 Open App Info page for enabling notifications
  Future<void> _openAppInfo() async {
    if (Platform.isAndroid) {
      // Only for Android
      const packageName =
          'com.example.digimag'; // Replace with your app's package name
      final intent = AndroidIntent(
        action: 'android.settings.APPLICATION_DETAILS_SETTINGS',
        data:
            'package:$packageName', // Correct way to open app-specific settings
      );
      await intent.launch();
    } else {
      log('App Info page is not supported on this platform.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // 🔔 Notifications Toggle
          SwitchListTile(
            title: const Text('Enable Notifications'),
            subtitle: const Text('Go to App Info to manage notifications'),
            value: _notificationsEnabled,
            onChanged: (bool value) async {
              await _openAppInfo(); // 🟢 Open App Info page on toggle
            },
          ),
          // 🌗 Dark Mode Toggle (Uses ThemeModel)
          Consumer<ThemeModel>(
            builder: (context, themeModel, child) {
              return SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle:
                    const Text('Reduce eye strain in low-light environments'),
                value: themeModel.mode == ThemeMode.dark,
                onChanged: (bool value) {
                  themeModel.toggleTheme(); // Toggle theme using ThemeModel
                },
              );
            },
          ),
          // 📄 Privacy Policy
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PrivacyPolicyPage()),
              );
            },
          ),
          // ℹ️ About Us
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About Us'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('About Us'),
                  content: const Text(
                      'This app was developed to enhance your experience.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
