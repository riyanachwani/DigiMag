import 'package:flutter/material.dart';
import 'package:digimag/utils/services/api_services.dart';
import 'package:digimag/utils/services/user_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Article>> _articlesFuture;
  final UserService _userService = UserService();
  final Set<String> _bookmarkedArticles = {};

  @override
  void initState() {
    super.initState();
    _articlesFuture = ApiService().getLatestNews();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    final bookmarks = await _userService.getBookmarks();
    setState(() {
      _bookmarkedArticles.addAll(bookmarks.map((e) => e['title'] as String));
    });
  }

  Future<void> _toggleBookmark(Article article) async {
    final isBookmarked = _bookmarkedArticles.contains(article.title);
    if (isBookmarked) {
      final bookmarks = await _userService.getBookmarks();
      final bookmark = bookmarks.firstWhere((b) => b['title'] == article.title);
      await _userService.removeBookmark(bookmark['id']);
    } else {
      await _userService.addBookmark({
        'title': article.title,
        'description': article.description,
        'image': article.image,
        'url': article.url,
        'publishedDate': article.publishedDate,
      });
    }
    // Re-load bookmarks to ensure state is updated after toggling
    _loadBookmarks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Article>>(
        future: _articlesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No articles available.'));
          }

          final articles = snapshot.data!
              .where((article) =>
                  article.image != null && article.image!.isNotEmpty)
              .toList();

          if (articles.isEmpty) {
            return const Center(
                child: Text('No articles with images available.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              final isBookmarked = _bookmarkedArticles.contains(article.title);

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(12)),
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
                                      ?.color, // Ensure color is updated
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
                                      ?.color, // Ensure color is updated
                                ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
      ),
    );
  }
}
