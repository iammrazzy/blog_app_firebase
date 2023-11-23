class ContentModel {
  String image;
  String title;
  String description;

  ContentModel({
    required this.image,
    required this.title,
    required this.description,
  });
}

List<ContentModel> allContent = [
  ContentModel(
    title: 'Quality Image',
    image: 'images/Blog.png',
    description:
        'Quality images in my Blog app are essential for providing users'
        'with a clear and accurate understanding of the data,'
        'High-resolution images can help you to identify patterns and trends that would be difficult to see in lower-quality images.',
  ),
  ContentModel(
    title: 'Useful Inteface',
    image: 'images/Blog.png',
    description:
        'A useful interface in Blog app is one that is easy to use and navigate,'
        'and that makes it easy for users to find and read the content they are interested in.'
        'Some key features of a useful blog app interface.',
  ),
  ContentModel(
    title: 'More Support',
    image: 'images/Blog.png',
    description:
        'More support in a blog app can make a big difference in the user experience. By providing users with the support they need,'
        'blog app developers can help users to create and manage successful blogs.',
  ),
];
