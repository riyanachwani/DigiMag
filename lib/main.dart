import 'package:digimag/pages/dashboard/dashboard/news_detail.dart';
import 'package:digimag/pages/dashboard/drawer/bookmarks.dart';
import 'package:digimag/pages/dashboard/drawer/contact_us.dart';
import 'package:digimag/pages/dashboard/drawer/feedback.dart';
import 'package:digimag/pages/dashboard/drawer/privacy_policy.dart';
import 'package:digimag/pages/dashboard/drawer/settings.dart';
import 'package:digimag/pages/onboarding/splash_screen.dart';
import 'package:digimag/utils/firebase_options.dart';
import 'package:digimag/pages/auth/forgotpassword.dart';
import 'package:digimag/pages/dashboard/dashboard/categories.dart';
import 'package:digimag/pages/dashboard/dashboard/home.dart';
import 'package:digimag/pages/dashboard/dashboard/search.dart';
import 'package:digimag/pages/onboarding/landingpage.dart';
import 'package:digimag/utils/services/api_services.dart';
import 'package:digimag/widgets/themes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utils/routes/routes.dart';
import 'package:provider/provider.dart';
import 'pages/auth/register.dart';
import 'pages/auth/signin.dart';
import 'pages/dashboard/dashboard/dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await _checkDataFromSharedPreferences();

  runApp(const MyApp());
}

class ThemeModel extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.system;

  ThemeModel() {
    _loadTheme();
  }

  ThemeMode get mode => _mode;

  void toggleTheme() {
    _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _saveTheme(_mode);
    notifyListeners();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    bool isDark = prefs.getBool('isDarkMode') ?? false;
    _mode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> _saveTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', mode == ThemeMode.dark);
  }
}

Future<void> _checkDataFromSharedPreferences() async {
  // Obtain shared preferences.
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Retrieve data.
  bool? isLoggedIn = prefs.getBool('isLoggedIn');

  print('isLoggedIn: $isLoggedIn');
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
            initialRoute: MyRoutes.splashRoute,
            routes: {
              "/": (context) => const SplashScreen(),
              MyRoutes.dashboardRoute: (context) => const DashboardPage(),
              MyRoutes.registerRoute: (context) => const RegisterPage(),
              MyRoutes.signinRoute: (context) => const SigninPage(),
              MyRoutes.landingRoute: (context) => const LandingPage(),
              MyRoutes.forgotpasswordRoute: (context) =>
                  const ForgotPasswordPage(),
              MyRoutes.homeRoute: (context) => const HomePage(),
              MyRoutes.searchRoute: (context) => const SearchPage(),
              MyRoutes.categoriesRoute: (context) => CategoriesPage(),
              MyRoutes.bookmarksRoute: (context) => BookmarksPage(),
              MyRoutes.contactRoute: (context) => const ContactUsPage(),
              MyRoutes.settingsRoute: (context) => const SettingsPage(),
              MyRoutes.feedbackRoute: (context) => const FeedbackPage(),
              MyRoutes.privacypolicyRoute: (context) =>
                  const PrivacyPolicyPage(),
              MyRoutes.newsRoute: (context) => NewsDetailPage(
                    article:
                        ModalRoute.of(context)!.settings.arguments as Article,
                  ),
            },
          );
        }));
  }
}
