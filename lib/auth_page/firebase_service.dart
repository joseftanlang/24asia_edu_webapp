import 'dart:async';
import 'dart:js' as js;
import 'dart:js_util' as js_util;

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  static FirebaseService get instance => _instance;
  
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  dynamic get _auth {
    try {
      final firebase = js.context['firebase'];
      if (firebase != null) {
        return firebase.callMethod('auth');
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> _ensureFirebase() async {
    for (int i = 0; i < 30; i++) {
      if (_auth != null) return true;
      await Future.delayed(const Duration(milliseconds: 100));
    }
    return false;
  }

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    try {
      if (!await _ensureFirebase()) {
        return {'success': false, 'error': 'Firebase not ready. Please refresh.'};
      }
      
      await js_util.callMethod(
        _auth,
        'signInWithEmailAndPassword',
        [email, password]
      );
      return {'success': true};
    } catch (e) {
      String error = 'Login failed';
      String errStr = e.toString().toLowerCase();
      if (errStr.contains('user-not-found')) error = 'No account found';
      else if (errStr.contains('wrong-password')) error = 'Wrong password';
      else if (errStr.contains('invalid-email')) error = 'Invalid email';
      return {'success': false, 'error': error};
    }
  }

  Future<Map<String, dynamic>> signUp(String email, String password, String name) async {
    try {
      if (!await _ensureFirebase()) {
        return {'success': false, 'error': 'Firebase not ready. Please refresh.'};
      }
      
      // Create user
      final result = await js_util.callMethod(
        _auth,
        'createUserWithEmailAndPassword',
        [email, password]
      );
      
      // Fix: Handle the result as a JsObject
      final resultObj = result as js.JsObject;
      final user = resultObj['user'];
      
      // Update profile
      if (user != null) {
        final userObj = user as js.JsObject;
        await js_util.callMethod(
          userObj,
          'updateProfile',
          [js.JsObject.jsify({'displayName': name})]
        );
      }
      
      return {'success': true};
    } catch (e) {
      print('Sign up error: $e');
      String error = 'Sign up failed';
      String errStr = e.toString().toLowerCase();
      if (errStr.contains('email-already-in-use')) error = 'Email already used';
      else if (errStr.contains('weak-password')) error = 'Password too weak (min 6 chars)';
      return {'success': false, 'error': error};
    }
  }

  Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      if (!await _ensureFirebase()) {
        return {'success': false, 'error': 'Firebase not ready. Please refresh.'};
      }
      
      await js_util.callMethod(_auth, 'sendPasswordResetEmail', [email]);
      return {'success': true, 'message': 'Reset email sent to $email'};
    } catch (e) {
      return {'success': false, 'error': 'Failed to send reset email'};
    }
  }

  Future<void> signOut() async {
    final auth = _auth;
    if (auth != null) {
      await js_util.callMethod(auth, 'signOut', []);
    }
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final auth = _auth;
      if (auth == null) return null;
      
      final user = js_util.getProperty(auth, 'currentUser');
      if (user != null) {
        final userObj = user as js.JsObject;
        final email = userObj['email'];
        final displayName = userObj['displayName'];
        
        return {
          'email': email?.toString() ?? '',
          'displayName': displayName?.toString() ?? 'Volunteer',
        };
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Stream<bool> authStateChanges() {
    final controller = StreamController<bool>.broadcast();
    
    _ensureFirebase().then((ready) {
      if (ready && _auth != null) {
        js_util.callMethod(_auth, 'onAuthStateChanged', [
          js.JsFunction.withThis((_, user) {
            controller.add(user != null);
          })
        ]);
      } else {
        controller.add(false);
      }
    });
    
    return controller.stream;
  }
}