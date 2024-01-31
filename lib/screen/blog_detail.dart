import 'package:blog_app/model/blog_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:marquee/marquee.dart';

class BlogDetail extends StatefulWidget {
  BlogDetail({super.key, required this.blog});

  BlogModel blog;

  @override
  State<BlogDetail> createState() => _BlogDetailState();
}

class _BlogDetailState extends State<BlogDetail> {
  final user = FirebaseAuth.instance.currentUser;
  bool isBookmark = false;

  // Launch URL
  void openURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Can not launch $url';
    }
  }

  // save image
  void saveImage(String imageUrl) async {
    try {
      String name = DateTime.now().toString();
      final response = await Dio().get(
        imageUrl,
        options: Options(
          responseType: ResponseType.bytes,
          receiveTimeout: const Duration(minutes: 1),
          validateStatus: (status) => status! < 500,
        ),
      );

      final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 100,
        name: 'BlogApp/$name',
      );

      print('Result: 👉 $result');
      showMSG('Image saved to Gallery!', Colors.indigo);
    } catch (e) {
      print('Error fetching or saving image: $e');
      showMSG('Error fetching or saving image: $e', Colors.red);
    }
  }

  // Show message
  Future showMSG(String msg, Color color) {
    return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 50.0,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Shimmer.fromColors(
              baseColor: Colors.purple,
              highlightColor: Colors.cyan,
              child: Marquee(
                text: widget.blog.blogTitle,
                style: GoogleFonts.kantumruyPro(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
                blankSpace: 10.0,
                velocity: 100.0,
                pauseAfterRound: const Duration(seconds: 3),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            // Image
            SizedBox(
              height: 250.0,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.blog.blogImage,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Center(
                      child: Shimmer.fromColors(
                        baseColor: Colors.purple,
                        highlightColor: Colors.cyan,
                        child: const CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        openURL(widget.blog.imageSource);
                      },
                      child: Container(
                        height: 30.0,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Center(
                          child: Marquee(
                            text:
                                'Image Source: ${widget.blog.imageSource.isEmpty ? 'No data 💀' : widget.blog.imageSource}',
                            style: GoogleFonts.kantumruyPro(
                              fontSize: 15.0,
                              color: Colors.purple[900],
                            ),
                            blankSpace: 10.0,
                            velocity: 100.0,
                            pauseAfterRound: const Duration(seconds: 3),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // User owner
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(.1),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.account_circle,
                      size: 30.0,
                      color: Colors.purple[900],
                    ),
                  ),
                ),
                Container(
                  height: 50.0,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(.1),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Text(
                      user!.email.toString(),
                      style: GoogleFonts.kantumruyPro(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[900],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // User post date
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(.1),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.timer,
                      size: 30.0,
                      color: Colors.purple[900],
                    ),
                  ),
                ),
                Container(
                  height: 50.0,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(.1),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Text(
                      DateFormat().format(widget.blog.blogID.toDate()),
                      style: GoogleFonts.kantumruyPro(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[900],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Description
            const SizedBox(height: 10.0),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(.1),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Articles',
                          style: GoogleFonts.kantumruyPro(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[900],
                          ),
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              child: IconButton(
                                onPressed: () {
                                  setState(
                                    () {
                                      widget.blog.isFavorite =
                                          !widget.blog.isFavorite;
                                    },
                                  );
                                },
                                icon: widget.blog.isFavorite
                                    ? const Icon(Icons.favorite)
                                    : const Icon(Icons.favorite_border),
                              ),
                            ),
                            const SizedBox(width: 5.0),
                            CircleAvatar(
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isBookmark = !isBookmark;
                                  });
                                },
                                icon: isBookmark
                                    ? const Icon(Icons.bookmark_add)
                                    : const Icon(Icons.bookmark_add_outlined),
                              ),
                            ),
                            const SizedBox(width: 5.0),
                            CircleAvatar(
                              child: IconButton(
                                onPressed: () {
                                  saveImage(widget.blog.blogImage);
                                },
                                icon: const Icon(Icons.download),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 5.0),
                    GestureDetector(
                      onTap: () {
                        openURL(widget.blog.articleSource);
                      },
                      child: Shimmer.fromColors(
                        baseColor: Colors.purple,
                        highlightColor: Colors.cyan,
                        direction: ShimmerDirection.rtl,
                        child: Text(
                          '👉 Article Source: ${widget.blog.articleSource.isEmpty ? 'No data' : widget.blog.articleSource}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: GoogleFonts.kantumruyPro(
                            fontSize: 15.0,
                            color: Colors.purple[900],
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 5.0),
                    SelectableText(
                      widget.blog.blogDescription,
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.kantumruyPro(
                        fontSize: 18.0,
                        color: Colors.purple[900],
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    Text(
                      'IAMRAZZY',
                      style: GoogleFonts.kantumruyPro(
                        letterSpacing: 4.5,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[900],
                      ),
                    ),
                    Text(
                      'FOLLOW&FINDMEON:',
                      style: GoogleFonts.kantumruyPro(
                        letterSpacing: 4.5,
                        fontSize: 15.0,
                        color: Colors.purple[900],
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        CircleAvatar(
                          child: IconButton(
                            onPressed: () {
                              openURL('https://facebook.com/razz.thr');
                            },
                            icon: const Icon(Icons.facebook),
                          ),
                        ),
                        const SizedBox(width: 5.0),
                        CircleAvatar(
                          child: IconButton(
                            onPressed: () {
                              openURL('https://t.me/razzy_thr');
                            },
                            icon: const Icon(Icons.telegram),
                          ),
                        ),
                        const SizedBox(width: 5.0),
                        CircleAvatar(
                          child: IconButton(
                            onPressed: () {
                              openURL(
                                  'mailto:riththeara103@gmail.com?subject=Your title&body=Your descriptions');
                            },
                            icon: const Icon(Icons.email),
                          ),
                        ),
                        const SizedBox(width: 5.0),
                        CircleAvatar(
                          child: IconButton(
                            onPressed: () {
                              openURL(
                                  'https://www.google.com/maps/place/Wat+Takhenvorn+(Trapeang+Orb)/@11.3898981,104.4350004,17z/data=!3m1!4b1!4m6!3m5!1s0x3109230ea266d2c3:0xdb5300d1babeeff!8m2!3d11.3898981!4d104.4375753!16s%2Fg%2F11rd85wd3f?entry=ttu');
                            },
                            icon: const Icon(Icons.place),
                          ),
                        ),
                        const SizedBox(width: 5.0),
                        CircleAvatar(
                          child: IconButton(
                            onPressed: () {
                              openURL('tel:+855 96 62 29 358');
                            },
                            icon: const Icon(Icons.phone),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
