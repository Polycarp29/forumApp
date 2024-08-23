import 'package:flutter/material.dart';
import 'package:forum_app/appfiles/views/auth/register.dart';
import 'package:forum_app/appfiles/views/widgets/textfield.dart';
import 'package:forum_app/constants/appconstants.dart';
import 'package:forum_app/controllers/appcomtroller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Define the controllers for the TextFields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthenticationController _authController =
      Get.put(AuthenticationController());

  String? _usernameError;
  String? _passwordError;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    setState(() {
      _usernameError = username.isEmpty ? 'Username is required' : null;
      _passwordError = password.isEmpty ? 'Password is required' : null;
    });

    if (_usernameError == null && _passwordError == null) {
      final accessToken = await _authController.login(
        username: username,
        password: password,
      );
      if (accessToken != null) {
        Get.snackbar(
          'Success',
          'Login Successful',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppConstants.greenColor,
          colorText: AppConstants.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Login failed. Please try again.',
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
              Text(
                'LOGIN',
                style: GoogleFonts.poppins(fontSize: 30),
              ),
              const SizedBox(height: 30),
              // Username TextField
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
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 20),
              // Password TextField
              TexfieldWidget(
                hint: 'Password',
                iconData: Icons.lock,
                iconColor: AppConstants.black,
                inputColor: AppConstants.darkGrey,
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: AppConstants.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
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
              // Login Button
              ElevatedButton(
                onPressed: _authController.isLoading.value ? null : _login,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: AppConstants.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                ),
                child: Obx(() {
                  return _authController.isLoading.value
                      ? CircularProgressIndicator(
                          color: AppConstants.white,
                        )
                      : Text('Login',
                          style: GoogleFonts.poppins(
                              fontSize: 18, color: AppConstants.white));
                }),
              ),
              const SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      child: const Text('Forgot Password?',
                          style:
                              TextStyle(decoration: TextDecoration.underline)),
                      onTap: () {
                        // Handle the tap.
                      },
                      onHover: (value) {
                        // Optionally handle mouse hover.
                      },
                    ),
                    const SizedBox(width: 15),
                    InkWell(
                      child: const Text('Register',
                          style:
                              TextStyle(decoration: TextDecoration.underline)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterPage()),
                        );
                      },
                      onHover: (value) {
                        // Optionally handle mouse hover.
                      },
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
