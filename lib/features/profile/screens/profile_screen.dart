import 'package:chatter_hive/data/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'edit_profile_screen.dart';
import '../widgets/profile_picture.dart';
import '../widgets/stats_display.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ProfilePicture(imageUrl: user?.photoUrl),
            const SizedBox(height: 20),
            Text(user?.name ?? "User Name",
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 10),
            StatsDisplay(userId: user?.uid ?? ''),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProfileScreen.routeName);
              },
              child: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
