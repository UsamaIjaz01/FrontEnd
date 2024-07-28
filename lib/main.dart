


import 'package:dine_ease2/splash.dart';
import 'package:dine_ease2/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';



void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // Stripe.publishableKey = "pk_test_51PN7KfJhUYgoC6Lz1CSmxsmV4V2ijNKHIqkEOdMFNXZz1ABWn8oFLUH61Gy9pL4Zjocktchy7lvWvEyUUFPIdlJI00rimUDntV";

  runApp(
      ChangeNotifierProvider(create: (context) => ThemeProvider(),
      child: const MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      // title: 'Dine Ease',
      debugShowCheckedModeBanner: false,
      home: splashScreen(),
      theme:  Provider.of<ThemeProvider>(context).themeData,
    );
  }
}

