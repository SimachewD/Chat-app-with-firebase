// lib/chat/screens/chat_list_screen.dart

import 'package:chatter_hive/data/providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/message_bubble.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch chats when the screen is first loaded
    const userId = "example_user_id"; // Replace with actual user ID
    Provider.of<ChatProvider>(context, listen: false).fetchChats(userId);
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final chats = chatProvider.chats;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (ctx, index) {
          return MessageBubble(
            isMe: true,
            message: chats[index].lastMessage,
          );
        },
      ),
    );
  }
}
