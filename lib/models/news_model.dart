import 'package:flutter/material.dart';

/// Class representing a detailed news article with all relevant fields.
class NewsArticle {
  final String title;
  final String author;
  final String description;
  final String urlToImage;
  final String publishedAt;
  final String content;
  final String url;

  NewsArticle({
    required this.title,
    required this.author,
    required this.description,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
    required this.url,
  });

  /// Factory constructor to create a `NewsArticle` object from JSON data.
  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? 'No Title',
      author: json['author'] ?? 'Unknown Author',
      description: json['description'] ?? 'No Description Available',
      urlToImage: (json['urlToImage'] is String) ? json['urlToImage'] : '',
      publishedAt: (json['publishedAt'] is String) ? json['publishedAt'] : '',
      content: json['content'] ?? 'No Content Available',
      url: json['url'] ?? '',
    );
  }

}

/// A helper function to parse a list of `NewsArticle` objects from JSON data.
List<NewsArticle> parseArticles(List<dynamic> jsonList) {
  return jsonList.map((json) => NewsArticle.fromJson(json)).toList();
}

/// A simplified model class for news articles, suitable for lightweight use cases.
class NewsModel {
  final String title;
  final String description;
  final String url;
  final String imageUrl;
  final String publishedAt;
  final String author;
  final String content;

  NewsModel({
    required this.title,
    required this.description,
    required this.url,
    required this.imageUrl,
    required this.publishedAt,
    required this.author,
    required this.content,
  });

  /// Factory constructor to create a `NewsModel` object from JSON data.
  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description Available',
      url: json['url'] ?? '',
      imageUrl: (json['urlToImage'] is String) ? json['urlToImage'] : '',
      publishedAt: (json['publishedAt'] is String) ? json['publishedAt'] : '',
      author: json['author'] ?? 'Unknown Author',
      content: json['content'] ?? 'No Content Available',
    );
  }
  // Add the getter here:
  String get urlToImage => imageUrl; // Getter for urlToImage
}

/// A helper function to parse a list of `NewsModel` objects from JSON data.
List<NewsModel> parseNewsModels(List<dynamic> jsonList) {
  return jsonList.map((json) => NewsModel.fromJson(json)).toList();
}
