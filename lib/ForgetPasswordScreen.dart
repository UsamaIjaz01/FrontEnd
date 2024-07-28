import 'package:dine_ease2/ForgetPasswordHandling.dart';
import 'package:dine_ease2/components/my_button.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'OTPVerficationForgetPassword.dart';

class ForgetPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20.0),
                Image.asset(
                  'assets/images/forgetPassowrd.png',
                  width: 350,
                  height: 350,
                ),
                const SizedBox(height: 20),
                Text(
                  'Enter your email address and we’ll send you an OTP to reset your password.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.inversePrimary, // Font color
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Enter your Gmail',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!EmailValidator.validate(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                // MyTextField(controller: emailController, hintText: "Email", obscureText: false , ),
                const SizedBox(height: 20),
                MyButton(text: "Send OTP" ,
                  onTap: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Implement send OTP logic here
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('OTP sent to your email')),
                      );

                      // Call the function to get user by email
                      final user = await getUserByEmail(emailController.text);

                      if (user != null) {
                        print("------------------");
                        print(user['otp']);
                        // User found, navigate to OTP verification screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OTPVerificationForgetPassword( email: emailController.text , otpNumber: user['otp'],),
                          ),
                        );
                      } else {
                        // User not found, show a message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('No user found with this email address')),
                        );
                      }
                    }
                  },
                ) ,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
