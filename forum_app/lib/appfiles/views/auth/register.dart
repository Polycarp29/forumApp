import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:forum_app/appfiles/views/auth/login.dart';
import 'package:forum_app/appfiles/views/widgets/textfield.dart';
import 'package:forum_app/constants/appconstants.dart';
import 'package:forum_app/controllers/appcomtroller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthenticationController _authController =
      Get.put(AuthenticationController());

  String? _usernameError;
  String? _nameError;
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _usernameController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final username = _usernameController.text.trim();
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    setState(() {
      _usernameError = null;
      _nameError = null;
      _emailError = null;
      _passwordError = null;
    });

    if (username.isEmpty) {
      setState(() {
        _usernameError = 'Username is required';
      });
    }

    if (name.isEmpty) {
      setState(() {
        _nameError = 'Name is required';
      });
    }

    if (email.isEmpty) {
      setState(() {
        _emailError = 'Email is required';
      });
    }

    if (password.isEmpty) {
      setState(() {
        _passwordError = 'Password is required';
      });
    }

    if (_usernameError == null &&
        _nameError == null &&
        _emailError == null &&
        _passwordError == null) {
      final result = await _authController.register(
        username: username,
        name: name,
        email: email,
        password: password,
      );

      if (result != null && result.containsKey('token')) {
        Get.snackbar(
          'Success',
          'Registration successful!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppConstants.greenColor,
          colorText: AppConstants.white,
        );
      } else if (result != null && result.containsKey('errors')) {
        setState(() {
          _usernameError = result['errors']['username']?.first;
          _nameError = result['errors']['name']?.first;
          _emailError = result['errors']['email']?.first;
          _passwordError = result['errors']['password']?.first;
        });
      } else {
        Get.snackbar(
          'Error',
          'Registration failed. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppConstants.redColor,
          colorText: AppConstants.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('REGISTER',
                style: GoogleFonts.poppins(
                  fontSize: 30,
                  color: AppConstants.black,
                )),
            const SizedBox(height: 20),
            TexfieldWidget(
              hint: 'Username',
              iconData: Icons.person,
              iconColor: AppConstants.black,
              inputColor: AppConstants.darkGrey,
              controller: _usernameController,
              obscureText: false,
            ),
            if (_usernameError != null)
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  _usernameError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            const SizedBox(height: 10),
            TexfieldWidget(
              hint: 'Name',
              iconData: Icons.person_2,
              iconColor: AppConstants.black,
              inputColor: AppConstants.darkGrey,
              controller: _nameController,
              obscureText: false,
            ),
            if (_nameError != null)
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  _nameError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            const SizedBox(height: 10),
            TexfieldWidget(
              hint: 'Email',
              iconData: Icons.email,
              iconColor: AppConstants.black,
              inputColor: AppConstants.darkGrey,
              controller: _emailController,
              obscureText: false,
            ),
            if (_emailError != null)
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  _emailError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            const SizedBox(height: 10),
            TexfieldWidget(
              hint: 'Password',
              iconData: Icons.password,
              iconColor: AppConstants.black,
              inputColor: AppConstants.darkGrey,
              controller: _passwordController,
              obscureText: true,
            ),
            if (_passwordError != null)
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  _passwordError!,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            const SizedBox(height: 20),
            Obx(() => ElevatedButton(
                  onPressed: _authController.isLoading.value ? null : _register,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AppConstants.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                  ),
                  child: _authController.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Register',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: AppConstants.white,
                          ),
                        ),
                )),
            const SizedBox(height: 20),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    child: const Text('Forgot Password?',
                        style: TextStyle(decoration: TextDecoration.underline)),
                    onTap: () {
                      // Handle the tap.
                    },
                  ),
                  const SizedBox(width: 20),
                  InkWell(
                    child: const Text('Login',
                        style: TextStyle(decoration: TextDecoration.underline)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        )),
      ),
    );
  }
}
