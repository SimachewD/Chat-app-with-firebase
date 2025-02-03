import 'package:chatter_hive/data/models/comment_model.dart';
import 'package:chatter_hive/data/models/post_model.dart';
import 'package:chatter_hive/data/models/user_model.dart';
import 'package:chatter_hive/data/providers/auth_provider.dart';
import 'package:chatter_hive/data/providers/comment_provider.dart';
import 'package:chatter_hive/data/providers/post_provider.dart';
import 'package:chatter_hive/data/repositories/auth_repository.dart';
import 'package:chatter_hive/features/feed/widgets/like_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final PostModel post;
  final UserModel user;

  const PostCard({super.key, required this.post, required this.user});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isCommentsExpanded = false;
  bool isLoading = false;
  final AuthRepository _authRepository = AuthRepository();
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<CommentProvider>(context, listen: false)
        .fetchComments(widget.post.postId!);
    Provider.of<AuthProvider>(context, listen: false).getUser();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info (Poster)
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: widget.user.photoUrl!.isNotEmpty
                      ? NetworkImage(widget.user.photoUrl!)
                      : const AssetImage('/images/profile-icon.jpg')
                          as ImageProvider,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.user.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      // Show the edit dialog
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          // Create a TextEditingController with the existing content
                          TextEditingController contentController =
                              TextEditingController(text: widget.post.caption);

                          return AlertDialog(
                            title: const Text('Edit Post'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: contentController,
                                  decoration: const InputDecoration(
                                    labelText: 'Post Content',
                                    border: OutlineInputBorder(),
                                  ),
                                  maxLines: 3,
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: const Text('Cancel'),
                              ),
                               StatefulBuilder(
                                builder: (context, setState) {
                                  return TextButton(
                                    onPressed: !isLoading
                                        ? () async {
                                            try {
                                              setState(() {
                                                isLoading = true; // start loading
                                              });

                                              if (value == 'edit') {
                                                await Provider.of<PostProvider>(context,
                                                        listen: false)
                                                    .editPost(contentController.text, widget.post.postId!);
                                                contentController.clear();
                                              } else if (value == 'delete') {
                                                await Provider.of<PostProvider>(context,
                                                        listen: false)
                                                    .deletePost(widget.post.postId!);
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Error: Try again later')),
                                              );
                                            } finally {
                                              setState(() {
                                                isLoading = false; // stop loading
                                              });
                                            }

                                            Navigator.of(context).pop(); // Close the dialog
                                          }
                                        : null,
                                    child: isLoading
                                        ? const Text('Updating...') // Show loading state text
                                        : const Text('Update'), // Normal button text
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else if (value == 'delete') {
                      // Show the delete confirmation dialog
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Delete Post'),
                            content: const Text(
                                'Are you sure you want to delete this post?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: const Text('Cancel'),
                              ),
                              StatefulBuilder(
                                builder: (context, setState) {
                                  return TextButton(
                                    onPressed: isLoading ? null : () async{
                                      // Perform the delete action
                                      try {
                                        setState(() {
                                          isLoading = true; // start loading
                                        });
                                        await Provider.of<PostProvider>(context,
                                                listen: false)
                                            .deletePost(widget.post.postId!);
                                      } catch (e) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Error deleting: Try again later')),
                                        );
                                      } finally {
                                        setState(() {
                                          isLoading = false; // stop loading
                                        });
                                      }
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                    child: isLoading ? const Text('Deleting...'): const Text('Delete'),
                                  );
                                }
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return widget.user.uid == _authRepository.getCurrentUser()!.uid ? [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ] : [];
                  },
                  icon: const Icon(Icons.more_vert)
                )
              ],
            ),
            const SizedBox(height: 10),
            // Caption
            Text(
              widget.post.caption,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            // Social Actions (Likes and Comments)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    LikeButton(postId: widget.post.postId!),
                    const SizedBox(width: 5),
                    Text(
                      '${widget.post.likes.length}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isCommentsExpanded = !isCommentsExpanded;
                        });
                      },
                      icon: Icon(
                        isCommentsExpanded
                            ? Icons.expand_less
                            : Icons.comment_outlined,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Consumer<CommentProvider>(
                      builder: (context, provider, _) => Text(
                        '${provider.getComments(widget.post.postId!).length}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (isCommentsExpanded)
              Column(
                children: [
                  Consumer<CommentProvider>(
                    builder: (BuildContext context,
                        CommentProvider commentProvider, Widget? child) {
                      if (commentProvider
                          .getComments(widget.post.postId!)
                          .isEmpty) {
                        return const Center(
                          child: Text('No comments yet.'),
                        );
                      }

                      return Container(
                        height: 200,
                        decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(width: 0.5)),
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 60),
                          itemCount: commentProvider
                              .getComments(widget.post.postId!)
                              .length,
                          itemBuilder: (context, index) {
                            final comment = commentProvider
                                .getComments(widget.post.postId!)[index];
                            final user = Provider.of<AuthProvider>(context,
                                    listen: false)
                                .users
                                .firstWhere(
                                    (user) => user.uid == comment.userId);
                            return ListTile(
                              title: Text(
                                user.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(comment.text),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  // Comment Input
                  SafeArea(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _commentController,
                              decoration: const InputDecoration(
                                hintText: 'Write a comment...',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () async {
                              if (_commentController.text.isNotEmpty) {
                                final currentUser =
                                    AuthRepository().getCurrentUser();
                                try {
                                  await Provider.of<CommentProvider>(context,
                                          listen: false)
                                      .sendMessage(
                                    CommentModel(
                                      postId: widget.post.postId!,
                                      userId: currentUser!.uid,
                                      text: _commentController.text,
                                    ),
                                  );
                                  _commentController.clear();
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error: $e'),
                                    ),
                                  );
                                }
                              }
                            },
                            icon: const Icon(Icons.send),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
