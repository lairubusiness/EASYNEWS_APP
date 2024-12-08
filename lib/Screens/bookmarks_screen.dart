import 'package:easynews_app/Screens/details_screen.dart';
import 'package:easynews_app/providers/news_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Class representing an individual news article.
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
      title: json['title'] as String? ?? 'No Title', // Added type casting
      author: json['author'] as String? ?? 'Unknown Author', // Added type casting
      description: json['description'] as String? ?? 'No Description Available', // Added type casting
      urlToImage: json['urlToImage'] as String? ?? '', // Image URL (can be empty)
      publishedAt: json['publishedAt'] as String? ?? '', // Publication date
      content: json['content'] as String? ?? 'No Content Available', // Article content
      url: json['url'] as String? ?? '', // Original article URL
    );
  }
}

/// A helper function to parse a list of articles from JSON data.
List<NewsArticle> parseArticles(List<dynamic> jsonList) {
  return jsonList.map((json) => NewsArticle.fromJson(json as Map<String, dynamic>)).toList();
}

/// Class representing a simplified version of news data to display in a list.
class NewsModel {
  final String title;
  final String description;
  final String url;
  final String imageUrl;
  final String author;
  final String content;

  NewsModel({
    required this.title,
    required this.description,
    required this.url,
    required this.imageUrl,
    required this.author,
    required this.content,
  });

  // Factory method to parse JSON data into a NewsModel object
  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      url: json['url'] as String? ?? '',
      imageUrl: json['urlToImage'] as String? ?? '', // Image URL (can be empty)
      author: json['author'] as String? ?? 'Unknown Author',
      content: json['content'] as String? ?? 'No Content',
    );
  }
}

class BookmarksScreen extends StatelessWidget {
@override
Widget build(BuildContext context) {
  final newsProvider = Provider.of<NewsProvider>(context);

  return Scaffold(
    appBar: AppBar(
      title: Text('Bookmarked News'),
      backgroundColor: Colors.blueAccent,
    ),
    body: newsProvider.bookmarkedArticles.isEmpty
        ? Center(child: Text('No bookmarks yet!'))
        : ListView.builder(
      itemCount: newsProvider.bookmarkedArticles.length,
      itemBuilder: (context, index) {
        final article = newsProvider.bookmarkedArticles[index];

        return Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailsScreen(article: article),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      article.urlToImage ?? 'https://via.placeholder.com/150',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.title,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 5),
                        Text(
                          article.description ?? 'No Description Available',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                    onPressed: () {
                      newsProvider.removeBookmark(article);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}
}


/// A helper function to parse a list of simplified news models from JSON data.
List<NewsModel> parseNewsModels(List<dynamic> jsonList) {
  return jsonList.map((json) => NewsModel.fromJson(json as Map<String, dynamic>)).toList();
}
