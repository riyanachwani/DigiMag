import 'package:flutter/material.dart';
import 'package:digimag/utils/api_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Article>> _articlesFuture;

  @override
  void initState() {
    super.initState();
    _articlesFuture = ApiService().getLatestNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Articles",
          style: TextStyle(fontFamily: "RosebayRegular", fontSize: 20),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PAGE1
            Container(
              color: Colors.white,
              width: double.infinity,
              child: FutureBuilder<List<Article>>(
                future: _articlesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No articles available.'));
                  } else {
                    final articles = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...articles
                            .map((article) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical:
                                          10), // Reduced horizontal padding
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        article.title,
                                        style: TextStyle(
                                          fontFamily: "RosebayRegular",
                                          color: Colors.black,
                                          fontSize: 24.0, // Adjusted font size
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      article.image != null &&
                                              article.image!.isNotEmpty
                                          ? Image.network(
                                              article.image!,
                                              width: double.infinity,
                                              height: 200,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Image.asset(
                                                    'assets/landing.jpg');
                                              },
                                            )
                                          : SizedBox.shrink(),
                                      SizedBox(height: 10),
                                      Text(
                                        article.description,
                                        style: TextStyle(
                                          fontFamily: "RosebayRegular",
                                          color: Colors.black,
                                          fontSize: 16.0, // Adjusted font size
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      Divider(
                                        thickness: 2.0, // Adjusted thickness
                                        color: Colors
                                            .grey, // Set desired separator color
                                        height: 20.0, // Adjusted spacing
                                        indent:
                                            20.0, // Adjusted left indentation
                                        endIndent:
                                            20.0, // Adjusted right indentation
                                      ),
                                      SizedBox(height: 20),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
