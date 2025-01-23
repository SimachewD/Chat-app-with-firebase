import 'package:cross_file/src/types/interface.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart'; // Import UserModel
import '../repositories/auth_repository.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  UserModel? _user; // This will be the custom UserModel
  List<UserModel> _users = []; // This will be the custom UserModel

  UserModel? get user => _user;

  List<UserModel> get users => _users;

  // Fetch all posts
  Future<void> getUsers() async {
    _users = (await _authRepository.getUser())!;
    notifyListeners();
  }

  // Sign in with email and password
  Future<void> signIn(String email, String password) async {
    User? firebaseUser =
        await _authRepository.signInWithEmailPassword(email, password);
    if (firebaseUser != null) {
      _user = UserModel.fromFirebaseUser(firebaseUser); // Convert FirebaseUser to UserModel
      await _saveLoginState();
      notifyListeners();
    }
  }

  // Register with email and password
  Future<void> register(String email, String password, String name) async {
    User? firebaseUser =
        await _authRepository.registerWithEmailPassword(name, email, password);
    if (firebaseUser != null) {
      _user = UserModel.fromFirebaseUser(firebaseUser); // Convert FirebaseUser to UserModel
      await _saveLoginState();
      notifyListeners();
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _authRepository.signOut();
    _user = null;
    _clearLoginState();
    notifyListeners();
  }

  Future<void> _saveLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
  }

  Future<void> _clearLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
  }

  Future<void> checkLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      await checkCurrentUser();
    }
  }

  // Get current user
  Future<void> checkCurrentUser() async {
    User? firebaseUser = _authRepository.getCurrentUser();
    if (firebaseUser != null) {
      _user = UserModel.fromFirebaseUser(firebaseUser); // Convert FirebaseUser to UserModel
    }
    notifyListeners();
  }

  resetPassword(String text) {}

  updateProfile({required String name, XFile? profilePicture}) {}
}
