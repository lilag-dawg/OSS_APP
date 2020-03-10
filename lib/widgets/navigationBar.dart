import 'package:flutter/material.dart';

import '../screens/activities_screen.dart';
import '../screens/home_screen.dart';
import '../screens/settings_screen.dart';

class MyNavigationBar extends StatefulWidget {
  @override
  _MyNavigationBarState createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {

  int _selectedIndex = 1;
  final List<Widget> _children =[
    ActivitiesScreen(),
    HomeScreen(),
    SettingsScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:_children[_selectedIndex],   
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        items:[
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bike),
            title: Text("Activities")
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Home")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text("Setting")
          ),         
      ]
      ),
      
    );
  }
}