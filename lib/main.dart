import 'package:flutter/material.dart';
import 'auth_page/firebase_service.dart';
import 'auth_page/auth_screen.dart';
import 'auth_page/home_page.dart';
import 'setting/setting.dart';
import 'clocking_sys.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Volunteer App',
      theme: ThemeData(
        primaryColor: const Color(0xff1565C0),
        scaffoldBackgroundColor: const Color(0xffF4F7FC),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const SettingsScreens(), // Changed to SettingsScreen
    );
  }
}

// import 'package:flutter/material.dart';
// import 'auth_page/firebase_service.dart';
// import 'auth_page/auth_screen.dart';
// import 'auth_page/home_page.dart';
// import 'setting/setting.dart';
// import 'clocking_sys.dart';

// void main() {
//   runApp(const MyApp());
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
//       home: const ClockInOutPage(), // Now ClockInOutPage has MaterialApp as parent
//     );
//   }
// }