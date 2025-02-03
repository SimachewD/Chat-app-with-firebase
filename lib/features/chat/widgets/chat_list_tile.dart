import 'package:chatter_hive/data/models/chat_model.dart';
import 'package:chatter_hive/data/models/message_model.dart';
import 'package:chatter_hive/data/models/user_model.dart';
import 'package:chatter_hive/data/providers/auth_provider.dart';
import 'package:chatter_hive/data/providers/chat_provider.dart';
import 'package:chatter_hive/features/chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatListTile extends StatefulWidget {
  final Chat chat;

  const ChatListTile({
    super.key,
    required this.chat,
  });

  @override
  State<ChatListTile> createState() => _ChatListTileState();
}

class _ChatListTileState extends State<ChatListTile> {
  late AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (_authProvider.users.isEmpty) {
      _authProvider.getUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final currentUser = authProvider.user;
        final users = authProvider.users;
        final chatterId = widget.chat.usersId.firstWhere(
          (userId) => userId != currentUser!.uid,
          orElse: () => '',
        );

        final username = users
            .firstWhere(
              (user) => user.uid == chatterId,
              orElse: () => UserModel(name: 'Unknown', uid: '', email: ''),
            )
            .name;

        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            leading: const CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage('images/profile-icon.jpg'),
            ),
            title: Text(
              username,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.chat.lastMessage?.text ?? 'Say Hello',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
                if (widget.chat.lastMessage != null &&
                    widget.chat.lastMessage!.senderId == currentUser!.uid)
                  Icon(
                    widget.chat.lastMessage!.isRead
                        ? Icons.done_all
                        : Icons.check,
                    size: 18,
                    color: widget.chat.lastMessage!.isRead
                        ? Colors.blue[900]
                        : Colors.grey[800],
                  ),
              ],
            ),
            trailing: StreamBuilder<List<Message>>(
              stream: Provider.of<ChatProvider>(context, listen: false)
                  .getMessagesStream(widget.chat.chatId!),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return const SizedBox(); // No messages yet
                }

                final unreadMessages = snapshot.data!
                    .where((msg) =>
                        msg.isRead == false && msg.senderId != currentUser!.uid)
                    .length;

                return unreadMessages > 0
                    ? Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          unreadMessages.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      )
                    : const SizedBox(); // No unread messages
              },
            ),
            onTap: () {
              // Navigate to the ChatScreen with the created chatId
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    chatId: widget.chat.chatId!,
                    userName: username,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
