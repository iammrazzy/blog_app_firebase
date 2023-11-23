import 'dart:io';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CreateBlog extends StatefulWidget {
  const CreateBlog({super.key});

  @override
  State<CreateBlog> createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  // Text controller
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageSource = TextEditingController();
  final _articleSource = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Loading
  bool isPosting = false;

  // database
  final _storage = FirebaseStorage.instance;

  // Get image
  File? _image;
  String? imageURL;
  final picker = ImagePicker();

  // favorite
  bool isFavorite = false;

  // Get image from Gallery
  Future<void> getImageGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        debugPrint('Selected image: $_image');
      } else {
        debugPrint('No image selected...!');
      }
    });
  }

  // Get image from Camera
  Future<void> getImageCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        debugPrint('Selected image: $_image');
      } else {
        debugPrint('No image selected...!');
      }
    });
  }

  //Upload image to Firebase storage
  Future<void> uploadImage() async {
    // Image name
    String imageName = DateFormat().format(DateTime.now());

    var refrence = _storage.ref().child("/imagePosts").child(imageName);
    var uploadTask = await refrence.putFile(_image!).whenComplete(() {
      debugPrint('Image uploaded...!');
    });
    String url = await uploadTask.ref.getDownloadURL();
    setState(() {
      imageURL = url;
    });
    debugPrint('Download Link: $url');
  }

  // Show dialog to choose image from
  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: SizedBox(
            height: 115.0,
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    getImageCamera();
                    Navigator.pop(context);
                  },
                  leading: const Icon(Icons.camera_alt),
                  title: Text(
                    'Camera',
                    style: GoogleFonts.kantumruyPro(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    getImageGallery();
                    Navigator.pop(context);
                  },
                  leading: const Icon(Icons.image),
                  title: Text(
                    'Gallery',
                    style: GoogleFonts.kantumruyPro(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // Show message
  _showMessage(String text, Color color) async {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  // User post
  Future<void> userPost() async {
    try {
      if (_titleController.text.isEmpty &&
          _descriptionController.text.isEmpty) {
        _showMessage('Please enter data...!', Colors.red);
        debugPrint('Please enter data...!');
      } else {
        await uploadImage().whenComplete(() async {
          CollectionReference users =
              FirebaseFirestore.instance.collection('users');
          FirebaseAuth auth = FirebaseAuth.instance;
          String uid = auth.currentUser!.uid.toString();
          await users.doc(uid).collection('posts').add(
            {
              'blog_id': Timestamp.now(),
              'blog_image': imageURL.toString(),
              'blog_title': _titleController.text.trim(),
              'blog_description': _descriptionController.text.trim(),
              'image_source': _imageSource.text.trim(),
              'article_source': _articleSource.text.trim(),
              'isFavorite': isFavorite,
            },
          ).whenComplete(() {
            _showMessage('Posted...!', Colors.blue);
            Navigator.pop(context);
            print('Posted successfully...!');
          });
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Post',
          style: GoogleFonts.kantumruyPro(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Center(
              child: _image == null
                  ? GestureDetector(
                      onTap: () {
                        _showDialog();
                      },
                      child: Container(
                        height: 220.0,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(.1),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.add_a_photo,
                            size: 30.0,
                            color: Colors.purple[800],
                          ),
                        ),
                      ),
                    )
                  : Container(
                      height: 220.0,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(.1),
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(
                            File(_image!.path),
                          ),
                        ),
                      ),
                    ),
            ),

            // Title
            const SizedBox(height: 10.0),
            TextFormField(
              controller: _titleController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.purple.withOpacity(.1),
                hintText: 'Title',
                hintStyle: GoogleFonts.kantumruyPro(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Description
            const SizedBox(height: 10.0),
            TextFormField(
              controller: _descriptionController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.purple.withOpacity(.1),
                hintText: 'Description',
                hintStyle: GoogleFonts.kantumruyPro(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Image source link
            const SizedBox(height: 10.0),
            TextFormField(
              controller: _imageSource,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.purple.withOpacity(.1),
                hintText: 'Image source link (Optional)',
                hintStyle: GoogleFonts.kantumruyPro(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Article source link
            const SizedBox(height: 10.0),
            TextFormField(
              controller: _articleSource,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.purple.withOpacity(.1),
                hintText: 'Article source link (Optional)',
                hintStyle: GoogleFonts.kantumruyPro(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 15.0),
            ElevatedButton(
              onPressed: () async {
                // Loading
                setState(() => isPosting = true);
                await userPost().whenComplete(
                  () => setState(() => isPosting = false),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                fixedSize: Size(MediaQuery.of(context).size.width, 50.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: isPosting
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LoadingAnimationWidget.fourRotatingDots(
                          color: Colors.white,
                          size: 40.0,
                        ),
                        const SizedBox(width: 5.0),
                        Text(
                          'Posting',
                          style: GoogleFonts.kantumruyPro(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      'Post',
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
  }
}
