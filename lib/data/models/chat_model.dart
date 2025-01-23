// lib/models/chat_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String chatId;
  final String chatName;
  final List<String> users;
  final String lastMessage;
  final DateTime lastMessageTime;

  Chat({
    required this.chatId,
    required this.chatName,
    required this.users,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  // Factory method to create Chat from Firestore data
  factory Chat.fromMap(Map<String, dynamic> data) {
    return Chat(
      chatId: data['chat_id'] ?? '',
      chatName: data['chat_name'] ?? '',
      users: List<String>.from(data['users'] ?? []),
      lastMessage: data['last_message'] ?? '',
      lastMessageTime: (data['last_message_time'] as Timestamp).toDate(),
    );
  }

  // Method to convert Chat to a map (for saving to Firestore)
  Map<String, dynamic> toMap() {
    return {
      'chat_id': chatId,
      'chat_name': chatName,
      'users': users,
      'last_message': lastMessage,
      'last_message_time': lastMessageTime,
    };
  }
}
