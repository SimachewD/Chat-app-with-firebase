import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? photoUrl;
  // final List<String>? followers;
  // final List<String>? following;
  
  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl,
    // this.followers,
    // this.following,
  });

  // Convert Firebase document to UserModel
  factory UserModel.fromFirebaseUser(User firebaseUser) {
    return UserModel(
      uid: firebaseUser.uid,
      name: firebaseUser.displayName ?? '',
      email: firebaseUser.email ?? '',
      photoUrl: firebaseUser.photoURL ?? '',
      // followers: List<String>.from(doc['followers'] ?? []),
      // following: List<String>.from(doc['following'] ?? []),
    );
  }

  // Convert Firebase document to PostModel
  factory UserModel.fromUserDocument(DocumentSnapshot doc) {
    return UserModel(
      uid: doc.id,
      name: doc['name'] ?? '',
      email: doc['email'] ?? '',
      photoUrl: doc['photoUrl'] ?? '',
    );
  }

  // Convert UserModel to a map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'createdAt': FieldValue.serverTimestamp(),
      // 'followers': followers,
      // 'following': following,
    };
  }
}
