import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// to init psql
import './database/postgres_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await HybridDatabaseHandler.instance.connect(
    host: '192.168.1.8',
    port: 15432,
    user: 'demo24asia',
    password: 'demo.24ASIA',
    database: 'demo',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: AuthGate(),
    );
  }
}
