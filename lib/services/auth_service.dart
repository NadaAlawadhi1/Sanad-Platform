import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:sanad_dashboared/services/database_service.dart';


class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? _user;
  User? get user {
    return _user;
  }

  AuthService() {
    _firebaseAuth.authStateChanges().listen(authStateChangesStreamListner);
  }

  Future<bool> login(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (credential.user != null) {
        _user = credential.user;
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  /// Sign In

  Future<void> registerUser({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      log('Checking if email exists in database...');
      // Check if the email already exists
      final emailExists = await DatabaseService.checkIfEmailExists(email);
      if (emailExists) {
        log('Email is already registered');
        return;
      }

      log('Creating user with email and password...');
      // Create user with email and password
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      if (FirebaseAuth.instance.currentUser != null) {
        log('Sending email verification...');
        await FirebaseAuth.instance.currentUser!.sendEmailVerification();
      } else {
        log('Error: User not found after account creation');
        return;
      }

      log('Creating user in Firestore with additional fields...');
      // Create a new user document in Firestore with additional fields
      await DatabaseService.createUserInFirestore(
        user.user!.uid,
        name,
        email,
      );

      log('User registered successfully');
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'weak-password') {
        log('Password is too weak');
      } else if (ex.code == 'email-already-in-use') {
        log('The email is already in use');
      } else {
        log('FirebaseAuthException: ${ex.message}');
      }
    } catch (e) {
      log('An error occurred during registration: $e');
    }
  }

  Future<bool> logout() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  void authStateChangesStreamListner(User? user) {
    if (user != null) {
      _user = user;
    } else {
      _user = null;
    }
  }
}
