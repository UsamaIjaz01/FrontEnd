import 'package:dine_ease2/ForgetPasswordScreen.dart';
import 'package:dine_ease2/HomeScreen.dart';
import 'package:dine_ease2/SignInScreen.dart';
import 'package:dine_ease2/components/my_button.dart';
import 'package:dine_ease2/components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:dine_ease2/LoginSignUpHandling.dart';




class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late String errorMessage = " ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png', // Replace with the actual path
              width: 150.0, // Adjust the width as needed
              height: 150.0, // Adjust the height as needed
            ),

            MyTextField(controller: _idController, hintText: "ID", obscureText: false),
            const SizedBox(height: 20),
            MyTextField(controller: _passwordController, hintText: "Password", obscureText: true),
            const SizedBox(height: 10),
            Text(errorMessage),
            const SizedBox(height: 10),
            MyButton(text: "Login" , onTap:() async {
              String id = _idController.text; // Get the ID entered by the user
              String password = _passwordController.text; // Get the password entered by the user
              if(id.isEmpty || password.isEmpty){
                setState(() {
                  errorMessage = "Please fill both fields";
                });
              } else {
                if(await loginUser(id, password)){
                  setState(() {
                    errorMessage="";
                  });

                  _idController.clear();
                  _passwordController.clear();
                  // Perform login logic here
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                } else {
                  print("in else else else -------------------------------------------------------------------");
                  setState(() {
                    _idController.clear();
                    _passwordController.clear();
                    errorMessage = "Invalid credentials";
                  });
                }
              }

            }, ),

            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForgetPasswordScreen()),
                  );

                }, child: const Text("Forget Password ?"))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Not a member?" ,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ) ,
                TextButton(
                  onPressed: () {
                    // Perform signup logic here
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  child:  Text('Signup' ,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

