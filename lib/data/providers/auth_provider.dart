import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart'; // Import UserModel
import '../repositories/auth_repository.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  UserModel? _user; // This will be the custom UserModel
  UserModel? _userWithId; // This will be the custom UserModel
  List<UserModel> _users = []; // This will be the custom UserModel

  UserModel? get user => _user;
  UserModel? get userWithId => _userWithId;

  List<UserModel> get users => _users;

  // Fetch all users
  Future<void> getUser() async {
    _users = (await _authRepository.getUser())!;
    notifyListeners();
  }

  // Fetch user by id
  Future<void> getUserWithId(String userId) async {
    _userWithId = (await _authRepository.getUserById(userId))!;
    notifyListeners();
  }

  // Sign in with email and password
  Future<String> signIn(String email, String password) async {
    final result =
        await _authRepository.signInWithEmailPassword(email, password);
    if (result is User) {
      _user = UserModel.fromFirebaseUser(
          result); // Convert FirebaseUser to UserModel
      await _saveLoginState();
      notifyListeners();
      return 'Login success';
    } else {
      return result;
    }
  }

  // Register with email and password
  Future<String> register(String email, String password, String name) async {
    final result =
        await _authRepository.registerWithEmailPassword(name, email, password);
    if (result is User) {
      _user = UserModel.fromFirebaseUser(
          result); // Convert FirebaseUser to UserModel
      await _saveLoginState();
      notifyListeners();
      return 'Register success';
    } else {
      return result;
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
      _user = UserModel.fromFirebaseUser(
          firebaseUser); // Convert FirebaseUser to UserModel
    }
    notifyListeners();
  }

  resetPassword(String text) {}

  updateProfile({required String name}) async {
    await _authRepository.updateFirebaseUser(name);
    notifyListeners();
  }
}
