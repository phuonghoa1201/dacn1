import 'package:flutter/material.dart';
import 'package:dacn1/contants/global_variables.dart';
import 'package:dacn1/common/widgets/custom_textfield.dart';
import 'package:dacn1/features/auth/services/auth_service.dart';
import 'package:dacn1/common/widgets/custom_button.dart';

enum Auth { signin, signup }

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth-screen';

  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Auth _auth = Auth.signup;
  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
  }

  void signUpUser() {
    authService.signUpUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
      name: _nameController.text,
    );
  }

  void signInUser() {
    authService.signInUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  void toggleAuthMode() {
    setState(() {
      _auth = _auth == Auth.signup ? Auth.signin : Auth.signup;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.greyBackgroundCOlor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              const SizedBox(height: 12), // Khoảng cách nhỏ giữa Welcome và logo
              Image.asset(
                'assets/images/Tech_Zone.png',
                width: 250,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 20),
              if (_auth == Auth.signup)
                Form(
                  key: _signUpFormKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _nameController,
                        hintText: 'Name',
                        prefixIcon: Icons.person,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _emailController,
                        hintText: 'Email',
                        prefixIcon: Icons.email,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _passwordController,
                        hintText: 'Password',
                        prefixIcon: Icons.lock,
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        text: 'Sign Up',
                        onTap: () {
                          if (_signUpFormKey.currentState!.validate()) {
                            signUpUser();
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: toggleAuthMode,
                        child: const Text(
                          'Already have an account? Sign In',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Form(
                  key: _signInFormKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _emailController,
                        hintText: 'Email',
                        prefixIcon: Icons.email,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _passwordController,
                        hintText: 'Password',
                        prefixIcon: Icons.lock,
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        text: 'Sign In',
                        onTap: () {
                          if (_signInFormKey.currentState!.validate()) {
                            signInUser();
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: toggleAuthMode,
                        child: const Text(
                          "Don't have an account? Sign Up",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
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


