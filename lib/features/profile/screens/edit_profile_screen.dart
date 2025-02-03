import 'package:chatter_hive/data/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = '/edit-profile';

  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    if (_nameController.text.isEmpty) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.updateProfile(
      name: _nameController.text,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            final user = authProvider.user;

            // Update the text field with the user's current name
            if (user != null && _nameController.text != user.name) {
              _nameController.text = user.name;
            }

            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    // Logic for picking an image
                  },
                  child: const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('images/profile-icon.jpg')
                            as ImageProvider,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveProfile,
                  child: const Text('Save Changes'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
