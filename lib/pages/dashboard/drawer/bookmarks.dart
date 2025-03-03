import 'package:digimag/pages/dashboard/dashboard/news_detail.dart';
import 'package:digimag/utils/providers/bookmark_provider.dart';
import 'package:digimag/utils/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  _BookmarksPageState createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  @override
  void initState() {
    super.initState();
    // Load bookmarks when the page is initialized
    Future.microtask(() =>
        Provider.of<BookmarkProvider>(context, listen: false).loadBookmarks());
  }

  Future<void> _removeBookmark(String articleId) async {
    await Provider.of<BookmarkProvider>(context, listen: false)
        .removeBookmark(articleId);
  }

  Article _mapToArticle(Map<String, dynamic> articleData) {
    return Article(
      id: articleData['id'] ?? '',
      title: articleData['title'] ?? '',
      description: articleData['description'] ?? '',
      url: articleData['url'] ?? '',
      image: articleData['image'] ?? '',
      publishedDate: articleData['publishedDate'] ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookmarks"),
        centerTitle: true,
      ),
      body: Consumer<BookmarkProvider>(
        builder: (context, bookmarkProvider, child) {
          final bookmarks = bookmarkProvider.bookmarks;

          if (bookmarks.isEmpty) {
            return const Center(child: Text('No bookmarks available.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              final articleData = bookmarks[index];
              final article = _mapToArticle(articleData);

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewsDetailPage(
                        article: article,
                      ),
                    ),
                  );
                },
                child: Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (article.image != null && article.image!.isNotEmpty)
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
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              article.description,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _removeBookmark(article.id),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
