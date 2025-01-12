import 'package:flutter/material.dart';
import 'package:message/services/auth_service.dart';
import 'package:message/dtos/request/LoginRequest.dart';
import 'package:message/dtos/response/ApiResponse.dart';
import 'package:message/models/user.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final LoginRequest user = LoginRequest(username: '', password: '');
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 60),
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 40),
                // Username field
                _buildTextFormField('Username', (value) => user.username = value!),
                SizedBox(height: 20),
                // Password field
                _buildTextFormField(
                  'Password',
                  (value) => user.password = value!,
                  obscureText: true,
                ),
                SizedBox(height: 30),
                // Login button
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                SizedBox(height: 10),
                // Error message
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Custom TextFormField widget
  TextFormField _buildTextFormField(String label, Function(String?) onSaved,
      {bool obscureText = false}) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      obscureText: obscureText,
      onSaved: onSaved,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label is required';
        }
        return null;
      },
    );
  }

  // Handle login
  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Create the login request object
      LoginRequest request = LoginRequest(
        username: user.username,
        password: user.password,
      );

      // Call the login method
      ApiResponse<User> response = await _authService.login(request);

      setState(() {
        _isLoading = false;
      });

      // Check the response
      if (response.code == 200) {
        // Redirect to the home page after successful login
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() {
          _errorMessage = response.message ?? 'An unknown error occurred';
        });
      }
    }
  }
}
