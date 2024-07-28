import 'package:dine_ease2/OtpScreen.dart';
import 'package:dine_ease2/components/my_button.dart';
import 'package:dine_ease2/components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:dine_ease2/LoginSignUpHandling.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Controllers for text fields
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();

  late String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Color(int.parse('0xFF927053'));
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView( // Added SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 80, 16, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png', // Replace with the actual path
                width: 120.0, // Adjust the width as needed
                height: 120.0, // Adjust the height as needed
              ),
              Container(
                alignment: Alignment.center,
                child: Center(
                  child: Text(
                    "Welcome to Dine Ease\nWhere Every Meal is a Celebration!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      // Add your other style properties here if needed
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              MyTextField(controller: phoneController, hintText: "Phone", obscureText: false),
              const SizedBox(height: 8.0),
              MyTextField(controller: usernameController, hintText: "Username", obscureText: false),
              const SizedBox(height: 8.0),
              MyTextField(controller: passwordController, hintText: "Password", obscureText: true),
              const SizedBox(height: 8.0),
              MyTextField(controller: firstnameController, hintText: "Firstname", obscureText: false),
              const SizedBox(height: 8.0),
              MyTextField(controller: lastnameController, hintText: "Lastname", obscureText: false),
              const SizedBox(height: 8.0),
              MyTextField(controller: emailController, hintText: "Email", obscureText: false),
              const SizedBox(height: 22.0),
              Text(errorMessage),
              const SizedBox(height: 12.0),
              MyButton(
                text: 'Sign Up',
                onTap: () async {
                  String ph = phoneController.text;
                  String id = usernameController.text;
                  String pass = passwordController.text;
                  String fn = firstnameController.text;
                  String ln = lastnameController.text;
                  String e = emailController.text;
                  if (ph.isEmpty || id.isEmpty || pass.isEmpty || fn.isEmpty || ln.isEmpty || e.isEmpty) {
                    setState(() {
                      errorMessage = "Please fill all fields";
                    });
                  } else {
                    phoneController.clear();
                    usernameController.clear();
                    passwordController.clear();
                    firstnameController.clear();
                    lastnameController.clear();
                    emailController.clear();
                    setState(() {
                      errorMessage = "";
                    });
                    String d = (await otp(e));
                    int otpNumber = int.parse(d);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OTPScreen(
                          receivedOTP: otpNumber,
                          firstName: fn,
                          lastname: ln,
                          emailAddress: e,
                          password: pass,
                          userID: id,
                          phoneNumber: ph,
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
