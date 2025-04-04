import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Future<void> login(String email, String password, BuildContext context) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.of(context).pushReplacementNamed('/tasks');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.toString()}')),
      );
    }
  }

  Future<void> register(String email, String password, BuildContext context) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      Navigator.of(context).pushReplacementNamed('/tasks');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: ${e.toString()}')),
      );
    }
  }

  // ✅ Logout function
  void logout(BuildContext context) async {
    await _firebaseAuth.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }
}
