import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:dine_ease2/Pages/DealsScreen.dart';



import 'Pages/Home.dart';
import 'Pages/NotificationScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedPageIndex = 0;

  void _onTapPageChanger(int index){
    setState(() {
      _selectedPageIndex = index;
    });
  }
  final List<Widget> _pages= [
    Home() ,
    DealsScreen() ,
    NotificationScreen(),
  ];


  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).colorScheme.secondary;
    return Scaffold(
      // backgroundColor: Theme.of(context).colorScheme.background,
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: GNav(
        gap: 10.0,
        // color: Colors.black,
        color: Theme.of(context).colorScheme.inversePrimary,
        // activeColor: Colors.white,
        backgroundColor: backgroundColor,
        padding: EdgeInsets.all(16),
        onTabChange: _onTapPageChanger,
        tabs: const [
          GButton(icon: Icons.home ,
          text: 'Home',) ,
          GButton(icon: Icons.food_bank ,
            text: 'Orders',) ,
          GButton(icon: Icons.notifications ,
            text: 'Notifications',) ,

        ],
      ),
    );
  }
}
