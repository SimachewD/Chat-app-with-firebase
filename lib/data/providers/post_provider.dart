import 'package:chatter_hive/data/models/user_model.dart';
import 'package:chatter_hive/data/providers/auth_provider.dart';
import 'package:chatter_hive/data/repositories/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/post_model.dart';
import '../repositories/post_repository.dart';

class PostProvider with ChangeNotifier {
  final PostRepository _postRepository = PostRepository();
  final AuthRepository _authRepository = AuthRepository();
  List<PostModel> _posts = [];
  List<UserModel> _users = [];

  List<PostModel> get posts => _posts;
  List<UserModel> get users => _users;

  // Fetch all users
  Future<void> fetchUsers() async {
    _users = (await _authRepository.getUser())!;
    notifyListeners();
  }

  // Create a new post
  Future<void> createPost(PostModel post) async {
    await _postRepository.createPost(post);
    // await fetchPosts(); // Refetch posts to include the new post
  }

  // Create a new post
  Future<void> editPost(String newCaption, String postId) async {
    await _postRepository.editPost(newCaption, postId);
    // await fetchPosts(); // Refetch posts to include the new post
  }

  // Delete a post
  Future<void> deletePost(String postId) async {
    await _postRepository.deletePost(postId);
    // _posts.removeWhere((post) => post.postId == postId);
    // notifyListeners();
  }

  Future<void> toggleLike(
      BuildContext context, String postId, bool isLiked) async {
    try {
      final user = Provider.of<AuthProvider>(context, listen: false).user;
      final postRef =
          FirebaseFirestore.instance.collection('posts').doc(postId);

      if (!isLiked) {
        // Remove the user from the likes array
        await postRef.update({
          'likes': FieldValue.arrayRemove([user!.uid]),
        });
        // _posts
        //     .firstWhere((post) => post.postId == postId)
        //     .likes
        //     .remove(user.uid);
        // notifyListeners();
      } else {
        // Add the user to the likes array
        await postRef.update({
          'likes': FieldValue.arrayUnion([user!.uid]),
        });
        // _posts.firstWhere((post) => post.postId == postId).likes.add(user.uid);
        // notifyListeners();
      }
    } catch (e) {
      debugPrint('Error toggling like: $e');
    }
  }

  findPostById(String postId) {}

  Stream<List<PostModel>> getPostsStream() {
    return _postRepository.getPostsStream();
  }

  void updatePosts(List<PostModel> newPosts) async{
    _posts = newPosts;
    _users = (await _authRepository.getUser())!;
    notifyListeners();
  }

}
