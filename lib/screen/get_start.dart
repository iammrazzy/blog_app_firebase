import 'package:blog_app/auth/sign_in.dart';
import 'package:blog_app/model/content_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class GetStart extends StatefulWidget {
  @override
  _GetStartState createState() => _GetStartState();
}

class _GetStartState extends State<GetStart> {
  // Default index of page
  int currentIndex = 0;

  // Page controller
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Get all contents
  List<ContentModel> contents = allContent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignIn(),
                        ),
                        (route) => false,
                      );
                    },
                    child: Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: contents.length,
                onPageChanged: (newIndex) {
                  setState(() {
                    currentIndex = newIndex;
                  });
                },
                itemBuilder: (context, index) {
                  final content = contents[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image
                        Container(
                          height: 250.0,
                          width: 250.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.purple,
                              width: 5.0,
                            ),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                content.image,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        Shimmer.fromColors(
                          baseColor: Colors.purple.shade900,
                          highlightColor: Colors.cyan,
                          child: Text(
                            content.title,
                            style: GoogleFonts.kantumruyPro(
                              fontSize: 35.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        Text(
                          content.description,
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.kantumruyPro(
                            fontSize: 18.0,
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                contents.length,
                (index) {
                  return Container(
                    height: 10.0,
                    width: currentIndex == index ? 25 : 10,
                    margin: const EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.purple,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 35.0),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                onPressed: () {
                  if (currentIndex == contents.length - 1) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignIn(),
                      ),
                      (route) => false,
                    );
                  }
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.bounceIn,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  fixedSize: Size(MediaQuery.of(context).size.width, 50.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  currentIndex == contents.length - 1 ? 'Continue' : 'Next',
                  style: GoogleFonts.kantumruyPro(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
