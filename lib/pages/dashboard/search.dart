import 'package:digimag/utils/api_services.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String query = '';
  List<Article> articles = [];
  bool isLoading = false;

  void searchArticles(String query) async {
    setState(() {
      isLoading = true;
    });

    try {
      articles = await ApiService().searchArticles(query);
    } catch (e) {
      print('Error searching articles: $e');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search Articles",
          style: TextStyle(fontFamily: "RosebayRegular", fontSize: 20),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search Articles',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                query = value;
                if (query.isNotEmpty) {
                  searchArticles(query);
                } else {
                  setState(() {
                    articles = [];
                  });
                }
              },
            ),
            SizedBox(height: 10),
            isLoading
                ? CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        final article = articles[index];
                        return ListTile(
                          title: Text(
                            article.title,
                            style: TextStyle(
                              fontFamily: "RosebayRegular",
                              color: Colors.black,
                              fontSize: 16.0,
                            ),
                          ),
                          subtitle: Text(
                            article.description,
                            style: TextStyle(
                              // fontFamily: "RosebayRegular",
                              color: Colors.black,
                              fontSize: 14.0,
                            ),
                          ),
                          onTap: () {
                            // Handle article tap, e.g., navigate to detail page
                          },
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
