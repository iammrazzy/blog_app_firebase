import 'package:blog_app/auth/sign_in.dart';
import 'package:blog_app/model/blog_model.dart';
import 'package:blog_app/screen/blog_detail.dart';
import 'package:blog_app/screen/create_blog.dart';
import 'package:blog_app/screen/search_blog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';
import 'package:shimmer/shimmer.dart';

class HomeBlog extends StatefulWidget {
  const HomeBlog({super.key});

  @override
  State<HomeBlog> createState() => _HomeBlogState();
}

class _HomeBlogState extends State<HomeBlog> {
  // User
  final user = FirebaseAuth.instance.currentUser;

  // show message
  _showMessage(String msg, Color color) {
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
    // Display data on the scrren by curren user
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();
    //
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          // Remove padding
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: user!.photoURL == null
                      ? Image.asset(
                          'images/User.jpg',
                          fit: BoxFit.cover,
                          width: 130.0,
                          height: 130.0,
                        )
                      : Image.network(
                          user!.photoURL.toString(),
                          fit: BoxFit.cover,
                          width: 130.0,
                          height: 130.0,
                        ),
                ),
              ),
              accountName: SizedBox(
                child: user?.displayName == null
                    ? Text(
                        'No username',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: GoogleFonts.kantumruyPro(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        user!.displayName.toString(),
                        style: GoogleFonts.kantumruyPro(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
              accountEmail: Text(
                user!.email.toString(),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: GoogleFonts.kantumruyPro(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10.0),
                ),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(
                    'images/Angkor.jpg',
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Settings',
                        style: GoogleFonts.kantumruyPro(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      const Divider(),
                      ListTile(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return SizedBox(
                                height: 280.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Account Deletion',
                                        style: GoogleFonts.kantumruyPro(
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                      const Divider(
                                          thickness: 2, color: Colors.grey),
                                      Text(
                                        '1. Are you sure you want to delete your account?',
                                        style: GoogleFonts.kantumruyPro(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '2. This action cannot be undone.',
                                        style: GoogleFonts.kantumruyPro(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '3. All of your data will be permanently deleted.',
                                        style: GoogleFonts.kantumruyPro(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '4. if you have any questions, please contact me.',
                                        style: GoogleFonts.kantumruyPro(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '4.  To delete your account, click on \'delete\'',
                                        style: GoogleFonts.kantumruyPro(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 20.0),
                                      ElevatedButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                  "Confirm",
                                                  style:
                                                      GoogleFonts.kantumruyPro(
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                content: Text(
                                                  "Are you sure you want to Delete your account?",
                                                  style:
                                                      GoogleFonts.kantumruyPro(
                                                    fontSize: 18.0,
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    child: Text(
                                                      "No",
                                                      style: GoogleFonts
                                                          .kantumruyPro(
                                                        fontSize: 18.0,
                                                      ),
                                                    ),
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(),
                                                  ),
                                                  TextButton(
                                                    child: Text(
                                                      "Yes",
                                                      style: GoogleFonts
                                                          .kantumruyPro(
                                                        fontSize: 18.0,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                    onPressed: () async {
                                                      await FirebaseAuth
                                                          .instance.currentUser!
                                                          .delete()
                                                          .whenComplete(() {
                                                        _showMessage(
                                                            'Account deleted...!',
                                                            Colors.blue);
                                                        Navigator
                                                            .pushAndRemoveUntil(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                SignIn(),
                                                          ),
                                                          (route) => false,
                                                        );
                                                        print('Deleted user!');
                                                      });
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          fixedSize: Size(
                                              MediaQuery.of(context).size.width,
                                              50.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        child: Text(
                                          'Delete',
                                          style: GoogleFonts.kantumruyPro(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        leading: const Icon(
                          Icons.delete_forever,
                          color: Colors.black,
                        ),
                        title: Text(
                          'Delete account',
                          style: GoogleFonts.kantumruyPro(
                            fontSize: 15.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  "Confirm",
                                  style: GoogleFonts.kantumruyPro(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: Text(
                                  "Are you sure you want to Sign Out of your account?",
                                  style: GoogleFonts.kantumruyPro(
                                    fontSize: 18.0,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    child: Text(
                                      "No",
                                      style: GoogleFonts.kantumruyPro(
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                  TextButton(
                                    child: Text(
                                      "Yes",
                                      style: GoogleFonts.kantumruyPro(
                                        fontSize: 18.0,
                                        color: Colors.red,
                                      ),
                                    ),
                                    onPressed: () {
                                      FirebaseAuth.instance
                                          .signOut()
                                          .whenComplete(() {
                                        _showMessage(
                                            'Signed out...!', Colors.blue);
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SignIn(),
                                          ),
                                          (route) => false,
                                        );
                                      });
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        leading: const Icon(
                          Icons.logout,
                          color: Colors.black,
                        ),
                        title: Text(
                          'Sign out',
                          style: GoogleFonts.kantumruyPro(
                            fontSize: 15.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Blogs',
          style: GoogleFonts.kantumruyPro(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          CircleAvatar(
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchBlog(),
                  ),
                );
              },
              icon: const Icon(
                Icons.search,
              ),
            ),
          ),
          const SizedBox(width: 5.0),
          CircleAvatar(
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateBlog(),
                  ),
                );
              },
              icon: const Icon(
                Icons.add,
              ),
            ),
          ),
          const SizedBox(width: 10.0),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: users.doc(uid).collection('posts').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Icon(
                Icons.info,
                color: Colors.red,
                size: 30,
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'No blog posts yet!',
                    style: GoogleFonts.kantumruyPro(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateBlog(),
                        ),
                      );
                    },
                    child: Text(
                      'Click (+) to post',
                      style: GoogleFonts.kantumruyPro(
                        fontSize: 15.0,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
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
                          builder: (context) => BlogDetail(blog: blog),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 220.0,
                            child: CachedNetworkImage(
                              imageUrl: blog.blogImage,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => Center(
                                child: Shimmer.fromColors(
                                  baseColor: Colors.purple.shade900,
                                  highlightColor: Colors.cyan,
                                  child: const CircularProgressIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),

                          // Blog title

                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 50.0,
                                    child: Center(
                                      child: Shimmer.fromColors(
                                        baseColor: Colors.purple.shade900,
                                        highlightColor: Colors.cyan,
                                        child: Marquee(
                                          text: blog.blogTitle,
                                          style: GoogleFonts.kantumruyPro(
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          blankSpace: 10.0,
                                          velocity: 100.0,
                                          pauseAfterRound:
                                              const Duration(seconds: 3),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5.0),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      child: IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.more_horiz),
                                      ),
                                    ),
                                    const SizedBox(width: 5.0),
                                    CircleAvatar(
                                      child: IconButton(
                                        onPressed: () async {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                  "Confirm",
                                                  style:
                                                      GoogleFonts.kantumruyPro(
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                content: Text(
                                                  "Are you sure you want to delete this item?",
                                                  style:
                                                      GoogleFonts.kantumruyPro(
                                                    fontSize: 18.0,
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    child: Text(
                                                      "No",
                                                      style: GoogleFonts
                                                          .kantumruyPro(
                                                        fontSize: 18.0,
                                                      ),
                                                    ),
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(),
                                                  ),
                                                  TextButton(
                                                    child: Text(
                                                      "Yes",
                                                      style: GoogleFonts
                                                          .kantumruyPro(
                                                        fontSize: 18.0,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                    onPressed: () async {
                                                      CollectionReference
                                                          users =
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'users');
                                                      FirebaseAuth auth =
                                                          FirebaseAuth.instance;
                                                      String uid = auth
                                                          .currentUser!.uid
                                                          .toString();
                                                      users
                                                          .doc(uid)
                                                          .collection('posts')
                                                          .doc(snapshot.data!
                                                              .docs[index].id)
                                                          .delete();
                                                      // ignore: use_build_context_synchronously
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        icon: const Icon(Icons.delete),
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
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
