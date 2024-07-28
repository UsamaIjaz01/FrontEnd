import 'package:dine_ease2/components/my_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'LoginScreen.dart';

class NewPasswordScreen extends StatefulWidget {
  final String email;

  const NewPasswordScreen({required this.email});

  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscureText = true;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 46, 16, 0),
          child: Column(
            children: [

              Image.asset(
                'assets/images/newpassword.png',
                width: 300,
                height: 300,
              ),
              const SizedBox(height: 10),
              const Text(
                'Please enter your new password and confirm it to update your account credentials.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                child: TextField(
                  controller: _newPasswordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                child: TextField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: 'Confirm New Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                ),
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(height: 20),
              MyButton(text: "Update" ,
              onTap: _validateAndSubmit,
              ),

            ],
          ),
        ),
      ),
    );
  }

  void _validateAndSubmit() {
    setState(() {
      _errorMessage = null;
    });

    if (_newPasswordController.text == _confirmPasswordController.text) {
      updatePassword(widget.email, _newPasswordController.text);
    } else {
      setState(() {
        _errorMessage = 'Passwords do not match';
      });
    }
  }

  Future<void> updatePassword(String email, String newPassword) async {
    final url = Uri.parse('http://192.168.0.139:3000/forgetPassword'); // Replace with your server URL
    final headers = {"Content-Type": "application/json"};
    final body = json.encode({'email': email, 'newPassword': newPassword});

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print('Password updated successfully');
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()), // Replace LoginScreen() with your login screen widget
              (Route<dynamic> route) => false, // Remove all previous routes
        );
      } else {
        final responseBody = json.decode(response.body);
        print('Failed to update password: ${responseBody['message']}');
        setState(() {
          _errorMessage = 'Failed to update password: ${responseBody['message']}';
        });
      }
    } catch (e) {
      print('Error updating password: $e');
      setState(() {
        _errorMessage = 'Error updating password: $e';
      });
    }
  }
}
