import 'package:chatter_hive/data/models/chat_model.dart';
import 'package:chatter_hive/data/providers/auth_provider.dart';
import 'package:chatter_hive/data/providers/chat_provider.dart';
import 'package:chatter_hive/data/repositories/auth_repository.dart';
import 'package:chatter_hive/features/chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/chat_list_tile.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  void _showUserList(BuildContext context) {
    // Access the list of users from the AuthProvider
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final users = authProvider.users
        .where((user) => user.uid != AuthRepository().getCurrentUser()?.uid)
        .toList();

    showModalBottomSheet(
      context: context,
      builder: (ctx) => ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: users.length,
        itemBuilder: (ctx, index) => Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage('/images/profile-icon.jpg'),
            ),
            title: Text(users[index].name),
            onTap: () async {
              // Logic to create or fetch a chat ID with the selected user
              final chatId =
                  await Provider.of<ChatProvider>(context, listen: false)
                      .createChat(users[index].uid);
          
              Navigator.pop(context); // Close the modal
          
              // Navigate to the ChatScreen with the created chatId
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    chatId: chatId,
                    userName: users[index].name,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Chat>>(
          stream: Provider.of<ChatProvider>(context, listen: false)
              .getChatsStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              print(snapshot.error);
              return Center(child: Text(snapshot.error.toString()));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No chats yet!'));
            }

            // Update the provider's Chat list
            Provider.of<ChatProvider>(context, listen: false)
                .updateChats(snapshot.data!);
            final chatProvider =
                Provider.of<ChatProvider>(context, listen: false);

            return ListView.builder(
              itemCount: chatProvider.chats.length,
              itemBuilder: (ctx, index) {
                final chat = chatProvider.chats[index];
                return ChatListTile(
                  chat: chat,
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUserList(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
