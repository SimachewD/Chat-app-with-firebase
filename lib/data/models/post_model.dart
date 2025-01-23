import 'package:chatter_hive/data/models/comment_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String? postId;
  final String userId;
  final String caption;
  final String? imageUrl;
  final List<String> likes;
  final List<CommentModel> comments;
  final Timestamp? timestamp;

  PostModel({
    this.postId,
    required this.userId,
    required this.caption,
    this.imageUrl,
    required this.likes,
    required this.comments,
    this.timestamp,
  });

  // Convert Firebase document to PostModel
  factory PostModel.fromDocument(DocumentSnapshot doc) {
    return PostModel(
      postId: doc.id,
      userId: doc['userId'] ?? '',
      caption: doc['caption'] ?? '',
      imageUrl: doc['imageUrl'] ?? '',
      likes: List<String>.from(doc['likes'] ?? []),
      comments: List<CommentModel>.from(doc['comments'] ?? []),
      timestamp: doc['timestamp'] ?? Timestamp.now(),
    );
  }

  // Convert PostModel to a map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'userId': userId,
      'caption': caption,
      'imageUrl': imageUrl,
      'likes': likes,
      'comments': comments,
      'timestamp': Timestamp.now(),
    };
  }
}
