import 'package:flutter/material.dart';
import 'package:digimag/utils/services/api_services.dart';
import 'package:digimag/utils/services/user_services.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailPage extends StatefulWidget {
  final Article article;

  const NewsDetailPage({Key? key, required this.article}) : super(key: key);

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  final UserService _userService = UserService();
  bool _isBookmarked = false; // 🛠 Track if article is bookmarked

  @override
  void initState() {
    super.initState();
    _checkIfBookmarked(); // 🛠 Check bookmark status on page load
  }

  /// 🛠 **Check if article is already bookmarked**
  Future<void> _checkIfBookmarked() async {
    final bookmarks = await _userService.getBookmarks();
    setState(() {
      _isBookmarked = bookmarks
          .any((bookmark) => bookmark['title'] == widget.article.title);
    });
  }

  /// 🛠 **Toggle bookmark status**
  Future<void> _toggleBookmark() async {
    if (_isBookmarked) {
      // Remove bookmark
      final bookmarks = await _userService.getBookmarks();
      final bookmark =
          bookmarks.firstWhere((b) => b['title'] == widget.article.title);
      await _userService.removeBookmark(bookmark['id']);
    } else {
      // Add bookmark
      await _userService.addBookmark({
        'title': widget.article.title,
        'description': widget.article.description,
        'image': widget.article.image,
        'url': widget.article.url,
        'publishedDate': widget.article.publishedDate,
      });
    }
    _checkIfBookmarked(); // 🛠 Refresh bookmark status
  }

  /// 🛠 **Launch article URL**
  Future<void> _launchURL() async {
    final Uri url = Uri.parse(widget.article.url);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch ${widget.article.url}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.article.title),
        actions: [
          IconButton(
            onPressed: _toggleBookmark,
            icon: Icon(
              _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: _isBookmarked ? Colors.blue : Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.article.image != null
                ? Image.network(
                    widget.article.image!,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'assets/images/news.png',
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.article.title,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "The Guardian",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "${DateTime.parse(widget.article.publishedDate).toLocal()}"
                            .split(' ')[0],
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.article.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _launchURL,
                      child: const Text("Read Full Article"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
