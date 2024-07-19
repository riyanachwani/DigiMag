import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digimag/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/routes.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isPasswordVisible = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoggedIn = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> _saveLoginStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  Future<void> _checkLoginStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  void _showAlertDialog(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Error in registration"),
              content: Text(message, style: TextStyle(fontSize: 16)),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK"))
              ],
            ));
  }

  void moveToLogin(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        User? user = await register(
          email: _emailController.text,
          password: _passwordController.text,
          context: context,
        );
        if (user != null) {
          await _saveLoginStatus(true);
          Navigator.pushReplacementNamed(context, MyRoutes.signinRoute);
        } else {
          _showAlertDialog("Error in Registering. Try Again");
        }
      } catch (e) {
        print("Error $e");
      }
    }
  }

  static Future<User?> register({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String userId = userCredential.user!.uid;
      await FirebaseFirestore.instance.collection("users").doc(userId).set({
        'Email': email,
      });
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print("Account with the same email already exists.");
      } else {
        print("Error signing in-Check the email and password again.");
      }
      return null;
    } catch (e) {
      print("Error $e");
      return null;
    }
  }

  Future<void> GoogleRegister() async {
    try {
      // Trigger the Google Sign-In process
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        // Obtain the auth details from the request
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in to Firebase with the Google credential
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        // Perform post-sign-in actions, e.g., save user info or navigate
        User? user = userCredential.user;
        if (user != null) {
          await _saveLoginStatus(true);
          Navigator.pushReplacementNamed(
              context, MyRoutes.dashboardRoute); // Redirect to home page
        }
      }
    } catch (e) {
      print("Error during Google Sign-In: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final themeModel = Provider.of<ThemeModel>(context);

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
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(125, 209, 191, 239), Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      SizedBox(height: size.height * 0.03),
                      Text(
                        "Welcome to DigiMag",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30, // Adjusted font size for better fit

                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Your go-to source for the latest news and articles from around the world.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight:
                              FontWeight.normal, // Changed to normal weight
                          fontSize:
                              18, // Adjusted font size for better readability
                          color: const Color.fromARGB(255, 122, 122, 122),
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: size.height * 0.04),
                      myTextField("Enter Email"),
                      myPasswordField("Enter Password"),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 18.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context,
                                    MyRoutes
                                        .forgotpasswordRoute); // Navigate to Forgot Password route
                              },
                              child: Text(
                                "Forgot Password",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.04),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          height: size.height * 0.08,
                          width: size.width,
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
                              moveToLogin(context);
                            },
                            borderRadius: BorderRadius.circular(15),
                            splashColor: Colors.black,
                            highlightColor: Colors.black,
                            child: Container(
                              height: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  "Register",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.04),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 2,
                            width: size.width * 0.2,
                            color: Colors.black,
                          ),
                          SizedBox(
                              width:
                                  10), // Add some space between the line and the text
                          Text(
                            "Or continue with",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                              width:
                                  10), // Add some space between the text and the line
                          Container(
                            height: 2,
                            width: size.width * 0.2,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.04),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              GoogleRegister(); 
                            },
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: Image.asset(
                                "assets/images/google.png",
                                height: 35,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.04),
                      Align(
                        alignment: Alignment.center,
                        child: RichText(
                          text: TextSpan(
                            text: "Already a member? ",
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            children: [
                              TextSpan(
                                text: "Sign in now",
                                style: TextStyle(
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      MyRoutes.signinRoute,
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )),
            )),
      ),
    );
  }

  Container myTextField(String hint) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: TextFormField(
        controller: _emailController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter an email';
          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
            return 'Please enter a valid email';
          }
          return null;
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.black,
            fontSize: 19,
          ),
        ),
      ),
    );
  }

  Container myPasswordField(String hint) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: TextFormField(
        controller: _passwordController,
        obscureText: !_isPasswordVisible, // Toggle visibility based on state
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a password';
          } else if (value.length < 6) {
            return 'Password should be at least 6 characters';
          }
          return null;
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.black,
            fontSize: 19,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible; // Toggle state
              });
            },
          ),
        ),
      ),
    );
  }
}
