import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:easynews_app/models/news_model.dart';
import 'package:easynews_app/Utils/api_service.dart'; // Ensure correct import for ApiService

class NewsProvider with ChangeNotifier {
  ThemeData _themeData = ThemeData.light();

  ThemeData get themeData => _themeData;

  void changeTheme(ThemeData theme) {
    _themeData = theme;
    notifyListeners();
  }
  List<NewsModel> _newsArticles = [];
  List<NewsModel> _categoryNews = [];
  List<NewsModel> _bookmarkedArticles = []; // List for Bookmarked articles
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  List<NewsModel> get newsArticles => _newsArticles;
  List<NewsModel> get categoryNews => _categoryNews;
  List<NewsModel> get bookmarkedArticles => _bookmarkedArticles; // Getter for Bookmarked Articles
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;

  // Method to fetch general news articles
  Future<void> fetchNews() async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('https://newsapi.org/v2/top-headlines?country=us&apiKey=7df5ac68601b41aca9fa56f6ab7641a1'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        _newsArticles = parseNewsModels(data['articles']);
      } else {
        _errorMessage = 'Failed to load news';
        _hasError = true;
      }
    } catch (error) {
      _errorMessage = 'Error: ${error.toString()}';
      _hasError = true;
    }

    _isLoading = false;
    notifyListeners();
  }

  // Method to fetch news articles by category
  Future<void> fetchCategoryNews(String category) async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('https://newsapi.org/v2/top-headlines?category=$category&country=us&apiKey=7df5ac68601b41aca9fa56f6ab7641a1'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        _categoryNews = parseNewsModels(data['articles']);
      } else {
        _errorMessage = 'Failed to load $category news';
        _hasError = true;
      }
    } catch (error) {
      _errorMessage = 'Error: ${error.toString()}';
      _hasError = true;
    }

    _isLoading = false;
    notifyListeners();
  }

  // Method to search news articles based on query
  Future<void> searchNews(String query) async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('https://newsapi.org/v2/everything?q=$query&apiKey=7df5ac68601b41aca9fa56f6ab7641a1'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        _newsArticles = parseNewsModels(data['articles']);
      } else {
        _errorMessage = 'Failed to load search results';
        _hasError = true;
      }
    } catch (error) {
      _errorMessage = 'Error: ${error.toString()}';
      _hasError = true;
    }

    _isLoading = false;
    notifyListeners();
  }

  // Helper method to parse news models from JSON response
  List<NewsModel> parseNewsModels(List<dynamic> jsonList) {
    return jsonList.map((json) => NewsModel.fromJson(json)).toList();
  }

  // Add bookmark
  void addBookmark(NewsModel article) {
    if (!_bookmarkedArticles.contains(article)) {
      _bookmarkedArticles.add(article);
      notifyListeners();
    }
  }

  // Remove bookmark
  void removeBookmark(NewsModel article) {
    _bookmarkedArticles.remove(article);
    notifyListeners();
  }

  // Check if an article is bookmarked
  bool isBookmarked(NewsModel article) {
    return _bookmarkedArticles.contains(article);
  }

  // Toggle bookmark (add or remove)
  void toggleBookmark(NewsModel article) {
    if (_bookmarkedArticles.contains(article)) {
      _bookmarkedArticles.remove(article);
    } else {
      _bookmarkedArticles.add(article);
    }
    notifyListeners(); // Update the UI when the list changes
  }

  // Add the updateCategoryNews method to handle fetching category news
  Future<void> updateCategoryNews(String category) async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();

    try {
      final news = await ApiService.fetchNewsByCategory(category); // Fetching category news via ApiService
      _categoryNews = news;
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Failed to fetch news: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


}
