import 'package:flutter/material.dart';
import 'package:spynetra_tmp/pages/main_screen.dart';
import 'package:spynetra_tmp/constants/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Returning false disables the back button
        return false;
      },
      child: Scaffold(
        backgroundColor: Pallete.screen,
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              constraints: const BoxConstraints(
                maxWidth: 400, // for desktop
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      width: 200,
                      height: 200,
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'LogIn',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Pallete.title,
                      ),
                    ),
                    const SizedBox(height: 32.0),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(color: Pallete.text),
                      ),
                      style: const TextStyle(color: Pallete.text),
                      cursorColor: Pallete.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Username is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: const OutlineInputBorder(),
                        labelStyle: const TextStyle(color: Pallete.text),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Pallete.text,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      style: const TextStyle(color: Pallete.text),
                      cursorColor: Pallete.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24.0),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainScreen()),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Pallete.card, // or another color you prefer
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Pallete.title),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
