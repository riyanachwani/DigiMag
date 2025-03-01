import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = 'https://content.guardianapis.com';
  final String _apiKey = 'c59a2cb1-3053-4438-8af0-c0346036ad94';

  // Fetch available sections (categories)
  Future<List<String>> getAvailableCategories() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/sections?api-key=$_apiKey'),
    );

    if (response.statusCode == 200) {
      log("✅ CATEGORIES LIST FETCHED FROM THE GUARDIAN API");
      final data = jsonDecode(response.body);
      final List sections = data['response']['results'];
      return sections.map<String>((section) => section['id']).toList();
    } else {
      throw Exception('❌ Failed to load categories');
    }
  }

  // Fetch latest news
  Future<List<Article>> getLatestNews() async {
    final response = await http.get(
      Uri.parse(
          '$_baseUrl/search?order-by=newest&show-fields=headline,thumbnail,trailText&api-key=$_apiKey'),
    );

    if (response.statusCode == 200) {
      log("✅ LATEST NEWS FETCHED FROM THE GUARDIAN API");
      final data = jsonDecode(response.body);
      final List articlesJson = data['response']['results'];
      return articlesJson.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('❌ Failed to load latest news');
    }
  }

  // Fetch articles by category
  // Fetch articles by category
  Future<List<Article>> getArticlesByCategory(String category) async {
    final url =
        '$_baseUrl/search?section=$category&show-fields=headline,thumbnail,trailText&api-key=$_apiKey';
    log("🌐 Fetching articles for category: $category");
    log("🔗 API URL: $url");

    final response = await http.get(Uri.parse(url));

    log("HTTP Status Code: ${response.statusCode}");
    log("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      log("✅ ARTICLES FOR CATEGORY '$category' FETCHED");
      final data = jsonDecode(response.body);
      final List articlesJson = data['response']['results'];

      if (articlesJson.isEmpty) {
        log("⚠️ No articles found for category: $category");
      }

      return articlesJson.map((json) => Article.fromJson(json)).toList();
    } else {
      log("❌ Failed to load articles for category: $category");
      throw Exception('❌ Failed to load articles for category: $category');
    }
  }

  // Search articles by query
  Future<List<Article>> searchArticles(String query) async {
    final encodedQuery =
        Uri.encodeQueryComponent(query); // ✅ Encode the search query
    final response = await http.get(
      Uri.parse(
          '$_baseUrl/search?q=$encodedQuery&show-fields=headline,thumbnail,trailText&api-key=$_apiKey'),
    );

    if (response.statusCode == 200) {
      log("✅ SEARCH RESULTS FETCHED FOR QUERY: '$query'");
      final data = jsonDecode(response.body);
      final List articlesJson = data['response']['results'];
      return articlesJson.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('❌ Failed to search articles for query: $query');
    }
  }
}

class Article {
  final String id;
  final String title;
  final String description;
  final String url;
  final String? image;
  final String publishedDate;

  Article({
    required this.id,
    required this.title,
    required this.description,
    required this.url,
    this.image,
    required this.publishedDate, // ✅ Initialize publishedDate
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['fields']['headline'] ?? "No Title",
      description: json['fields']['trailText'] ?? "No Description",
      url: json['webUrl'], // ✅ Correct URL usage
      image: json['fields']['thumbnail'] ?? "", // ✅ Handle null images
      publishedDate: json['webPublicationDate'] ?? "",
    );
  }
}
