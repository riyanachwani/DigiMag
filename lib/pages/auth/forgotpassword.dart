import 'package:digimag/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hello!"),
        content: Text(
          message,
          style: TextStyle(fontSize: 16), // Increase text size
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeModel themeModel = Provider.of<ThemeModel>(context);
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
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [Color.fromARGB(125, 209, 191, 239), Colors.white],
          begin: Alignment.topCenter,
          end: AlignmentDirectional.bottomCenter,
        )),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Enter your email address to reset your password',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email address',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    auth
                        .sendPasswordResetEmail(
                            email: _emailController.text.toString())
                        .then((value) {
                      _showAlertDialog(
                          "Check your email for a password recovery email.");
                    }).onError((error, stackTrace) {
                      _showAlertDialog(error.toString());
                    });
                  },
                  child: Text('Reset Password'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
