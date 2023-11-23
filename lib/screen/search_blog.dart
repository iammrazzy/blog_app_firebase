import 'package:blog_app/model/blog_model.dart';
import 'package:blog_app/screen/blog_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';
import 'package:shimmer/shimmer.dart';

class SearchBlog extends StatefulWidget {
  const SearchBlog({super.key});

  @override
  State<SearchBlog> createState() => _SearchBlogState();
}

class _SearchBlogState extends State<SearchBlog> {
  // Search controller
  final _searchController = TextEditingController();
  // Search query
  String? query;

  @override
  Widget build(BuildContext context) {
    // Display data on the scrren by curren user
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();
    //
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  // back button
                  Container(
                    height: 45.0,
                    width: 45.0,
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(.1),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.purple[900],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),

                  // Search field
                  Container(
                    height: 45.0,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(.1),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextFormField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search posts',
                        hintStyle: GoogleFonts.kantumruyPro(
                          fontSize: 16.0,
                          color: Colors.purple[900],
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.purple[900],
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            _searchController.clear();
                          },
                          icon: Icon(
                            Icons.clear,
                            color: Colors.purple[900],
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        query = value;
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Body
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: (query != '' && query != null)
                    ? users
                        .doc(uid)
                        .collection('posts')
                        .where(
                          'blog_title',
                          isGreaterThanOrEqualTo: query,
                        )
                        .snapshots()
                    : users.doc(uid).collection('posts').snapshots(),
                builder: (context, snapshot) {
                  return (snapshot.connectionState == ConnectionState.waiting)
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            BlogModel blog = BlogModel.fromDucumentSnapshot(
                              snapshot.data!.docs[index],
                            );
                            return Card(
                                color: Colors.white,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BlogDetail(blog: blog),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(5.0),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.purple.withOpacity(.2),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 220.0,
                                          child: CachedNetworkImage(
                                            imageUrl: blog.blogImage,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 3,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            placeholder: (context, url) =>
                                                Center(
                                              child: Shimmer.fromColors(
                                                baseColor:
                                                    Colors.purple.shade900,
                                                highlightColor: Colors.cyan,
                                                child:
                                                    const CircularProgressIndicator(),
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),

                                        // Blog title

                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: SizedBox(
                                                  height: 50.0,
                                                  child: Center(
                                                    child: Shimmer.fromColors(
                                                      baseColor: Colors
                                                          .purple.shade900,
                                                      highlightColor:
                                                          Colors.cyan,
                                                      child: Marquee(
                                                        text: blog.blogTitle,
                                                        style: GoogleFonts
                                                            .kantumruyPro(
                                                          fontSize: 25.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        blankSpace: 10.0,
                                                        velocity: 100.0,
                                                        pauseAfterRound:
                                                            const Duration(
                                                          seconds: 3,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  CircleAvatar(
                                                    child: IconButton(
                                                      onPressed: () {},
                                                      icon: const Icon(
                                                        Icons.more_horiz,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5.0),
                                                  CircleAvatar(
                                                    child: IconButton(
                                                      onPressed: () async {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                "Confirm",
                                                                style: GoogleFonts
                                                                    .kantumruyPro(
                                                                  fontSize:
                                                                      20.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              content: Text(
                                                                "Are you sure you want to delete this item?",
                                                                style: GoogleFonts
                                                                    .kantumruyPro(
                                                                  fontSize:
                                                                      18.0,
                                                                ),
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                  child: Text(
                                                                    "No",
                                                                    style: GoogleFonts
                                                                        .kantumruyPro(
                                                                      fontSize:
                                                                          18.0,
                                                                    ),
                                                                  ),
                                                                  onPressed: () =>
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop(),
                                                                ),
                                                                TextButton(
                                                                  child: Text(
                                                                    "Yes",
                                                                    style: GoogleFonts
                                                                        .kantumruyPro(
                                                                      fontSize:
                                                                          18.0,
                                                                      color: Colors
                                                                          .red,
                                                                    ),
                                                                  ),
                                                                  onPressed:
                                                                      () async {
                                                                    CollectionReference
                                                                        users =
                                                                        FirebaseFirestore
                                                                            .instance
                                                                            .collection('users');
                                                                    FirebaseAuth
                                                                        auth =
                                                                        FirebaseAuth
                                                                            .instance;
                                                                    String uid = auth
                                                                        .currentUser!
                                                                        .uid
                                                                        .toString();
                                                                    users
                                                                        .doc(
                                                                            uid)
                                                                        .collection(
                                                                            'posts')
                                                                        .doc(snapshot
                                                                            .data!
                                                                            .docs[index]
                                                                            .id)
                                                                        .delete();
                                                                    // ignore: use_build_context_synchronously
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                      icon: const Icon(
                                                          Icons.delete),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Blog description
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            blog.blogDescription,
                                            textAlign: TextAlign.justify,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                            style: GoogleFonts.kantumruyPro(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.purple[900],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ));
                          },
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
