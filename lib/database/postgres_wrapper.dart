import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_handler.dart';
import 'constants.dart';

/// Enum for Data Access Control (DAC) enforcement levels
enum AccessMode { readSelf, readAll, writeSelf, writeAll }

class HybridDatabaseHandler {
  HybridDatabaseHandler._internal();

  static final HybridDatabaseHandler _instance =
      HybridDatabaseHandler._internal();
  factory HybridDatabaseHandler() => _instance;
  static HybridDatabaseHandler get instance => _instance;

  // PostgreSQL state
  Connection? _pgConn;
  bool _pgConnected = false;

  // Firebase fallback reference
  final FirebaseHandler _fb = FirebaseHandler.instance;

  // Auth context for DAC
  String? _currentUid;
  String _currentRole = 'Student';

  /// Key mapping: camelCase (Flutter) -> snake_case (Postgres)
  static const Map<String, String> _keyMap = {
    'fullName': 'full_name',
    'bloodGroup': 'blood_group',
    'memberSince': 'member_since',
    'nextReviewDate': 'next_review_date',
    'primaryContactName': 'primary_contact_name',
    'primaryContactRelationship': 'primary_contact_relationship',
    'primaryContactPhone': 'primary_contact_phone',
    'primaryContactAddress': 'primary_contact_address',
    'secondaryContactName': 'secondary_contact_name',
    'secondaryContactRelationship': 'secondary_contact_relationship',
    'secondaryContactPhone': 'secondary_contact_phone',
    'secondaryContactAddress': 'secondary_contact_address',
    'notifications': 'notifications',
    'darkMode': 'dark_mode',
    'twoFactorAuth': 'two_factor_auth',
    'volunteerId': 'volunteer_id',
    'icNumber': 'ic_number',
    'birthday': 'birthday',
    'citizenship': 'citizenship',
  };

  /// Set auth context for DAC
  void setCurrentUser(String uid, String role) {
    _currentUid = uid;
    _currentRole = role;
  }

  /// Connect to PostgreSQL
  Future<void> connect({
    required String host,
    required int port,
    required String user,
    required String password,
    required String database,
  }) async {
    try {
      _pgConn = await Connection.open(
        Endpoint(
          host: host,
          port: port,
          username: user,
          password: password,
          database: database,
        ),
        settings: ConnectionSettings(sslMode: SslMode.disable),
      );
      _pgConnected = true;
      debugPrint('✅ PostgreSQL connected');
    } catch (e) {
      debugPrint('❌ PostgreSQL connection failed: $e');
      _pgConnected = false;
    }
  }

  bool get _isPgAvailable => _pgConnected && _pgConn != null;

  /// Data Access Control Enforcement
  void _enforceAccess(String targetUid, AccessMode mode) {
    if (_currentUid == null) throw Exception('Unauthenticated context');

    debugPrint("TARGET UID $targetUid");
    debugPrint("CURRENT UID $_currentUid");

    final bool isSelf = targetUid == _currentUid;
    final bool isAdmin = _currentRole.toLowerCase().contains('admin');

    switch (mode) {
      case AccessMode.readSelf:
        if (!isSelf)
          throw Exception('Access Denied: Cannot read other user profiles');
      case AccessMode.writeSelf:
        if (!isSelf)
          throw Exception('Access Denied: Cannot modify other user settings');
      case AccessMode.readAll:
      case AccessMode.writeAll:
        if (!isAdmin) throw Exception('Access Denied: Admin only');
    }
  }

  /// Graceful fallback wrapper
  Future<T> _withFallback<T>(
    Future<T> Function() pgFn,
    Future<T> Function() fbFn,
  ) async {
    try {
      return await pgFn();
    } catch (e) {
      final isPgError =
          e is ServerException ||
          e.toString().contains('Connection closed') ||
          e.toString().contains('timed out');

      if (isPgError) {
        debugPrint('⚠️ Postgres failed: $e. Falling back to Firebase.');
        return await fbFn();
      }
      rethrow;
    }
  }

