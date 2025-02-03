import 'package:chatter_hive/data/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../repositories/chat_repository.dart';

class ChatProvider with ChangeNotifier {
  final ChatRepository _chatRepository = ChatRepository();
  final AuthProvider _authProvider;

  ChatProvider(this._authProvider);

  List<Chat> _chats = [];
  List<Chat> get chats => _chats;

  List<Message> _messages = [];
  List<Message> get messages => _messages;

  String get currentUserId => _authProvider.user?.uid ?? '';

  Stream<List<Chat>> getChatsStream() {
    return _chatRepository.getChatsStream(currentUserId);
  }

  void updateChats(List<Chat> newChats) {
    _chats = newChats;
    // notifyListeners();
  }

  Stream<List<Message>> getMessagesStream(String chatId) {
    return _chatRepository.getMessagesStream(chatId);
  }

  void updateMessages(List<Message> newMessages) {
    _messages = newMessages;
    // notifyListeners();
  }

  Future<void> markMessageAsRead(String chatId, String messageId) async {
  try {
    await _chatRepository.markMessageAsRead(chatId, messageId);
    notifyListeners(); // Update UI after marking messages as read
  } catch (e) {
    print('Error marking messages as read: $e');
  }
}


  // Future<void> fetchMessages(String chatId) async {
  //   try {
  //     final fetchedMessages = await _chatRepository.getMessages(chatId);
  //     _messages = fetchedMessages;
  //     notifyListeners();
  //   } catch (e) {
  //     print('Error fetching messages in provider: $e');
  //   }
  // }

  Future<void> sendMessage(String chatId, String text) async {
    try {
      await _chatRepository.sendMessage(chatId, text, currentUserId);
      // await fetchMessages(chatId);
      // await fetchChats();
    } catch (e) {
      print('Error sending message in provider: $e');
    }
  }

  Future<String> createChat(String uid) async {
    String chatId = await _chatRepository.createChat(uid, currentUserId);
    // await fetchChats();
    // notifyListeners();
    return chatId;
  }
}
