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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<AuthProvider>(builder: (context, authProvider, _) {
          final user = authProvider.user;

          return Column(
            children: [
              ProfilePicture(imageUrl: user?.photoUrl),
              const SizedBox(height: 20),
              Text(user?.name ?? "User Name",
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 10),
              StatsDisplay(userId: user?.uid ?? ''),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10.0,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(EditProfileScreen.routeName);
                    },
                    child: const Text('Edit Profile'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                    onPressed: () async {
                      await authProvider.signOut();
                      Navigator.of(context).pushNamed('/');
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
