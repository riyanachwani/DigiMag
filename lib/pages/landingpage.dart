import 'dart:ui';

import 'package:digimag/main.dart';
import 'package:digimag/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
      body: Column(
        children: [
          Container(
            height: size.height * 0.53, // Image takes up 53% of screen height
            width: size.width,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: size.height *
                        0.53, // Ensure image takes up the full height defined
                    width: size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      image: DecorationImage(
                        image: AssetImage("assets/images/landing.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // This Container holds the text below the image
          SizedBox(height: 15), // Reduced space between title and description

          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(
                horizontal: 20, vertical: 30), // Add padding to the container
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center text vertically
              children: [
                Text(
                  "Welcome to DigiMag",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35, // Adjusted font size for better fit
                    color: Colors.black,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "Your go-to source for the latest news and articles from around the world.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.normal, // Changed to normal weight
                    fontSize: 20, // Adjusted font size for better readability
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 60),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                      height: size.height * 0.08,
                      width: size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color.fromARGB(255, 217, 205, 237)
                              .withOpacity(0.9),
                          border: Border.all(color: Colors.white),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12.withOpacity(0.05),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: const Offset(0, -1),
                            ),
                          ]),
                      child: Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: Row(
                            children: [
                              Container(
                                height: size.height * 0.08,
                                width: size.width / 2.2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.white),
                                ),
                                child: Center(
                                  child: Text("Register",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.black,
                                      )),
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                      context, MyRoutes.singinRoute);
                                },
                                child: Text("Sign In",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.black,
                                    )),
                              ),
                              const Spacer(),
                            ],
                          ))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
