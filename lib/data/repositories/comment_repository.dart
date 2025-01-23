import 'package:chatter_hive/data/models/comment_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Send a new message (comment)
  Future<void> sendMessage(CommentModel comment) async {
    try {
      await _firestore.collection('comments').add(comment.toMap());
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  // Fetch all messages for a post
  Future<List<CommentModel>> getComments(String postId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('comments')
          .where('postId', isEqualTo: postId)
          .orderBy('timestamp', descending: true)
          .get();
      return querySnapshot.docs
          .map((doc) => CommentModel.fromDocument(doc))
          .toList();
    } catch (e) {
      print('Error fetching comments: $e');
      return [];
    }
  }
}
