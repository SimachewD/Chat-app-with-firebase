// lib/models/message.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String? id; // Firestore document ID for the message
  final String text; // Message content
  final String senderId; // User ID of the sender
  final Timestamp? timestamp; // When the message was sent
  final bool isRead;

  Message({
    this.id,
    required this.text,
    required this.senderId,
    this.timestamp,
    required this.isRead
  });

  // Convert Firestore data to a Message object
  factory Message.fromFirestore(DocumentSnapshot message) {
    return Message(
      id: message.id,
      text: message['text'],
      senderId: message['senderId'],
      timestamp: (message['timestamp']) ?? Timestamp.now(),
      isRead: message['isRead'] ?? false, // Default to false if not present
    );
  }

  // Convert Firestore data to a Message object
  factory Message.partialFromFirestore(Map<String, dynamic> data) {
    return Message(
      id: data['id'],
      text: data['text'] ?? '',
      senderId: data['senderId'] ?? '',
      isRead: data['isRead'] ?? false,
    );
  }

  // Convert a Message object to Firestore data
  Map<String, dynamic> toFirestore() {
    return {
      'text': text,
      'senderId': senderId,
    };
  }
}
