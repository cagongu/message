import 'package:flutter/material.dart';
import 'package:message/dtos/request/RegisterRequest.dart';
import 'package:message/dtos/response/ApiResponse.dart';
import 'package:message/models/user.dart';
import 'package:message/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final User user = User(
    username: '',
    password: '',
    name: '',
    age: 0,
    email: '',
    activeStatus: true,
    chats: [],
  );
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 40),
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                // Input fields
                _buildTextFormField(
                    'Username', (value) => user.username = value!),
                SizedBox(height: 20),
                _buildTextFormField(
                    'Password', (value) => user.password = value!,
                    obscureText: true),
                SizedBox(height: 20),
                _buildTextFormField('Name', (value) => user.name = value!),
                SizedBox(height: 20),
                _buildTextFormField('Email', (value) => user.email = value!),
                SizedBox(height: 20),
                _buildTextFormField(
                    'Age', (value) => user.age = int.tryParse(value!) ?? 0,
                    keyboardType: TextInputType.number),
                SizedBox(height: 20),

                // Register button

                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _handleRegister,
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                SizedBox(height: 20),
                // Error message
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),

                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/');
                      },
                      child: Text(
                        ' Login',
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
      {bool obscureText = false,
      TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      onSaved: onSaved,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label is required';
        }
        return null;
      },
    );
  }

  // Handle registration
  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Create the register request object
      RegisterRequest request = RegisterRequest(
          username: user.username,
          password: user.password,
          name: user.name,
          age: user.age,
          email: user.email);

      // Call the register method
      ApiResponse<User> response = await _authService.register(request);

      setState(() {
        _isLoading = false;
      });

      // Check the response
      if (response.code == 200) {
        Navigator.pushReplacementNamed(context, '/');
      } else {
        setState(() {
          _errorMessage = response.message ?? 'An unknown error occurred';
        });
      }
    }
  }
}
