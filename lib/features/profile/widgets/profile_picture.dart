import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  final String? imageUrl;

  const ProfilePicture({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 80,
      backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
          ? NetworkImage(imageUrl!)
          : const AssetImage('images/profile-icon.jpg') as ImageProvider,
    );
  }
}