  /// Safely map Postgres row to FirebaseHandler compatible format
  Map<String, dynamic> _mapPgToFirebase(ResultRow rrow) {
    final Map<String, dynamic> row = rrow.toColumnMap();
    final map = <String, dynamic>{};

    const keys = [
      'uid',
      'email',
      'full_name',
      'role',
      'status',
      'profile_completed',
      'dob',
      'birthday',
      'blood_group',
      'mobile',
      'company',
      'job_title',
      'photo_url',
      'created_at',
      'volunteer_id',
      'member_since',
      'next_review_date',
      'level',
      'hours',
      'events',
      'certificates',
      'attendance',
      'address',
      'ic_number',
      'occupation',
      'race',
      'religion',
      'citizenship',
      'primary_contact_name',
      'primary_contact_relationship',
      'primary_contact_phone',
      'primary_contact_address',
      'secondary_contact_name',
      'secondary_contact_relationship',
      'secondary_contact_phone',
      'secondary_contact_address',
      'notifications',
      'dark_mode',
      'two_factor_auth',
      'skills',
      'badges',
    ];

    for (final key in keys) {
      final pgKey = _keyMap[key] ?? key;
      dynamic val = row[pgKey];
      if (val == null) continue;

      if (key == 'skills' || key == 'badges') {
        // json_agg returns a JSON string
        val = val is String ? jsonDecode(val) : (val as List? ?? []);
      } else if (key == 'profile_completed' ||
          key == 'notifications' ||
          key == 'dark_mode' ||
          key == 'two_factor_auth') {
        val = val is bool
            ? val
            : (val == 1 || val == '1' || val == 't' || val == true);
      } else if (val is num) {
        // Already numeric
      } else if (val is String && double.tryParse(val) != null) {
        val = int.tryParse(val) ?? double.parse(val);
      }
      // Strings remain as-is

      map[key] = val;
    }
    return map;
  }

  /// CORE: Fetch user settings/profile via PostgreSQL
  Future<Map<String, dynamic>?> _fetchPgUser(String uid) async {
    if (!_isPgAvailable) return null;

    final sql = r'''
      SELECT u.uid, u.email, u.full_name, u.role, u.status, u.profile_completed,
             u.dob, u.birthday, u.blood_group, u.mobile, u.company, u.job_title, u.photo_url, u.created_at,
             u.volunteer_id, u.member_since, u.next_review_date, u.level, u.hours, u.events, u.certificates, u.attendance,
             u.address, u.ic_number, u.occupation, u.race, u.religion, u.citizenship,
             u.primary_contact_name, u.primary_contact_relationship, u.primary_contact_phone, u.primary_contact_address,
             u.secondary_contact_name, u.secondary_contact_relationship, u.secondary_contact_phone, u.secondary_contact_address,
             u.notifications, u.dark_mode, u.two_factor_auth,
             COALESCE(json_agg(DISTINCT us.skill_name) FILTER (WHERE us.skill_name IS NOT NULL), '[]') AS skills,
             COALESCE(json_agg(DISTINCT ub.badge_name) FILTER (WHERE ub.badge_name IS NOT NULL), '[]') AS badges
      FROM users u
      LEFT JOIN user_skills us ON u.uid = us.user_id
      LEFT JOIN user_badges ub ON u.uid = ub.user_id
      WHERE u.uid = \$1
      GROUP BY u.uid
    ''';

    final conn = _pgConn!;
    final result = await conn.execute(sql, parameters: [uid]);
    if (result.isEmpty) return null;

    final row = result.first;
    return _mapPgToFirebase(row);
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // PUBLIC API (mirrors FirebaseHandler exactly)
  // ─────────────────────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>?> getCurrentUser() async {
    final fb = await _fb.getCurrentUser();
    return fb != null ? Map<String, dynamic>.from(fb) : null;
  }

