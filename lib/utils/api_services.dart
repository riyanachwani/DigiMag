import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = 'https://api.currentsapi.services/v1';
  final String _apiKey = dotenv.env['CURRENT_API_KEY'] ?? '';

  Future<List<String>> getAvailableCategories() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/available/categories?apiKey=$_apiKey'),
    );

    if (response.statusCode == 200) {
      print("DATA FETCHED FROM CURRENT API");
      final data = jsonDecode(response.body);
      final List<String> categories = List<String>.from(data['categories']);
      return categories;
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
