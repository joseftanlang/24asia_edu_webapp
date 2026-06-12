import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'constants.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static User? get currentUser => _auth.currentUser;

  static Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String role,
  }) async {
    final credential =
        await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await createUserDocument(
      uid: credential.user!.uid,
      email: email,
      fullName: fullName,
      role: role,
    );

    return credential;
  }

  static Future<UserCredential> loginWithEmail({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<UserCredential?> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      return null;
    }

    final googleAuth =
        await googleUser.authentication;

    final credential =
        GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final result =
        await _auth.signInWithCredential(
      credential,
    );

    await createUserDocumentIfNotExists(
      result.user!,
    );

    return result;
  }

  static Future<UserCredential?> signInWithFacebook() async {
    final loginResult =
        await FacebookAuth.instance.login();

    if (loginResult.status !=
        LoginStatus.success) {
      return null;
    }

    final credential =
        FacebookAuthProvider.credential(
      loginResult.accessToken!.tokenString,
    );

    final result =
        await _auth.signInWithCredential(
      credential,
    );

    await createUserDocumentIfNotExists(
      result.user!,
    );

    return result;
  }

  static Future<void> resetPassword(
      String email) async {
    await _auth.sendPasswordResetEmail(
      email: email,
    );
  }

  static Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
    await _auth.signOut();
  }

  static Future<void> createUserDocument({
    required String uid,
    required String email,
    required String fullName,
    required String role,
  }) async {
    await _firestore
        .collection(
            AppConstants.usersCollection)
        .doc(uid)
        .set({
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'role': role,

      'status': AppConstants.pending,

      'profileCompleted': false,

      'dob': '',
      'bloodGroup': '',
      'mobile': '',
      'company': '',
      'jobTitle': '',
      'photoUrl': '',

      'createdAt':
          FieldValue.serverTimestamp(),
    });
  }

  static Future<void>
      createUserDocumentIfNotExists(
    User user,
  ) async {
    final doc = await _firestore
        .collection(
            AppConstants.usersCollection)
        .doc(user.uid)
        .get();

    if (!doc.exists) {
      await createUserDocument(
        uid: user.uid,
        email: user.email ?? '',
        fullName:
            user.displayName ?? 'Unknown',
        role: AppConstants.student,
      );
    }
  }

  static Future<DocumentSnapshot>
      getUserDocument(String uid) {
    return _firestore
        .collection(
            AppConstants.usersCollection)
        .doc(uid)
        .get();
  }
}