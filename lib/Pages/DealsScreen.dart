import 'package:flutter/material.dart';
class DealsScreen extends StatefulWidget {
  const DealsScreen({super.key});

  @override
  State<DealsScreen> createState() => _DealsScreenState();
}

class _DealsScreenState extends State<DealsScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Text("This is deals screen"),
    );
  }
}
