// lib/providers/chat_provider.dart

import 'package:flutter/material.dart';
import '../models/chat_model.dart';
import '../repositories/chat_repository.dart';

class ChatProvider with ChangeNotifier {
  final ChatRepository _chatRepository = ChatRepository();

  List<Chat> _chats = [];
  List<Chat> get chats => _chats;

  // Fetch chats for a user
  Future<void> fetchChats(String userId) async {
    try {
      final fetchedChats = await _chatRepository.getChats(userId);
      _chats = fetchedChats;
      notifyListeners();
    } catch (e) {
      print('Error fetching chats in provider: $e');
    }
  }

  // Send a message to a chat
  Future<void> sendMessage(String chatId, String text, String userId) async {
    try {
      await _chatRepository.sendMessage(chatId, text, userId);
      // Optionally, fetch updated chats after sending a message
      await fetchChats(userId);
    } catch (e) {
      print('Error sending message in provider: $e');
    }
  }

  // Get a specific chat by its ID
  Future<Chat?> getChatById(String chatId) async {
    return await _chatRepository.getChatById(chatId);
  }
}
