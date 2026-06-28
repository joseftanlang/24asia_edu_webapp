import 'dart:async';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'constants.dart';

class FirebaseHandler {
  FirebaseHandler._internal();

  static final FirebaseHandler _instance = FirebaseHandler._internal();

  factory FirebaseHandler() => _instance;

  static FirebaseHandler get instance => _instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _readString(String? value, String fallback) =>
      (value == null || value.isEmpty) ? fallback : value;

  // Updated document creation to include settings fields
  Future<Map<String, dynamic>?> _writeUserDocument({
    required String uid,
    required String email,
    required String fullName,
    required String role,
  }) async {
    final res = {
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
      'createdAt': FieldValue.serverTimestamp(),
      // Settings-specific fields
      'volunteerId': 'VOL-0000-0000',
      'memberSince': '',
      'nextReviewDate': '',
      'level': 0,
      'hours': 0,
      'events': 0,
      'certificates': 0,
      'attendance': 0,
      'address': '',
      'icNumber': '',
      'occupation': '',
      'birthday': '',
      'race': '',
      'religion': '',
      'citizenship': '',
      'primaryContactName': '',
      'primaryContactRelationship': '',
      'primaryContactPhone': '',
      'primaryContactAddress': '',
      'secondaryContactName': '',
      'secondaryContactRelationship': '',
      'secondaryContactPhone': '',
      'secondaryContactAddress': '',
      'skills': <String>[],
      'badges': <String>[],
      'notifications': true,
      'darkMode': false,
      'twoFactorAuth': true,
    };
    await _firestore.collection(AppConstants.usersCollection).doc(uid).set(res);
    return res;
  }

  Future<Map<String, dynamic>> getAchievementInfo(String achid) async {
    if (achid == 'envhero') {
      return {
        'title': "Environmental Hero",
        'icon': Icons.eco,
        'color': Colors.green,
        'description': "Plant 100 trees",
      };
    } else if (achid == "100h") {
      return {
        'title': "100 Hours Club",
        'icon': Icons.star,
        'color': Colors.orange,
        'description': "Completed 100+ hours",
      };
    } else if (achid == "volmentor") {
      return {
        'title': "Volunteer Mentor",
        'icon': Icons.school,
        'color': Colors.blue,
        'description': "Mentored 20+ juniors",
      };
    } else if (achid == "pattendance") {
      return {
        'title': "Perfect Attendance",
        'icon': Icons.check_circle,
        'color': Colors.purple,
        'description': "No absences in 6 months",
      };
    }
    return {
      'title': "Unknown achievement",
      'icon': Icons.question_mark,
      'color': Colors.red,
      'description': achid,
    };
  }

  static final _skillColors = <Color>[
    Colors.blue,
    Colors.red,
    Colors.orange,
    Colors.green,
    Colors.purple,
    Colors.teal,
    Colors.indigo,
    Colors.pink,
    Colors.cyan,
    Colors.amber,
    Colors.brown,
    Colors.grey,
  ];

  Future<Color> getSkillColor(String skill) async {
    final hash = skill.hashCode;
    final index = (hash.abs() % _skillColors.length).toInt();
    return _skillColors[index];
  }

  Future<bool> _createUserDocumentIfMissing(
    User? user, {
    String fallbackRole = AppConstants.student,
  }) async {
    if (user == null) return false;

    final docRef = _firestore
        .collection(AppConstants.usersCollection)
        .doc(user.uid);

    final snapshot = await docRef.get();

    if (!snapshot.exists) {
      await _writeUserDocument(
        uid: user.uid,
        email: user.email ?? '',
        fullName: user.displayName ?? 'Unknown',
        role: fallbackRole,
      );
    }

    return true;
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return null;

    return {
      'email': user.email ?? '',

      'displayName': _readString(user.displayName, 'Volunteer'),
      'uid': user.uid,
    };
  }

  Future<void> createUserDocument({
    required String uid,
    required String email,
    required String fullName,
    required String role,
  }) async {
    await _writeUserDocument(
      uid: uid,
      email: email,
      fullName: fullName,
      role: role,
    );
  }

