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
              color: Colors.purple.withOpacity(0.1),
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
                                      horizontal: 22, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        title: Text(article.title,
                                            style: TextStyle(
                                              fontFamily: "RosebayRegular",
                                              color: Colors.black,
                                              fontSize: 35.0,
                                              fontWeight: FontWeight.w400,
                                            )),
                                        subtitle: Text(article.description,
                                            style: TextStyle(
                                              fontFamily: "RosebayRegular",
                                              color: Colors.black,
                                              fontSize: 20.0,
                                            )),
                                        onTap: () {
                                          // Handle article tap
                                        },
                                      ),
                                      SizedBox(height: 15),
                                      SizedBox(height: 40),
                                      Divider(
                                        thickness:
                                            4.0, // Adjust thickness as needed
                                        color: Colors
                                            .grey, // Set desired separator color
                                        height:
                                            0.0, // Adjust spacing above and below the line (optional)
                                        indent:
                                            20.0, // Adjust left indentation (optional)
                                        endIndent:
                                            20.0, // Adjust right indentation (optional)
                                      ),
                                      SizedBox(height: 40),
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
