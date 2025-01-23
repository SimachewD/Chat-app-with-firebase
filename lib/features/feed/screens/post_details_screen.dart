import 'package:chatter_hive/data/providers/post_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class PostDetailsScreen extends StatelessWidget {
  static const routeName = '/post-detail';

  const PostDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final postId = ModalRoute.of(context)!.settings.arguments as String;
    final post = Provider.of<PostProvider>(context).findPostById(postId);

    return Scaffold(
      appBar: AppBar(
        title: Text(post.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(post.content),
            const SizedBox(height: 20),
            Text('Posted by: ${post.authorName}'),
          ],
        ),
      ),
    );
  }
}
