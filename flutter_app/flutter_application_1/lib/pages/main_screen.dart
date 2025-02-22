import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/feed_page.dart';
import 'package:flutter_application_1/pages/search_page.dart';
import 'package:flutter_application_1/pages/shop_page.dart';
import 'package:flutter_application_1/pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Default to Feed Page

  @override
  Widget build(BuildContext context) {
    String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    List<Widget> widgetOptions = <Widget>[
      const FeedPage(),
      const SearchPage(),
      const ShopPage(),
      ProfilePage(uid: currentUserUid ?? ''), // Fallback if user is not logged in
    ];

    return Scaffold(
      body: widgetOptions[_selectedIndex], // Use a non-constant list
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Shop'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }
}
