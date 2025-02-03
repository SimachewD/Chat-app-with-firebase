
import 'package:chatter_hive/data/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Chat {
  final String? chatId; // Firestore document ID for the chat
  final List<String> usersId; // ID of the users
  final Message? lastMessage; // Preview of the last message
  final Timestamp? lastUpdated; // Timestamp of the last message

  Chat({
    this.chatId,
    required this.usersId,
    this.lastMessage,
    this.lastUpdated,
  });

  // Convert Firestore data to a Chat object
  factory Chat.fromFirestore(DocumentSnapshot chat) {
    return Chat(
      chatId: chat.id,
      usersId: List<String>.from(chat['usersId']),
      lastMessage: chat['lastMessage'] != null
        ? Message.partialFromFirestore(chat['lastMessage'])
        : null,
      lastUpdated: chat['lastUpdated']??Timestamp.now(),
    );
  }

  // Convert a Chat object to Firestore data
  Map<String, dynamic> toFirestore() {
    return {
      'usersId': usersId,
      'lastMessage': lastMessage,
      'lastUpdated': lastUpdated,
    };
  }
}
