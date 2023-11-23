import 'package:cloud_firestore/cloud_firestore.dart';

class BlogModel {
  Timestamp blogID;
  String blogImage;
  String blogTitle;
  String blogDescription;
  String imageSource;
  String articleSource;
  bool isFavorite;

  BlogModel({
    required this.blogID,
    required this.blogImage,
    required this.blogTitle,
    required this.blogDescription,
    required this.imageSource,
    required this.articleSource,
    required this.isFavorite,
  });

  Map<String, dynamic> toMap() {
    return {
      'blog_id': blogID,
      'blog_image': blogImage,
      'blog_title': blogTitle,
      'blog_description': blogDescription,
      'image_source': imageSource,
      'article_source': articleSource,
      'isFavorite': isFavorite,
    };
  }

  BlogModel.fromDucumentSnapshot(DocumentSnapshot ref)
      : blogID = ref['blog_id'],
        blogImage = ref['blog_image'],
        blogTitle = ref['blog_title'],
        blogDescription = ref['blog_description'],
        imageSource = ref['image_source'],
        articleSource = ref['article_source'],
        isFavorite = ref['isFavorite'];
}
