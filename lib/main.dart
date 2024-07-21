import 'package:digimag/pages/auth/forgotpassword.dart';
import 'package:digimag/pages/dashboard/categories.dart';
import 'package:digimag/pages/dashboard/favorites.dart';
import 'package:digimag/pages/dashboard/home.dart';
import 'package:digimag/pages/dashboard/search.dart';
import 'package:digimag/pages/landingpage.dart';
import 'package:digimag/widgets/themes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'utils/routes.dart';
import 'package:provider/provider.dart';
import 'pages/auth/register.dart';
import 'pages/auth/signin.dart';
import 'pages/dashboard/dashboard.dart';

void main() async {
  await dotenv.load();
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
            initialRoute: MyRoutes.landingRoute,
            routes: {
              "/": (context) => LandingPage(),
              MyRoutes.dashboardRoute: (context) =>const DashboardPage(),
              MyRoutes.registerRoute: (context) => const RegisterPage(),
              MyRoutes.signinRoute: (context) => const SigninPage(),
              MyRoutes.landingRoute: (context) => const LandingPage(),
              MyRoutes.forgotpasswordRoute: (context) =>
                  const ForgotPasswordPage(),
              MyRoutes.HomeRoute: (context) => const HomePage(),
              MyRoutes.SearchRoute: (context) => const SearchPage(),
              MyRoutes.CategoriesRoute: (context) => const CategoriesPage(),
              MyRoutes.FavoriesRoute: (context) => const FavoritesPage(),
              
            },
          );
        }));
  }
}
