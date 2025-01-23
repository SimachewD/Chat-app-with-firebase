import 'package:chatter_hive/data/providers/auth_provider.dart';
import 'package:chatter_hive/data/providers/post_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LikeButton extends StatefulWidget {
  final String postId;

  const LikeButton({super.key, required this.postId});

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _checkIfLiked();
  }

  void _checkIfLiked() {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final userId = authProvider.user!.uid;
    // Find the post with the matching postId
    final post = postProvider.posts.firstWhere((post) => post.postId == widget.postId);

    
      setState(() {
        _isLiked = post.likes.contains(userId);
      });
  }

  void _toggleLike() async {
    setState(() {
      _isLiked = !_isLiked;
    });

    await Provider.of<PostProvider>(context, listen: false).toggleLike(context, widget.postId, _isLiked);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(_isLiked ? Icons.favorite : Icons.favorite_border),
      color: _isLiked ? Colors.red : Colors.grey,
      onPressed: _toggleLike,
    );
  }
}
