import 'dart:async';

import 'package:ccquarters/services/auth/auth_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'sign_in_result.dart';
import 'sign_up_result.dart';

abstract class BaseAuthService {
  bool get isSignedIn;
  String? get currentUserId;
  Future<String?> getToken();
  Future<SignInResult> signInAnnonymously();
  Future<SignInResult> signInWithEmail(
    String email,
    String password,
  );
  Future<SignUpResult> signUp(
    String email,
    String password,
  );
  Future<void> signOut();
  Stream<AuthInfo> get authChanges;
}

class AuthService implements BaseAuthService {
  AuthService({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth {
    _firebaseAuth.authStateChanges().listen((event) {
      _authChangesStreamController.add(AuthInfo());
    });

    if (kIsWeb) {
      _firebaseAuth.setPersistence(Persistence.LOCAL);
    }
  }

  final FirebaseAuth _firebaseAuth;
  final StreamController<AuthInfo> _authChangesStreamController =
      StreamController.broadcast();

  @override
  bool get isSignedIn => _firebaseAuth.currentUser != null;
  @override
  String? get currentUserId => _firebaseAuth.currentUser?.uid;

  @override
  Future<String?> getToken() async {
    return "Bearer ${await _firebaseAuth.currentUser?.getIdToken()}";
  }

  @override
  Future<SignInResult> signInAnnonymously() async {
    await _firebaseAuth.signInAnonymously();
    return SignInResult.success;
  }

  @override
  Future<SignInResult> signInWithEmail(
    String email,
    String password,
  ) async {
    try {
      if (isSignedIn) {
        await _firebaseAuth.signOut();
      }

      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return SignInResult.success;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          return SignInResult.invalidEmail;
        case 'email-already-in-use':
          return SignInResult.emailAlreadyInUse;
        case 'user-disabled':
          return SignInResult.userDisabled;
        case 'user-not-found':
          return SignInResult.userNotFound;
        case 'wrong-password':
          return SignInResult.wrongPassword;
        default:
          rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<SignUpResult> signUp(
    String email,
    String password,
  ) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      return SignUpResult.success;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          return SignUpResult.invalidEmail;
        case 'email-already-in-use':
          return SignUpResult.emailAlreadyInUse;
        case 'operation-not-allowed':
          return SignUpResult.operationNotAllowed;
        case 'weak-password':
          return SignUpResult.weakPassword;
        default:
          rethrow;
      }
    }
  }

  @override
  Future<void> signOut() => _firebaseAuth.signOut();

  @override
  Stream<AuthInfo> get authChanges => _authChangesStreamController.stream;
}
