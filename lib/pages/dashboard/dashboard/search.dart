import 'package:digimag/utils/services/api_services.dart';
import 'package:flutter/material.dart';

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
                        return ListTile(
                          title: Text(
                            article.title,
                            style: TextStyle(
                              fontFamily: "RosebayRegular",
                              color: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.color, // 🔄 Adaptive text color
                              fontSize: 16.0,
                            ),
                          ),
                          subtitle: Text(
                            article.description,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color, // 🔄 Adaptive text color
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
