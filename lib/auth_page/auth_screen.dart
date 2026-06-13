import 'package:flutter/material.dart';
import 'login_page.dart';
import 'signup_page.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xffC62828), Color(0xffE53935), Color(0xffEF5350)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom Tab Bar
              Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TabBar(
                  controller: _tabController,
                  labelColor: const Color(0xffC62828),
                  unselectedLabelColor: Colors.grey,
                  indicator: BoxDecoration(
                    color: const Color(0xffC62828).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  tabs: const [
                    Tab(text: 'LOGIN', icon: Icon(Icons.login)),
                    Tab(text: 'SIGN UP', icon: Icon(Icons.person_add)),
                  ],
                ),
              ),
              // Tab Bar View
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    LoginPage(),
                    SignUpPage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}