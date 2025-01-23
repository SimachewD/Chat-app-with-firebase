import 'package:chatter_hive/core/constants/app_colors.dart';
import 'package:chatter_hive/data/models/post_model.dart';
import 'package:chatter_hive/data/providers/auth_provider.dart';
import 'package:chatter_hive/data/providers/post_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostInput extends StatefulWidget {
  const PostInput({super.key});

  @override
  State<PostInput> createState() => _PostInputState();
}

class _PostInputState extends State<PostInput> {
  final _controller = TextEditingController();
  String? _userPhotoUrl;  // Store the user's photo URL
  bool isLoading = false;
  bool isTextValid = false; // State to track if the text field has input

  @override
  void initState() {
    super.initState();

    // Listen for changes in the text field
    _controller.addListener(() {
      setState(() {
        isTextValid = _controller.text.trim().isNotEmpty; // Validate input
      });
    });
  }

  void _submitPost() async {
    setState(() {
      isLoading = true; // Start loading
    });

    final caption = _controller.text.trim();
    if (caption.isEmpty) return;

    // Get the userId from AuthProvider
    final userId = Provider.of<AuthProvider>(context, listen: false).user!.uid;
    final newPost = PostModel(
      userId: userId,
      caption: caption,
      likes: [],
      comments: [],
      timestamp: Timestamp.now(),
    );

    try {
      await Provider.of<PostProvider>(context, listen: false).createPost(newPost);
      _controller.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error posting: Try again later')),
      );
    } finally{
      setState(() {
      isLoading = false; // stop loading
    });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: _userPhotoUrl != null
                    ? NetworkImage(_userPhotoUrl!) // Load from Firebase if available
                    : const AssetImage('/images/profile-icon.jpg') as ImageProvider, // Default profile icon
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 35,  // Set maximum height
                    maxWidth: 200,  // Set maximum width
                  ),
                  child: TextField(
                    enabled: !isLoading,
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "What's on your mind?",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24), // More radius for rounded corners
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15), // Adjust padding for height
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: (isLoading || !isTextValid) ? null : _submitPost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonColor, // Custom color
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  foregroundColor: Colors.white,
                ),
                child: isLoading ? const Text('Posting...') : const Text('Post'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
