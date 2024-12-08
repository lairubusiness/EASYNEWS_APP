import 'package:easynews_app/Utils/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'details_screen.dart';
import '../models/news_model.dart';
import 'package:easynews_app/providers/news_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<NewsModel> _newsList = [];
  String _selectedCategory = 'business'; // Default category

  @override
  void initState() {
    super.initState();
    _fetchNewsByCategory(_selectedCategory);
  }

  void _fetchNewsByCategory(String category) async {
    try {
      final news = await ApiService.fetchNewsByCategory(category);
      setState(() {
        _newsList = news;
      });
    } catch (e) {
      print('Error fetching news: $e');
      setState(() {
        _newsList = []; // Handle the error state gracefully
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Category News'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          // Category Dropdown for category selection with better styling
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: DropdownButton<String>(
                value: _selectedCategory,
                onChanged: (String? newCategory) {
                  if (newCategory != null) {
                    setState(() {
                      _selectedCategory = newCategory;
                      _fetchNewsByCategory(newCategory);
                    });
                  }
                },
                isExpanded: true,
                items: <String>['business', 'entertainment', 'health', 'science', 'sports', 'technology']
                    .map<DropdownMenuItem<String>>((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(
                      category.capitalizeFirstOfEach,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
                icon: Icon(Icons.arrow_drop_down),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _newsList.length,
              itemBuilder: (context, index) {
                final article = _newsList[index];
                final isBookmarked = newsProvider.bookmarkedArticles.contains(article);

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  child: InkWell(
                    onTap: () {
                      // Navigate to the details screen for the tapped article
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
                        children: [
                          // Article Image with cached network image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: article.urlToImage ?? 'https://via.placeholder.com/150',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(Icons.error, size: 50),
                            ),
                          ),
                          SizedBox(width: 10),
                          // Article Text and Bookmark Button
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                Text(
                                  article.description ?? 'No Description Available',
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
                          IconButton(
                            icon: Icon(
                              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                              color: isBookmarked ? Colors.blue : null,
                            ),
                            onPressed: () {
                              newsProvider.toggleBookmark(article); // Toggle the bookmark status
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Extension for capitalizing category names
extension StringExtension on String {
  String get capitalizeFirstOfEach {
    return this.split(' ').map((str) => str.capitalize).join(' ');
  }

  String get capitalize {
    if (this == null) {
      return '';
    }
    return this[0].toUpperCase() + this.substring(1);
  }
}
