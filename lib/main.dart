import 'package:digimag/pages/forgotpassword.dart';
import 'package:digimag/pages/landingpage.dart';
import 'package:digimag/widgets/themes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'utils/routes.dart';
import 'package:provider/provider.dart';
import 'pages/register.dart';
import 'pages/signin.dart';
import 'pages/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((_) {
    print("Firebase initialized successfully");
  }).catchError((error) {
    print("$error");
  });
  runApp(const MyApp());
}

class ThemeModel extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.light;
  ThemeMode get mode => _mode;
  void toggleTheme() {
    _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ThemeModel(),
        child: Consumer<ThemeModel>(builder: (context, themeModel, child) {
          return MaterialApp(
            themeMode: themeModel.mode,
            theme: MyTheme.lightTheme(context),
            darkTheme: MyTheme.darkTheme(context),
            debugShowCheckedModeBanner: false,
            initialRoute: MyRoutes.signinRoute,
            routes: {
              "/": (context) => LandingPage(),
              MyRoutes.homeRoute: (context) => const HomePage(),
              MyRoutes.registerRoute: (context) => const RegisterPage(),
              MyRoutes.signinRoute: (context) => const SigninPage(),
              MyRoutes.landingRoute: (context) => const LandingPage(),
              MyRoutes.forgotpasswordRoute: (context) =>
                  const ForgotPasswordPage(),
            },
          );
        }));
  }
}
