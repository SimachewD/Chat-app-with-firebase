import 'package:flutter/material.dart';
import '../models/comment_model.dart';
import '../repositories/comment_repository.dart';

class CommentProvider with ChangeNotifier {
  final CommentRepository _commentRepository = CommentRepository();
  final Map<String, List<CommentModel>> _postComments = {};

  List<CommentModel> getComments(String postId) => _postComments[postId] ?? [];

  // Fetch comments for a specific post
  Future<void> fetchComments(String postId) async {
    final comments = await _commentRepository.getComments(postId);
    _postComments[postId] = comments;
    notifyListeners();
  }

  // Send a new message
  Future<void> sendMessage(CommentModel comment) async {
    await _commentRepository.sendMessage(comment);
    _postComments.putIfAbsent(comment.postId, () => []).add(comment);
    notifyListeners();
  }
}
