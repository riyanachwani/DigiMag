import 'package:digimag/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("DigiMag"),
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
    );
  }
}
