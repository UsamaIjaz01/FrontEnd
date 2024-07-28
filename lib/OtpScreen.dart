import 'package:flutter/material.dart';
import 'LoginSignUpHandling.dart';

class OTPScreen extends StatelessWidget {
  final List<TextEditingController> _controllers =
  List.generate(6, (index) => TextEditingController());
  final int receivedOTP;
  final String firstName , lastname , emailAddress , password , userID , phoneNumber;

  OTPScreen({required this.receivedOTP, required this.firstName, required this.lastname, required this.emailAddress, required this.password, required this.userID, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Color(int.parse('0xFF927053'));
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Enter Your OTP Please",
              style: TextStyle(
                fontWeight: FontWeight.bold, // Make the text bold
                fontSize: 18, // Increase the font size
                fontFamily: 'Roboto', // Specify a custom font family if needed
                // You can add more styling properties here
              ),
            ),

            const SizedBox(height: 22.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                6,
                    (index) => OTPDigitBox(
                  controller: _controllers[index],
                  focusNode: FocusNode(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                verifyOTP(receivedOTP , context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white), // Set the background color
              ),
              child: const Text('Verify' , style: TextStyle(
                color: Colors.black,

              ),),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white), // Set the background color
              ),
              child: const Text('Back' , style: TextStyle(
                color: Colors.black,

              ),),
            ),
          ],
        ),
      ),
    );
  }

  void verifyOTP(int receivedOTP, BuildContext context) {
    String otp = '';
    for (var controller in _controllers) {
      otp += controller.text;
    }
    int enteredOTP = int.tryParse(otp) ?? 0; // Use int.tryParse to handle invalid input
    if (enteredOTP == receivedOTP) {
      createAccount(userID , password , firstName , lastname , phoneNumber , emailAddress);
      // Show dialog for successful OTP verification
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Congratulations!'),
            content: Text('Your account has been created. Please login using your credentials.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pop(); // Pop the current screen
                  Navigator.of(context).pop(); // Pop the signIn Screen
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Show dialog for wrong OTP
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Wrong OTP'),
            content: Text('The OTP you entered is incorrect. Please try again.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

}

class OTPDigitBox extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const OTPDigitBox({
    Key? key,
    required this.controller,
    required this.focusNode,
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: TextStyle(fontSize: 24),
        decoration: InputDecoration(
          counter: Offstage(),
          border: InputBorder.none,
        ),
        onChanged: (value) {
          if (value.length == 1) {
            widget.focusNode.nextFocus();
          }
        },
      ),
    );
  }
}
