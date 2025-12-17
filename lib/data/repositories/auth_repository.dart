import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _db = FirebaseFirestore.instance;
  late CollectionReference userTable;

  AuthRepository() {
    userTable = FirebaseFirestore.instance.collection('users');
  }

  Future<UserCredential> login({required String email, required String password}) {
    return _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signup({
    required String email,
    required String password,
    String name = '',
  }) async {
    try {
      UserCredential signUpData = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (signUpData.user != null) {
        final finalName = name.trim().isEmpty ? 'New User' : name.trim();
        await signUpData.user!.updateDisplayName(finalName);
        await signUpData.user!.reload();
      }
      return signUpData;
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message.toString());
      rethrow;
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      try {
        await user.sendEmailVerification();
        print(' Verification email sent to: ${user.email}');
      } catch (e) {
        print(' Error sending verification email: $e');
        await user.sendEmailVerification();
      }
    }
  }

  Future<bool> isEmailVerified() async {
    final user = _auth.currentUser;
    if (user == null) return false;
    await user.reload();
    return _auth.currentUser?.emailVerified ?? false;
  }

  User? getLoggedInUser() {
    return _auth.currentUser;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    Get.offAllNamed("/login");
  }

  Future<void> logout() async {
    await signOut();
  }
}

