import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = 'https://api.currentsapi.services/v1';
  final String _apiKey = 'ERWgn-WLm_yU3ODbxCU3O7mN8VQNeA-J3oeDXIxaVktc3gWf';

  Future<List<String>> getAvailableCategories() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/available/categories?apiKey=$_apiKey'),
    );

    if (response.statusCode == 200) {
      print("CATEGORIES LIST FETCHED FROM CURRENT API");
      final data = jsonDecode(response.body);
      final List<String> categories = List<String>.from(data['categories']);
      return categories;
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Article>> getLatestNews() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/latest-news?apiKey=$_apiKey'),
    );

    if (response.statusCode == 200) {
      print("LATEST NEWS FETCHED FROM CURRENT API");
      final data = jsonDecode(response.body);
      final List articlesJson = data['news'];
      return articlesJson.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load latest news');
    }
  }

  Future<List<Article>> getArticlesByCategory(String category) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/latest-news?category=$category&apiKey=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List articlesJson = data['news'];
      return articlesJson.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }

  Future<List<Article>> searchArticles(String query) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/search?apiKey=$_apiKey&keywords=$query'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List articlesJson = data['news'];
      return articlesJson.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search articles');
    }
  }
}

class Article {
  final String id;
  final String title;
  final String description;
  final String url;
  final String author;
  final String? image;
  final String language;
  final List<String> category;
  final DateTime published;

  Article({
    required this.id,
    required this.title,
    required this.description,
    required this.url,
    required this.author,
    this.image,
    required this.language,
    required this.category,
    required this.published,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      url: json['url'],
      author: json['author'],
      image: json['image'],
      language: json['language'],
      category: List<String>.from(json['category']),
      published: DateTime.parse(json['published']),
    );
  }
}
