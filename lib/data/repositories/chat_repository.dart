// lib/repositories/chat_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_model.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch list of chats for a specific user
  Future<List<Chat>> getChats(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('chats')
          .where('users', arrayContains: userId)
          .get();

      return querySnapshot.docs
          .map((doc) => Chat.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching chats: $e');
      return [];
    }
  }

  // Fetch a specific chat by its ID
  Future<Chat?> getChatById(String chatId) async {
    try {
      final docSnapshot = await _firestore.collection('chats').doc(chatId).get();

      if (docSnapshot.exists) {
        return Chat.fromMap(docSnapshot.data()!);
      }
      return null;
    } catch (e) {
      print('Error fetching chat: $e');
      return null;
    }
  }

  // Send a new message to a chat
  Future<void> sendMessage(String chatId, String text, String userId) async {
    try {
      await _firestore.collection('chats').doc(chatId).collection('messages').add({
        'sender_id': userId,
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Update the last message in the chat
      await _firestore.collection('chats').doc(chatId).update({
        'last_message': text,
        'last_message_time': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error sending message: $e');
    }
  }
}
