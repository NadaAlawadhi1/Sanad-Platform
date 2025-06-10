import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sanad/generated/l10n.dart';
import 'package:sanad/screens/calendar_screen.dart';
import 'package:sanad/screens/chatPage/messages.dart';
import 'package:sanad/screens/home.dart';
import 'package:sanad/screens/notes_screen.dart';
import 'package:sanad/screens/settings_screen.dart';
import 'package:sanad/screens/Therapists/therapists.dart';
import 'package:sanad/services/database_service.dart';
import 'package:sanad/services/navigation_service.dart';
import 'package:sanad/utils.dart';

import 'services/notification_service.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Widget currentPage = Home(); // Set initial page
  int currentIndex = 0; // Track the current index for bottom navigation
  bool showAvatar = true; // Variable to track avatar visibility

  void onTabTapped(int index) {
    switch (index) {
      case 0: // Home
        setState(() {
          currentPage = Home();
          showAvatar = true; // Show avatar
        });
        break;
      case 1: // Therapists
        setState(() {
          currentPage = const Therapists();
          showAvatar = true; // Show avatar
        });
        break;
      case 2: // Chatting
        setState(() {
          currentPage = Chatting();
          showAvatar = false; // Hide avatar
        });
        break;
      case 3: // Calendar
        setState(() {
          currentPage = CalendarScreen();
          showAvatar = false; // Hide avatar
        });
        break;
      case 4: // Notes
        setState(() {
          currentPage = NotesScreen();
          showAvatar = false; // Hide avatar
        });
        break;
    }
    currentIndex = index; // Update the current index
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: currentPage),
          if (showAvatar) // Conditionally show the avatar
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsScreen()),
                    );
                  },
                  child: CircleAvatar(
                    radius: SizeApp.s30,
                    backgroundColor: const Color.fromARGB(245, 251, 249, 249),
                    child: ClipOval(
                      child: DatabaseService.me.image != null &&
                              DatabaseService.me.image.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: DatabaseService.me.image,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(
                                color: MyColors.skyBlue,
                              ),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.person,
                                size: 50,
                                color: Color.fromARGB(255, 175, 217, 247),
                              ),
                              imageBuilder: (context, imageProvider) =>
                                  CircleAvatar(
                                radius: 50,
                                backgroundImage: imageProvider,
                              ),
                            )
                          : const Icon(
                              Icons.person,
                              size: 50,
                              color: Color.fromARGB(255, 195, 227, 250),
                            ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTabTapped,
        backgroundColor: MyColors.lightgray,
        selectedItemColor: MyColors.skyBlue,
        unselectedItemColor: MyColors.skyBlue,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/logo2.png",
              height: 40,
              width: 40,
            ),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.assignment_ind, size: 30),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.chat, size: 30),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_rounded, size: 30),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.notes, size: 30),
            label: '',
          ),
        ],
      ),
    );
  }
}
