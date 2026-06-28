import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

//import 'database/firebase_handler.dart';
import './database/postgres_wrapper.dart';
import 'settings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HybridDatabaseHandler _auth = HybridDatabaseHandler.instance;
  String _userEmail = '';
  String _userName = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    //debugPrint("GETTING USER");
    final user = await _auth.getCurrentUser();
    //debugPrint("GOT USER");
    //debugPrint(user?['email'] ?? 'NO EMAIL');
    setState(() {
      _userEmail = user?['email'] ?? '';
      _userName = user?['displayName'] ?? 'Volunteer';
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<ProfileScreen>(
                  builder: (context) => ProfileScreen(
                    appBar: AppBar(title: const Text('Your Profile')),
                    actions: [
                      SignedOutAction((context) {
                        Navigator.of(context).pop();
                      }),
                    ],
                    children: [
                      SizedBox(height: 20),
                      Divider(),
                      Settings(),
                      // any other profile page stuff
                    ],
                  ),
                ),
              );
            },
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          children: [
            //Settings(),
            //HomePage(),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.volunteer_activism,
                      size: 60,
                      color: Color(0xff1565C0),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Welcome, $_userName!',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _userEmail,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),

                  /*
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.05),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: const Column(
                      children: [
                        Text(
                          'You are successfully logged in!',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Icon(Icons.check_circle, color: Colors.green, size: 40),
                      ],
                    ),
                  ),
                  */
                ],
              ),
            ),

            SizedBox(height: 20),
            const SignOutButton(),
          ],
        ),
      ),
    );
  }
}
