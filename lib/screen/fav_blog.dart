import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class FavoriteBlog extends StatefulWidget {
  const FavoriteBlog({super.key});

  @override
  State<FavoriteBlog> createState() => _FavoriteBlogState();
}

class _FavoriteBlogState extends State<FavoriteBlog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        title: Text(
          'Favorites',
          style: GoogleFonts.kantumruyPro(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          CircleAvatar(
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications_active_rounded,
              ),
            ),
          ),
          const SizedBox(width: 10.0),
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.purple.shade900,
              highlightColor: Colors.cyan,
              child: Text(
                'STAY TUNE GUYYY!',
                style: GoogleFonts.kantumruyPro(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              'I\'m working on it.',
              style: GoogleFonts.kantumruyPro(
                fontSize: 15.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
