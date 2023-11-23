import 'package:blog_app/screen/fav_blog.dart';
import 'package:blog_app/screen/home_blog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Current index
  int currentIndex = 0;

  // All screens
  List screens = [
    const HomeBlog(),
    const FavoriteBlog(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        iconSize: 25.0,
        selectedLabelStyle: GoogleFonts.kantumruyPro(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: GoogleFonts.kantumruyPro(
          fontSize: 15.0,
        ),
        selectedItemColor: Colors.purple,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
