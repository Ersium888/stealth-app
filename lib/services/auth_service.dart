import 'package:firebase_auth/firebase_auth.dart';
// It's good practice to add foundation for debugPrint, or use a logger package
// import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get userChanges => _auth.userChanges();

  Future<UserCredential?> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase Auth errors (e.g., email-already-in-use, weak-password)
      // For now, just print the error. In a real app, you'd show user-friendly messages.
      // if (kDebugMode) {
      //   print('FirebaseAuthException (signUpWithEmail): ${e.message}');
      // }
      rethrow; // Rethrow the exception to be caught by the UI layer
    } catch (e) {
      // Handle other errors
      // if (kDebugMode) {
      //   print('Generic Exception (signUpWithEmail): $e');
      // }
      rethrow;
    }
  }

  Future<UserCredential?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase Auth errors (e.g., user-not-found, wrong-password)
      // if (kDebugMode) {
      //   print('FirebaseAuthException (signInWithEmail): ${e.message}');
      // }
      rethrow;
    } catch (e) {
      // if (kDebugMode) {
      //   print('Generic Exception (signInWithEmail): $e');
      // }
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      // if (kDebugMode) {
      //   print('Generic Exception (signOut): $e');
      // }
      rethrow;
    }
  }
}
