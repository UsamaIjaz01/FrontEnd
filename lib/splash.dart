import 'package:flutter/material.dart';
import 'package:dine_ease2/LoginSignUpHandling.dart';
import 'package:dine_ease2/LoginScreen.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  void initState(){
    super.initState();
    _navigateToLoginScreen();
  }

  _navigateToLoginScreen() async  {
    await Future.delayed(Duration(milliseconds: 2000), (){});
    Navigator.pushReplacement(
      context,
    MaterialPageRoute(builder: (context) => LoginScreen())
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            children: [
              Image.asset(
                'assets/images/logo.png', // Replace with the actual path
                width: 200.0, // Adjust the width as needed
                height: 200.0, // Adjust the height as needed
              ),
              Text(
                'MAKE EVERY MEAL SPECIAL',
                textAlign: TextAlign.center, style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                letterSpacing: 2,
              ),// Center text horizontally
              ),


            ],
          ),
        ),
      ),
    );
  }
}
