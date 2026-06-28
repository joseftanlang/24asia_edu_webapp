import './database/postgres_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'home.dart';

const iOSClientId =
    '203447599197-niotr417ut97ltor94mrpq3s3vu2n51b.apps.googleusercontent.com';
const webClientId =
    '203447599197-kudsl8bvo4on4usgh4fsk0p03908436a.apps.googleusercontent.com';

String get googleClientId {
  if (defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS) {
    return iOSClientId;
  }
  return webClientId;
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            providers: [
              EmailAuthProvider(),
              GoogleProvider(clientId: googleClientId),
            ],
            headerBuilder: (context, constraints, shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset('web/icons/Icon-512.png'),
                ),
              );
            },
            subtitleBuilder: (context, action) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: action == AuthAction.signIn
                    ? const Text('Welcome, please sign in!')
                    : const Text('Welcome, please sign up!'),
              );
            },
            footerBuilder: (context, action) {
              return const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  'By signing in, you agree to our terms and conditions.',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            },
            sideBuilder: (context, shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset('web/icons/Icon-512.png'),
                ),
              );
            },
          );
        }

        HybridDatabaseHandler.instance.setCurrentUser(
          FirebaseAuth.instance.currentUser?.uid ?? '',
          'Admin', // TODO change to e.g. Gold VOlunteer
        );

        return const HomeScreen();
      },
    );
  }
}
