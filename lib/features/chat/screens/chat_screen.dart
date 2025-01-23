// lib/chat/screens/chat_screen.dart

import 'package:chatter_hive/data/providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/chat_input.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;

  const ChatScreen({super.key, required this.chatId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch messages for the specific chat when the screen is loaded
    // final userId = "example_user_id"; // Replace with actual user ID
    Provider.of<ChatProvider>(context, listen: false).getChatById(widget.chatId);
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final chat = chatProvider.chats.firstWhere((chat) => chat.chatId == widget.chatId);

    return Scaffold(
      appBar: AppBar(
        title: Text(chat.chatName),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Placeholder: Replace with actual messages from Firebase
              itemBuilder: (ctx, index) {
                return MessageBubble(message: "Message $index", isMe: index % 2 == 0);
              },
            ),
          ),
          ChatInput(chatId: widget.chatId),
        ],
      ),
    );
  }
}
