import 'package:flutter/material.dart';

import 'auth_service.dart';
import 'custom_button.dart';
import 'custom_textfield.dart';
import 'social_login_button.dart';
import 'validators.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController =
      TextEditingController();

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  String role = 'student';

  Future<void> register() async {
    if (!_formKey.currentState!
        .validate()) return;

    await AuthService.registerWithEmail(
      email: emailController.text.trim(),
      password:
          passwordController.text.trim(),
      fullName: nameController.text.trim(),
      role: role,
    );

    if (!mounted) return;

    Navigator.pushReplacementNamed(
      context,
      '/pending-approval',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text('Register')),
      body: Center(
        child: SizedBox(
          width: 500,
          child: Padding(
            padding:
                const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  CustomTextField(
                    controller:
                        nameController,
                    label: 'Full Name',
                    validator: Validators
                        .validateRequired,
                  ),

                  const SizedBox(height: 16),

                  CustomTextField(
                    controller:
                        emailController,
                    label: 'Email',
                    validator: Validators
                        .validateEmail,
                  ),

                  const SizedBox(height: 16),

                  CustomTextField(
                    controller:
                        passwordController,
                    label: 'Password',
                    obscureText: true,
                    validator: Validators
                        .validatePassword,
                  ),

                  const SizedBox(height: 16),

                  DropdownButtonFormField(
                    value: role,
                    items: const [
                      DropdownMenuItem(
                        value: 'student',
                        child: Text(
                          'Student',
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'volunteer',
                        child: Text(
                          'Volunteer',
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        role =
                            value.toString();
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  CustomButton(
                    text: 'Register',
                    onPressed: register,
                  ),

                  const SizedBox(height: 24),

                  SocialLoginButton(
                    text:
                        'Continue with Google',
                    icon: Icons.g_mobiledata,
                    onPressed: () async {
                      await AuthService
                          .signInWithGoogle();

                      if (!mounted) return;

                      Navigator.pushNamed(
                        context,
                        '/pending-approval',
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  SocialLoginButton(
                    text:
                        'Continue with Facebook',
                    icon: Icons.facebook,
                    onPressed: () async {
                      await AuthService
                          .signInWithFacebook();

                      if (!mounted) return;

                      Navigator.pushNamed(
                        context,
                        '/pending-approval',
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}