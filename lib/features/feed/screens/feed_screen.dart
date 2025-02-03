import 'package:chatter_hive/data/models/post_model.dart';
import 'package:chatter_hive/data/models/user_model.dart';
import 'package:chatter_hive/data/providers/post_provider.dart';
import 'package:chatter_hive/theme/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/post_card.dart';
import '../widgets/post_input.dart'; // Add this new widget

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final ScrollController _scrollController = ScrollController();

  void _refreshFeed() {
    Provider.of<PostProvider>(context, listen: false).getPostsStream();
    _scrollController.animateTo(
      0.0, // Scroll to top
      duration: const Duration(milliseconds: 600), // Smooth animation
      curve: Curves.easeOut,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextButton(
          onPressed: _refreshFeed,
          child: const Text(
            "ChatHive",
            style: AppThemeData.appBarTitleTextStyle,
          ),
        ),
        centerTitle: false,
      ),
      body: StreamBuilder<List<PostModel>>(
        stream:
            Provider.of<PostProvider>(context, listen: false).getPostsStream(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error occurred!'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No posts yet!'));
          }

          // Update the provider's posts list
          Provider.of<PostProvider>(context, listen: false)
              .updatePosts(snapshot.data!);

          return Consumer<PostProvider>(
            builder: (ctx, postProvider, _) => Column(
              children: [
                const PostInput(),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController, 
                    itemCount: postProvider.posts.length,
                    itemBuilder: (ctx, index) {
                      final post = postProvider.posts[index];
                      if (postProvider.users.isNotEmpty) {
                        final user = postProvider.users.firstWhere(
                          (user) => user.uid == post.userId,
                          orElse: () => UserModel(
                            uid: 'uid',
                            name: 'name',
                            email: 'email',
                          ),
                        );
                        return PostCard(
                          key: Key(post.postId!),
                          post: post,
                          user: user,
                        );
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