  Future<void> createUserDocumentIfNotExists(User? user) async {
    await _createUserDocumentIfMissing(user);
  }

  Future<Map<String, dynamic>?> getUserDocument(String uid) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .get();

      if (!snapshot.exists) return null;

      return snapshot.data();
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchOrCreateUserSettings() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final docRef = _firestore
        .collection(AppConstants.usersCollection)
        .doc(user.uid);

    // 1. Check if document exists
    final docSnapshot = await docRef.get();
    if (!docSnapshot.exists) {
      // 2. Create with defaults if missing
      return await _writeUserDocument(
        uid: user.uid,
        email: user.email ?? '',
        fullName: user.displayName ?? 'Volunteer',
        role: 'Volunteer',
      );
    }

    final doc = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(user.uid)
        .get();

    if (!doc.exists) {
      throw Exception("FAILED TO CREATE USER");
    }

    final data = doc.data() ?? {};
    return {
      'uid': _readString(data['uid']?.toString(), user.uid),
      'email': _readString(data['email']?.toString(), user.email ?? ''),
      'mobile': _readString(data['mobile']?.toString(), ''),
      'bloodGroup': _readString(data['bloodGroup']?.toString(), 'O+'),
      'fullName': _readString(
        data['fullName']?.toString(),
        user.displayName ?? 'Volunteer',
      ),
      'role': _readString(data['role']?.toString(), 'Volunteer'),
      'volunteerId': _readString(
        data['volunteerId']?.toString(),
        'VOL-0000-0000',
      ),
      'memberSince': _readString(data['memberSince']?.toString(), ''),
      'nextReviewDate': _readString(data['nextReviewDate']?.toString(), ''),
      'level': (data['level'] as num?)?.toInt() ?? 0,
      'hours': (data['hours'] as num?)?.toInt() ?? 0,
      'events': (data['events'] as num?)?.toInt() ?? 0,
      'certificates': (data['certificates'] as num?)?.toInt() ?? 0,
      'attendance': (data['attendance'] as num?)?.toInt() ?? 0,
      'address': _readString(data['address']?.toString(), ''),
      'icNumber': _readString(data['icNumber']?.toString(), ''),
      'occupation': _readString(data['occupation']?.toString(), ''),
      'birthday': _readString(data['birthday']?.toString(), ''),
      'race': _readString(data['race']?.toString(), ''),
      'religion': _readString(data['religion']?.toString(), ''),
      'citizenship': _readString(data['citizenship']?.toString(), ''),
      'primaryContactName': _readString(
        data['primaryContactName']?.toString(),
        '',
      ),
      'primaryContactRelationship': _readString(
        data['primaryContactRelationship']?.toString(),
        '',
      ),
      'primaryContactPhone': _readString(
        data['primaryContactPhone']?.toString(),
        '',
      ),
      'primaryContactAddress': _readString(
        data['primaryContactAddress']?.toString(),
        '',
      ),
      'secondaryContactName': _readString(
        data['secondaryContactName']?.toString(),
        '',
      ),
      'secondaryContactRelationship': _readString(
        data['secondaryContactRelationship']?.toString(),
        '',
      ),
      'secondaryContactPhone': _readString(
        data['secondaryContactPhone']?.toString(),
        '',
      ),
      'secondaryContactAddress': _readString(
        data['secondaryContactAddress']?.toString(),
        '',
      ),
      'skills': List<String>.from(data['skills'] as List? ?? []),
      'badges': List<String>.from(
        data['badges'] as List? ?? [],
      ), // list of achids
      'notifications': data['notifications'] as bool? ?? true,
      'darkMode': data['darkMode'] as bool? ?? false,
      'twoFactorAuth': data['twoFactorAuth'] as bool? ?? true,
    };
  }

  // NEW: Update a specific setting field
  Future<void> updateSetting(String key, dynamic value) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(user.uid)
        .update({key: value});
  }
}
