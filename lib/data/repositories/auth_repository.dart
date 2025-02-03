import 'package:chatter_hive/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Sign in with email and password
  Future<dynamic> signInWithEmailPassword(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Handle specific errors
      switch (e.code) {
        case 'invalid-credential':
          return "Incorrect Email or Password.";
        case 'invalid-email':
          return "The email address is not valid.";
        default:
          return "Login failed: ${e.code}";
      }
    } catch (e) {
      return "An unexpected error occurred. Please try again.";
    }
  }

  // Register with email and password
  Future<dynamic> registerWithEmailPassword(
      String name, String email, String password) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName(name);
        await user.reload();
        user =
            _firebaseAuth.currentUser; // Re-fetch the current user after reload
        await addUserToFirestore(user!);
        return userCredential.user;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      // Handle specific errors
      switch (e.code) {
        case 'email-already-in-use':
          return "The email address is already in use.";
        case 'weak-password':
          return "The password is too weak.";
        case 'invalid-email':
          return "The email address is not valid.";
        default:
          return "Registration failed: ${e.code}";
      }
    } catch (e) {
      return "An unexpected error occurred. Please try again.";
    }
  }

// add user to firestore
  Future<void> addUserToFirestore(User user) async {
    UserModel newUser = UserModel.fromFirebaseUser(user);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set(newUser.toMap());
  }

  Future<List<UserModel>?> getUser() async {
    try {
      QuerySnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').get();
      return userDoc.docs
          .map((doc) => UserModel.fromUserDocument(doc))
          .toList();
    } catch (e) {
      print('Error fetching user: $e');
    }
    return null;
  }

  Future<UserModel?> getUserById(String userId) async {
    try {
      // Fetch the document from Firestore
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(userId).get();

      // Check if the document exists
      if (userDoc.exists) {
        // Map the document to UserModel using the fromUserDocument constructor
        return UserModel.fromUserDocument(userDoc);
      } else {
        print('No user found with ID: $userId');
      }
    } catch (e) {
      print('Error fetching user: $e');
    }
    return null;
  }

  // add user to firestore
  Future<void> updateUserProfileFirestore(String name) async {
    final uid = getCurrentUser()!.uid;
    try {
      // Update the post document in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'name': name});
      print('Profile updated successfully');
    } catch (e) {
      print('Error updating profile: $e');
    }
  }

  //update profile
  Future<void> updateFirebaseUser(String name) async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Update the display name
        await user.updateDisplayName(name);
        await user.reload(); // Refresh user data
        updateUserProfileFirestore(name);
        print('Display name updated successfully');
      } else {
        print('No user is currently signed in.');
      }
    } catch (e) {
      print('Error updating display name: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Get current user
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }
}
