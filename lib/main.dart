import 'package:flutter/material.dart';
import 'auth_page/firebase_service.dart';
import 'auth_page/auth_screen.dart';
import 'auth_page/home_page.dart';
import 'setting/setting.dart';

void main() {
  runApp(const MySetting());
}

class MySetting extends StatelessWidget {
  const MySetting({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsScreens();
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Volunteer App',
//       theme: ThemeData(
//         primaryColor: const Color(0xff1565C0),
//         scaffoldBackgroundColor: const Color(0xffF4F7FC),
//         fontFamily: 'Roboto',
//         useMaterial3: true,
//       ),
//       debugShowCheckedModeBanner: false,
//       home: StreamBuilder<bool>(
//         stream: FirebaseService.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData && snapshot.data == true) {
//             return const HomePage();
//           }
//           return const AuthScreen();
//         },
//       ),
//     );
//   }
// }


// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Volunteer App',
//       theme: ThemeData(
//         primaryColor: const Color(0xff1565C0),
//         scaffoldBackgroundColor: const Color(0xffF4F7FC),
//         fontFamily: 'Roboto',
//         useMaterial3: true,
//       ),
//       debugShowCheckedModeBanner: false,
//       home: StreamBuilder<bool>(
//         stream: FirebaseService.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData && snapshot.data == true) {
//             return const HomePage();
//           }
//           return const AuthScreen();
//         },
//       ),
//     );
//   }
// }