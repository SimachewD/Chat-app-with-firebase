import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String? commentId;
  final String postId;
  final String userId;
  final String text;
  final Timestamp? timestamp;

  CommentModel({
    this.commentId,
    required this.postId,
    required this.userId,
    required this.text,
    this.timestamp,
  });

  // Convert Firebase document to CommentModel
  factory CommentModel.fromDocument(DocumentSnapshot doc) {
    return CommentModel(
      commentId: doc.id,
      postId: doc['postId'] ?? '',
      userId: doc['userId'] ?? '',
      text: doc['text'] ?? '',
      timestamp: doc['timestamp'] ?? Timestamp.now(),
    );
  }

  // Convert CommentModel to a map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'userId': userId,
      'text': text,
      'timestamp': Timestamp.now(),
    };
  }
}
