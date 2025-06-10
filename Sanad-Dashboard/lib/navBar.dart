// navbar.dart
import 'package:flutter/material.dart';
import 'package:sanad_dashboared/screens/complaint_screem.dart';
import 'package:sanad_dashboared/screens/joinTherapist_screen.dart';
import 'package:sanad_dashboared/screens/therapistAccount_screen.dart';
import 'package:sanad_dashboared/utils.dart'; // Import your colors or utils

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  bool isExpanded = false;
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: isExpanded,
            backgroundColor: MyColors.skyBlue,
            unselectedIconTheme: const IconThemeData(color: MyColors.white),
            unselectedLabelTextStyle: const TextStyle(color: MyColors.white),
            selectedIconTheme: const IconThemeData(color: MyColors.skyBlue),
            selectedLabelTextStyle: const TextStyle(color: MyColors.white),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text("Therapist Account"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.feedback),
                label: Text("Complaints"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.description),
                label: Text("Join Therapist"),
              ),
            ],
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isExpanded = !isExpanded;
                            });
                          },
                          icon: const Icon(Icons.menu),
                        ),
                        Image.asset(
                          'assets/images/logo1.png',
                          width: 200,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                    if (selectedIndex == 0)
                      const TherapistaccountScreen()
                    else if (selectedIndex == 1)
                      AdminComplaintsScreen()
                    else if (selectedIndex == 2)
                      const JoinTherapistScreen()
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
