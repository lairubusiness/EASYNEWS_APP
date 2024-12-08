import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/news_model.dart';

class ApiService {
  static const String _baseUrl = 'https://newsapi.org/v2';
  static const String _apiKey = '7df5ac68601b41aca9fa56f6ab7641a1';

  // Fetch top headlines
  static Future<List<NewsModel>> fetchTopHeadlines() async {
    final url = Uri.parse('$_baseUrl/top-headlines?country=us&apiKey=$_apiKey');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['articles'] as List)
            .map((article) => NewsModel.fromJson(article))
            .toList();
      } else {
        print('Error: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load top headlines');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load top headlines');
    }
  }

// Fetch news by category
  static Future<List<NewsModel>> fetchNewsByCategory(String category) async {
    final url = Uri.parse('$_baseUrl/top-headlines?category=$category&country=us&apiKey=$_apiKey');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['articles'] as List)
            .map((article) => NewsModel.fromJson(article))
            .toList();
      } else {
        print('Error: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load category news');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load category news');
    }
  }

  // Search for news
  static Future<List<NewsModel>> fetchNews(String query) async {
    final url = Uri.parse('$_baseUrl/everything?q=$query&apiKey=$_apiKey');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['articles'] as List)
            .map((article) => NewsModel.fromJson(article))
            .toList();
      } else {
        print('Error: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load search results');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load search results');
    }
  }
}
