import 'package:chatter_hive/data/providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageBubble extends StatefulWidget {
  final String chatId;
  final String messageId;
  final String message;
  final bool isMe;
  final bool isRead;

  const MessageBubble({
    super.key,
    required this.chatId,
    required this.messageId,
    required this.message,
    required this.isMe,
    required this.isRead,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  void initState() {
    super.initState();
    if (!widget.isMe && !widget.isRead) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<ChatProvider>(context, listen: false)
            .markMessageAsRead(widget.chatId, widget.messageId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Align(
        alignment: widget.isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          child: IntrinsicWidth(
            stepWidth: 24,
            child: Container(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              decoration: BoxDecoration(
                color: widget.isMe ? Colors.blueAccent : Colors.grey[200],
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: widget.isMe
                        ? Colors.blue.withAlpha(102)
                        : Colors.grey.withAlpha(102),
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      widget.message,
                      style: TextStyle(
                        color: widget.isMe ? Colors.white : Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      softWrap: true,
                    ),
                  ),
                  if (widget.isMe)
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Icon(
                        widget.isRead ? Icons.done_all : Icons.check,
                        size: 18,
                        color: widget.isRead ? Colors.blue[900] : Colors.grey[800],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
