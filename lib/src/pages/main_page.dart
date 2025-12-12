import 'package:flutter/material.dart';
import 'home_page.dart';
import 'cart_page.dart';
import 'search_page.dart';
import 'wishlist_page.dart';
import 'profile_page.dart';
import '../widgets/custom_bottom_navigation_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const SearchPage(),
    const WishlistPage(),
    const CartPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

