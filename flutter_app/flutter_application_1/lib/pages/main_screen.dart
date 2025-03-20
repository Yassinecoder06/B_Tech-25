import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_application_1/pages/ai_page.dart';
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
      const AIPage(),
      const ShopPage(),
      ProfilePage(uid: currentUserUid ?? ''), // Fallback if user is not logged in
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        backgroundColor: Colors.transparent,
        color: Colors.purple.shade100,
        buttonBackgroundColor: Colors.white,
        animationDuration: const Duration(milliseconds: 300),
        height: 60,
        items: [
          Icon(Icons.home, size: 30, color: Colors.purple[400]),
          Icon(Icons.search, size: 30, color:  Colors.purple[400]),
          Icon(Icons.camera, size: 30, color:  Colors.purple[400]),
          Icon(Icons.shopping_cart, size: 30, color:  Colors.purple[400]),
          Icon(Icons.person, size: 30, color:  Colors.purple[400]),
        ],
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
