import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_example/domain/repositories/auth_repository.dart';

class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() => message;
}


class FirebaseAuthService implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<UserCredential> login(
      {required String email, required String password}) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result;
    } on FirebaseAuthException catch (e) {
       throw _handleAuthException(e);
    } catch (e) {
      throw AuthException("An unexpected error occurred. Please try again.");
    }
  }

  @override
  Future<UserCredential> signup(
      {required String email, required String password}) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password); 
      return result;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw AuthException("An unexpected error occurred. Please try again.");
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception("Logout failed. Please try again.");
    }
  }


  Exception _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return Exception("The email address is invalid.");
      case 'user-disabled':
        return Exception("This user has been disabled.");
      case 'user-not-found':
        return Exception("No user found with this email.");
      case 'wrong-password':
        return Exception("Incorrect password. Please try again.");
      case 'email-already-in-use':
        return Exception("This email is already registered.");
      case 'weak-password':
        return Exception("Password should be at least 6 characters.");
      case 'invalid-credential':
        return Exception("Invalid or expired credentials. Please try again.");
      default:
        return Exception(
            e.message ?? "Authentication error. Please try again.");
    }
  }

 
}
