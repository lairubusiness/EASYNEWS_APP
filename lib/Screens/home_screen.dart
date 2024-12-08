import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';
import 'details_screen.dart';
import 'bookmarks_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    if (newsProvider.newsArticles.isEmpty && !newsProvider.isLoading) {
      newsProvider.fetchNews();
    }
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Top Headlines'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookmarksScreen()),
              );
            },
          ),
        ],
      ),
      body: newsProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : newsProvider.errorMessage.isNotEmpty
          ? Center(child: Text('Error: ${newsProvider.errorMessage}', style: TextStyle(color: Colors.red)))
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: newsProvider.newsArticles.length,
          itemBuilder: (context, index) {
            final article = newsProvider.newsArticles[index];

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
                      // Bookmark button
                      IconButton(
                        icon: Icon(
                          newsProvider.isBookmarked(article) ? Icons.bookmark : Icons.bookmark_border,
                          color: newsProvider.isBookmarked(article) ? Colors.blue : Colors.grey,
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
        ),
      ),
    );
  }
}

