import 'package:flutter/material.dart';
import 'package:digimag/utils/services/api_services.dart';
import 'package:digimag/pages/dashboard/dashboard/news_detail.dart';

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
        title: const Text(
          "Search Articles",
          style: TextStyle(fontFamily: "RosebayRegular", fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
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
            const SizedBox(height: 10),
            isLoading
                ? const CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        final article = articles[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: Builder(
                            builder: (context) {
                              // 🔄 Ensures latest theme is applied
                              return ListTile(
                                title: Text(
                                  article.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontFamily: "RosebayRegular",
                                        fontSize: 16.0,
                                      ),
                                ),
                                subtitle: Text(
                                  article.description,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(fontSize: 14.0),
                                ),
                                onTap: () {
                                  // ✅ Navigate to News Detail Page
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NewsDetailPage(
                                        article: article,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
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
