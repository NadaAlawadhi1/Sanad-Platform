import 'package:flutter/material.dart';
import 'package:sanad_therapists/screens/MyPatient_list/messages.dart';
import 'package:sanad_therapists/screens/calendar_screen.dart';
import 'package:sanad_therapists/screens/home.dart';
import 'package:sanad_therapists/screens/notes_screen.dart';
import 'package:sanad_therapists/utils.dart';

import 'screens/settings_screeen.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Widget currentPage = Home(); // Set initial page
  int currentIndex = 0; // Track the current index for bottom navigation

  void onTabTapped(int index) {
    setState(() {
      switch (index) {
        case 0:
          currentPage = const Home();
          break;
        case 1:
          currentPage = const Chatting();
          break;
        case 2:
          currentPage = const CalendarScreen();
          break;
        case 3:
          currentPage = const NotesScreen();
          break;
            case 4:
          currentPage = const SettingsScreen();
          break;
      }
      currentIndex = index; // Update the current index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPage, // Display the current page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex, // Set the current index
        onTap: onTabTapped, // Handle tab taps
        backgroundColor: Colors.grey[200], // Set background color
        selectedItemColor: MyColors.skyBlue, // Set selected item color
        unselectedItemColor: MyColors.skyBlue, // Set unselected item color
        items: [
          BottomNavigationBarItem(
            icon: Container(
              width: 40, // Fixed width
              height: 40, // Fixed height
              child: Image.asset(
                "assets/images/logo2.png",
                height: 30,
                width: 30, 
              ),
            ),
            label: '', // Empty label
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: 40, // Fixed width
              height: 40, // Fixed height
              child: Icon(Icons.chat, size: 30), // Fixed icon size
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: 40, // Fixed width
              height: 40, // Fixed height
              child: Icon(Icons.calendar_month_rounded, size: 30), // Fixed icon size
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: 40, // Fixed width
              height: 40, // Fixed height
              child: Icon(Icons.notes, size: 30), // Fixed icon size
            ),
            label: '',
          ),
           BottomNavigationBarItem(
            icon: Container(
              width: 40, // Fixed width
              height: 40, // Fixed height
              child: Icon(Icons.account_circle, size: 30), // Account icon
            ),
            label: '', // Empty label for account icon
          ),
        ],
      ),
    );
  }
}

