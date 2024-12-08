import 'package:flutter/material.dart';
import '../models/news_model.dart';  // Corrected import path

class DetailsScreen extends StatelessWidget {
  final NewsModel article;

  DetailsScreen({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title), // Display the article title
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display image if available
            article.imageUrl.isNotEmpty
                ? Image.network(article.imageUrl)
                : SizedBox(height: 200, child: Placeholder()),

            SizedBox(height: 16),

            // Article title
            Text(
              article.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 8),

            // Author name
            Text(
              article.author.isNotEmpty ? 'By: ${article.author}' : 'Author Unknown',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),

            SizedBox(height: 16),

            // Published date
            Text(
              'Published At: ${article.publishedAt}',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),

            SizedBox(height: 16),

            // Article content
            Text(
              article.content,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
