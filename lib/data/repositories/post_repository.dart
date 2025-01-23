import 'package:chatter_hive/data/models/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new post
  Future<void> createPost(PostModel post) async {
    try {
      await _firestore.collection('posts').add(post.toMap());
    } catch (e) {
      print('Error creating post: $e');
    }
  }

  // Fetch all posts
  Future<List<PostModel>> getPosts() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('posts').orderBy('timestamp', descending: true).get();
      return querySnapshot.docs
          .map((doc) => PostModel.fromDocument(doc))
          .toList();
    } catch (e) {
      print('Error fetching posts: $e');
      return [];
    }
  }

  // Delete a post
  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print('Error deleting post: $e');
    }
  }
}
