import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';  // Corrected import path
import '../models/news_model.dart';  // Corrected import path
import 'package:cached_network_image/cached_network_image.dart';

import 'details_screen.dart'; // For image caching

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Variable to track theme mode (Light or Dark)
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);

    // Toggle theme mode based on _isDarkMode
    return Scaffold(
      appBar: AppBar(
        title: Text('Search News'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: [
          // Dark Mode / Light Mode Toggle Button
          IconButton(
            icon: Icon(
              _isDarkMode ? Icons.nights_stay : Icons.wb_sunny,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
              // Toggle between light and dark theme using ThemeMode
              if (_isDarkMode) {
                // Set dark theme
                Provider.of<NewsProvider>(context, listen: false)
                    .changeTheme(ThemeData.dark());
              } else {
                // Set light theme
                Provider.of<NewsProvider>(context, listen: false)
                    .changeTheme(ThemeData.light());
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for news...',
                hintStyle: TextStyle(color: Colors.grey[500]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  color: Colors.blueAccent,
                  onPressed: () {
                    if (_searchController.text.isNotEmpty) {
                      newsProvider.searchNews(_searchController.text);
                    }
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<NewsProvider>(
              builder: (context, newsProvider, child) {
                if (newsProvider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (newsProvider.newsArticles.isEmpty) {
                  return Center(
                    child: Text(
                      'No results found.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: newsProvider.newsArticles.length,
                  itemBuilder: (context, index) {
                    final article = newsProvider.newsArticles[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
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
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              // Article Image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: article.urlToImage ??
                                      'https://via.placeholder.com/150',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error, size: 50),
                                ),
                              ),
                              SizedBox(width: 10),
                              // Article Text
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Article Title
                                    Text(
                                      article.title,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 5),
                                    // Article Description
                                    Text(
                                      article.description.isNotEmpty
                                          ? article.description
                                          : 'No Description Available',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              // Bookmark Button
                              IconButton(
                                icon: Icon(
                                  newsProvider.isBookmarked(article)
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  color: Colors.blueAccent,
                                ),
                                onPressed: () {
                                  if (newsProvider.isBookmarked(article)) {
                                    newsProvider.removeBookmark(article);
                                  } else {
                                    newsProvider.addBookmark(article);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