  Future<Map<String, dynamic>?> getUserDocument(String uid) async {
    return _withFallback<Map<String, dynamic>?>(() async {
      _enforceAccess(uid, AccessMode.readAll);
      return await _fetchPgUser(uid);
    }, () => _fb.getUserDocument(uid));
  }

  Future<Map<String, dynamic>?> fetchOrCreateUserSettings() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;

    debugPrint("STARTING FETCHING SETTINGS");

    return _withFallback<Map<String, dynamic>?>(() async {
      _enforceAccess(uid, AccessMode.readSelf);
      final doc = await _fetchPgUser(uid);
      debugPrint("GOT DOC");
      if (doc != null) {
        debugPrint("DOC IS NOT NULL");
      } else {
        debugPrint("DOC IS NULL");
      }
      return doc ?? await _createPgUserIfMissing(uid);
    }, () => _fb.fetchOrCreateUserSettings());
  }

  Future<Map<String, dynamic>?> _createPgUserIfMissing(String uid) async {
    if (!_isPgAvailable) return null;
    final user = FirebaseAuth.instance.currentUser;
    final name = user?.displayName ?? 'Volunteer';
    final email = user?.email ?? '';

    final createSql = r'''
      INSERT INTO users (
        uid, email, full_name, role, status, profile_completed,
        dob, birthday, blood_group, mobile, company, job_title, photo_url, created_at,
        volunteer_id, member_since, next_review_date, level, hours, events, certificates, attendance,
        address, ic_number, occupation, race, religion, citizenship,
        primary_contact_name, primary_contact_relationship, primary_contact_phone, primary_contact_address,
        secondary_contact_name, secondary_contact_relationship, secondary_contact_phone, secondary_contact_address,
        notifications, dark_mode, two_factor_auth
      ) VALUES (
        \$1, \$2, \$3, \$4, 'pending', false, '', '', 'O+', '', '', '', '', NOW(),
        'VOL-0000-0000', '', '', 0, 0, 0, 0, 0,
        '', '', '', '', '', '',
        '', '', '', '',
        '', '', '', '',
        true, false, true
      ) RETURNING *
    ''';

    try {
      final conn = _pgConn!;
      final res = await conn.execute(
        createSql,
        parameters: [uid, email, name, AppConstants.student],
      );
      if (res.isEmpty) return null;
      final row = res.first;
      return _mapPgToFirebase(row);
    } catch (e) {
      debugPrint('⚠️ Failed to create user in Postgres: $e');
      return null;
    }
  }

  Future<void> updateSetting(String key, dynamic value) async {
    debugPrint("UPDATE SETTING $key");
    debugPrint(value.toString());
    return _withFallback<void>(() async {
      _enforceAccess(_currentUid!, AccessMode.writeSelf);
      final pgKey = _keyMap[key] ?? key;
      final sql = 'UPDATE users SET $pgKey = \'\$1\' WHERE uid = \'\$2\';';
      debugPrint(sql);
      debugPrint(_pgConn != null ? _pgConn!.info.toString() : "null conn");
      await _pgConn!.execute(sql, parameters: [value, _currentUid]);
      debugPrint("SUCCESS");
    }, () => _fb.updateSetting(key, value));
  }

  Future<void> createUserDocument({
    required String uid,
    required String email,
    required String fullName,
    required String role,
  }) async {
    return _withFallback<void>(
      () async {
        _enforceAccess(uid, AccessMode.writeAll);
        await _createPgUserIfMissing(uid);
      },
      () => _fb.createUserDocument(
        uid: uid,
        email: email,
        fullName: fullName,
        role: role,
      ),
    );
  }

  Future<Map<String, dynamic>> getAchievementInfo(String achid) async {
    return _fb.getAchievementInfo(achid);
  }

  Future<Color> getSkillColor(String skill) async {
    return _fb.getSkillColor(skill);
  }
}
