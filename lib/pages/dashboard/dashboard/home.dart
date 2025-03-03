import 'dart:developer';

import 'package:digimag/utils/services/api_services.dart';
import 'package:digimag/utils/providers/bookmark_provider.dart';
import 'package:digimag/utils/providers/category_provider.dart'; // Import CategoryProvider
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Article>>? _articlesFuture;

  @override
  void initState() {
    super.initState();
    Provider.of<BookmarkProvider>(context, listen: false).loadBookmarks();
  }

  // 🟢 Fetch articles based on favorite categories dynamically
  // 🟢 Fetch articles for all favorite categories
  Future<List<Article>> _fetchFavoriteCategoryArticles(
      List<String> favoriteCategories) async {
    log("🟢 Favorite Categories in HomePage: $favoriteCategories");
    if (favoriteCategories.isNotEmpty) {
      return await ApiService().getArticlesByCategories(favoriteCategories);
    } else {
      log("⚠️ No favorite categories selected.");
      return [];
    }
  }

// 🟢 Toggle bookmarks as usual
  Future<void> _toggleBookmark(Article article) async {
    final bookmarkProvider =
        Provider.of<BookmarkProvider>(context, listen: false);
    final isBookmarked =
        bookmarkProvider.bookmarks.any((b) => b['title'] == article.title);

    if (isBookmarked) {
      final bookmark = bookmarkProvider.bookmarks
          .firstWhere((b) => b['title'] == article.title);
      await bookmarkProvider.removeBookmark(bookmark['id']);
    } else {
      await bookmarkProvider.addBookmark({
        'title': article.title,
        'description': article.description,
        'image': article.image,
        'url': article.url,
        'publishedDate': article.publishedDate,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🔄 Listen for changes in favorite categories in real-time
    final favoriteCategories =
        context.watch<CategoryProvider>().likedCategories.toList();

    return Scaffold(
      body: FutureBuilder<List<Article>>(
        future: _fetchFavoriteCategoryArticles(
            favoriteCategories), // Fetch articles dynamically
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text(
                    'No articles available for your favorite categories.'));
          }

          final articles = snapshot.data!
              .where((article) =>
                  article.image != null && article.image!.isNotEmpty)
              .toList();

          if (articles.isEmpty) {
            return const Center(
                child: Text('No articles with images available.'));
          }

          return Consumer<BookmarkProvider>(
            builder: (context, bookmarkProvider, child) {
              return ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  final article = articles[index];
                  final isBookmarked = bookmarkProvider.bookmarks
                      .any((b) => b['title'] == article.title);

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12)),
                          child: Image.network(
                            article.image!,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset('assets/images/news.png',
                                  height: 200, fit: BoxFit.cover);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                article.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontFamily: "RosebayRegular",
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.color,
                                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                article.description,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontSize: 14.0,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.color,
                                    ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "The Guardian",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "${DateTime.parse(article.publishedDate).toLocal()}"
                                            .split(' ')[0],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                      ),
                                      const SizedBox(width: 8),
                                      GestureDetector(
                                        onTap: () => _toggleBookmark(article),
                                        child: Icon(
                                          isBookmarked
                                              ? Icons.bookmark
                                              : Icons.bookmark_border,
                                          color: isBookmarked
                                              ? Colors.blue
                                              : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
