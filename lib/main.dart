import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/news_provider.dart';
import 'Screens/home_screen.dart';
import 'Screens/search_screen.dart';
import 'Screens/category_screen.dart';
import 'Screens/bookmarks_screen.dart'; // Ensure correct import path for BookmarksScreen

import 'models/news_model.dart' as news_model; // Corrected import for models

void main() {
  runApp(const EasyNewsApp());
}
class EasyNewsApp extends StatelessWidget {
  const EasyNewsApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NewsProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'EasyNews',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Roboto',  // Custom font for consistency
          scaffoldBackgroundColor: Colors.white,
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: Colors.grey[600],
            showUnselectedLabels: true,
          ),
        ),
        home: const MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // List of screens for navigation
  final List<Widget> _screens = [
    HomeScreen(),
    SearchScreen(),
    CategoryScreen(),
    BookmarksScreen(), // Pass the actual bookmarked articles from the provider

  ];

  // Handle bottom navigation item tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'EasyNews',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: _screens[_selectedIndex],  // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey[600],
        selectedLabelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookmarks',
          ),
        ],
      ),
    );
  }
}
