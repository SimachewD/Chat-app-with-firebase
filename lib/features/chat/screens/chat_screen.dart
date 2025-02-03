import 'package:chatter_hive/data/models/message_model.dart';
import 'package:chatter_hive/data/providers/auth_provider.dart';
import 'package:chatter_hive/data/providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/chat_input.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String userName;

  const ChatScreen({super.key, required this.chatId, required this.userName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Listen for when messages are updated to scroll to the bottom or first unread message
  }

  // Function to scroll to the bottom of the chat
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent * 2,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // Function to scroll to the first unread message
  void _scrollToFirstUnread() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final messages = chatProvider.messages;
      final currentUserId = authProvider.user?.uid; // Ensure current user is retrieved

      if (messages.isEmpty || currentUserId == null || !_scrollController.hasClients) return;

      int unreadIndex = messages.indexWhere(
        (msg) => !msg.isRead && msg.senderId != currentUserId,
      );

      if (unreadIndex != -1) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent - (unreadIndex*3.5),
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      } else {
        _scrollToBottom();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
                stream: Provider.of<ChatProvider>(context, listen: false)
                    .getMessagesStream(widget.chatId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return const Center(child: Text('Error occurred!'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('No messages yet! Say hello'));
                  }

                  // Update the provider's Chat list
                  Provider.of<ChatProvider>(context, listen: false)
                      .updateMessages(snapshot.data!);
                  final chatProvider =
                      Provider.of<ChatProvider>(context, listen: false);

                  final messages = chatProvider.messages;

                  return Consumer<AuthProvider>(
                    builder: (context, authProvider, _) {
                      if (messages.isNotEmpty) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _scrollToFirstUnread();
                        });
                      }
                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: messages.length,
                        itemBuilder: (ctx, index) {
                          final message = messages[index];
                          return MessageBubble(
                            chatId: widget.chatId,
                            messageId: message.id!,
                            message: message.text,
                            isMe: message.senderId == authProvider.user!.uid,
                            isRead: message.isRead,
                          );
                        },
                      );
                    },
                  );
                }),
          ),
          ChatInput(
            chatId: widget.chatId,
            onMessageSent: () {
              Future.delayed(const Duration(milliseconds: 100), () {
                _scrollToBottom();
              });
            },
          ),
        ],
      ),
    );
  }
}
