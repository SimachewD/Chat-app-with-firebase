import 'package:chatter_hive/data/models/user_model.dart';
import 'package:chatter_hive/data/providers/post_provider.dart';
import 'package:chatter_hive/theme/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/post_card.dart';
import '../widgets/post_input.dart'; // Add this new widget

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/');
            },
            child: const Text("Chat Hive",
                style: AppThemeData.appBarTitleTextStyle)),
      ),
      body: FutureBuilder(
        future: Provider.of<PostProvider>(context, listen: false).fetchPosts(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.error != null) {
            return const Center(child: Text('Error occurred!'));
          }

          return Consumer<PostProvider>(
            builder: (ctx, postProvider, _) => Column(
              children: [
                const PostInput(),
                postProvider.posts.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: postProvider.posts.length,
                          itemBuilder: (ctx, index) {
                            final post = postProvider.posts[index];

                            // Safely fetch user with a fallback
                            final user = postProvider.users.firstWhere(
                              (user) => user.uid == post.userId,
                              orElse: () => UserModel(uid: 'uid', name: 'name', email: 'email'), // Return null if no match is found
                            );
                            // Generate a unique key for each PostCard to avoid duplicate GlobalKey
                            final uniqueKey = Key('${post.postId}_$index');

                            return PostCard(
                              key: uniqueKey, // Use a unique key here
                              post: post,
                              user: user,
                            );
                          },
                        ),
                      )
                    : const Center(child: Text('No posts yet!')),
              ],
            ),
          );
        },
      ),
    );
  }
}
