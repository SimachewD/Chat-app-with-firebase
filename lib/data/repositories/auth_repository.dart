import 'package:chatter_hive/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Sign in with email and password
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Handle error
      print(e.message);
      return null;
    }
  }

  // Register with email and password
  Future<User?> registerWithEmailPassword(
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
      // Handle error
      print(e.message);
      return null;
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

// add user to firestore
  Future<void> updateUserProfileFirestore(User user) async {
    UserModel newUser = UserModel.fromFirebaseUser(user);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set(newUser.toMap());
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
