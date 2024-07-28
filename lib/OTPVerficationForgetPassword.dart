import 'package:dine_ease2/components/my_button.dart';
import 'package:flutter/material.dart';
import 'package:dine_ease2/LoginSignUpHandling.dart';
import 'package:dine_ease2/NewPasswordScreen.dart';

class OTPVerificationForgetPassword extends StatefulWidget {
  final String email;
  final String otpNumber;
  OTPVerificationForgetPassword({required this.email , required this.otpNumber});

  @override
  _OTPVerificationForgetPasswordState createState() => _OTPVerificationForgetPasswordState();
}

class _OTPVerificationForgetPasswordState extends State<OTPVerificationForgetPassword> {
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  Color backgroundColor = Color(int.parse('0x000000'));
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Image.asset(
              'assets/images/otp.png',
              width: 350,
              height: 350,
            ),
            const SizedBox(height: 20),
            const Text("We've sent your OTP to given Email." ,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                6,
                    (index) => OTPDigitBox(
                  controller: _controllers[index],
                ),
              ),
            ),
            const SizedBox(height: 20),
            MyButton(text: "Verify" ,
            onTap:  () {
              verifyOTP(context);
              },
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     verifyOTP(context);
            //   },
            //   style: ElevatedButton.styleFrom(
            //     primary: const Color(0xFF927053), // Button background color
            //     onPrimary: Colors.white, // Text color
            //     padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            //     textStyle: const TextStyle(
            //       fontSize: 16,
            //       fontWeight: FontWeight.bold,
            //     ),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(20), // Rounded corners
            //     ),
            //   ),
            //   child: const Text('Verify OTP'),
            // ),
          ],
        ),
      ),
    );
  }

  void verifyOTP(BuildContext context) {
    String otp = _controllers.map((controller) => controller.text).join('');
    int receivedOTP = 123456; // Replace with actual received OTP
    int enteredOTP = int.tryParse(otp) ?? 0; // Use int.tryParse to handle invalid input
    int parsedOtpNumber = int.parse(widget.otpNumber);
    if (enteredOTP == parsedOtpNumber) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewPasswordScreen(email: widget.email),
        ),
      );

    } else {
      // Show dialog for wrong OTP
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Wrong OTP'),
            content: Text('The OTP you entered is incorrect. Please try again. ${widget.otpNumber}'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void createAccount(BuildContext context) {
    // Replace with your account creation logic
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Account Created'),
          content: Text('Your account has been successfully created.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Pop the current screen
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class OTPDigitBox extends StatefulWidget {
  final TextEditingController controller;

  const OTPDigitBox({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  _OTPDigitBoxState createState() => _OTPDigitBoxState();
}

class _OTPDigitBoxState extends State<OTPDigitBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary, // Background color
        borderRadius: BorderRadius.circular(3),
      ),
      child: TextField(
        controller: widget.controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(fontSize: 24),
        decoration: const InputDecoration(
          counter: Offstage(),
          border: InputBorder.none,
        ),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus(); // Move focus to the next widget
          }
        },
      ),
    );
  }
}
