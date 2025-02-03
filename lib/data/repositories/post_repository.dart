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

  // Edit post
  Future<void> editPost(String newCaption, String postId) async {
    try {
      // Ensure the post has a valid ID before updating
      if ( postId.isEmpty) {
        throw Exception('Post ID is required to edit the post.');
      }

      // Update the post document in Firestore
      await _firestore.collection('posts').doc(postId).update({
        'caption': newCaption
      });
      print('Post updated successfully');
    } catch (e) {
      print('Error updating post: $e');
    }
  }


  // Fetch all posts
  Stream<List<PostModel>> getPostsStream() {
    return FirebaseFirestore.instance
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PostModel.fromDocument(doc))
            .toList());
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
