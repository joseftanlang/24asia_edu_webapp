import 'package:flutter/material.dart';

import 'landing_screen.dart';
import 'register_screen.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const LandingScreen());

      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      default:
        return MaterialPageRoute(builder: (_) => const LandingScreen());
    }
  }
}
