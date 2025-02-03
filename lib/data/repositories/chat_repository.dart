import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Chat>> getChats(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('chats')
          .where('usersId', arrayContains: userId)
          .get();
      return querySnapshot.docs.map((doc) => Chat.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching chats: $e');
      return [];
    }
  }

  Future<Chat?> getChatById(String chatId) async {
    try {
      final docSnapshot =
          await _firestore.collection('chats').doc(chatId).get();

      if (docSnapshot.exists) {
        return Chat.fromFirestore(docSnapshot);
      }
      return null;
    } catch (e) {
      print('Error fetching chat: $e');
      return null;
    }
  }

  // Future<List<Message>> getMessages(String chatId) async {
  //   try {
  //     final querySnapshot = await _firestore
  //         .collection('chats')
  //         .doc(chatId)
  //         .collection('messages')
  //         .orderBy('timestamp')
  //         .get();

  //     return querySnapshot.docs
  //         .map((doc) => Message.fromFirestore(doc))
  //         .toList();
  //   } catch (e) {
  //     print('Error fetching messages: $e');
  //     return [];
  //   }
  // }

  Future<void> sendMessage(String chatId, String text, String senderId) async {
    try {
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
        'text': text,
        'senderId': senderId,
        'isRead':false,
        'timestamp': FieldValue.serverTimestamp(),
      });

      await _firestore.collection('chats').doc(chatId).update({
        'lastMessage': {
                        'text': text,
                        'senderId': senderId,
                        'isRead': false,
                        'timestamp': FieldValue.serverTimestamp(),
                      },
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  Future<String> createChat(String uid, String currentUserId) async {
    // Reference to the 'chats' collection
    final chatCollection = _firestore.collection('chats');

    // Query Firestore to check if a chat already exists
    final querySnapshot = await chatCollection
        .where('usersId', arrayContains: currentUserId)
        .get();

    // Check if a chat exists with the specific pair of users
    for (var doc in querySnapshot.docs) {
      final usersId = List<String>.from(doc['usersId']);
      if (usersId.contains(uid)) {
        // Return the existing chat's ID
        return doc.id;
      }
    }

    // If no chat exists, create a new one
    final newChat = Chat(usersId: [uid, currentUserId]);
    final newChatRef = await chatCollection.add(newChat.toFirestore());

    // Return the new chat's ID
    return newChatRef.id;
  }

  Stream<List<Chat>> getChatsStream(String userId) {
    return FirebaseFirestore.instance
        .collection('chats')
        .where('usersId', arrayContains: userId)
        .orderBy('lastUpdated', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Chat.fromFirestore(doc)).toList());
  }

  Stream<List<Message>> getMessagesStream(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Message.fromFirestore(doc)).toList();
    });
  }

  Future <void> markMessageAsRead(String chatId, String messageId) async{
    _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .update({'isRead': true});

    _firestore
        .collection('chats')
        .doc(chatId)
        .update({
        'lastMessage.isRead': true,
      });    
  }
}
