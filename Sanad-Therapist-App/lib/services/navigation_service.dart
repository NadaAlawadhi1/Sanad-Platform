import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sanad_therapists/mainPage.dart';
import 'package:sanad_therapists/screens/MyPatient_list/messages.dart';
import 'package:sanad_therapists/screens/applicationForm_screen.dart';
import 'package:sanad_therapists/screens/calendar_screen.dart';
import 'package:flutter/material.dart';

import 'package:sanad_therapists/screens/home.dart';
import 'package:sanad_therapists/screens/joinTherapist_screen.dart';
import 'package:sanad_therapists/screens/login.dart';
import 'package:sanad_therapists/screens/notes_screen.dart';

class NavigationService {
  late GlobalKey<NavigatorState> _navigatorKey;
  final Map<String, Widget Function(BuildContext)> _routes = {
    "/main": (context) => MainPage(),
    "/chatting": (context) => const Chatting(),
    "/login": (context) => const Login(),
    "/notes": (context) => NotesScreen(),
    "/calendar": (context) => CalendarScreen(),
    "/join": (context) => Jointherapist(),
    "/applyForm": (context) => ApplicationForm(),
  };
  GlobalKey<NavigatorState>? get navigatorKey {
    return _navigatorKey;
  }

  Map<String, Widget Function(BuildContext)> get routes {
    return _routes;
  }

  NavigationService() {
    _navigatorKey = GlobalKey<NavigatorState>();
  }

  void push(MaterialPageRoute route) {
    _navigatorKey.currentState?.push(route);
  }

  void pushNamed(String routeName) {
    _navigatorKey.currentState?.pushNamed(routeName);
  }

  void pushReplacementNamed(String routeName) {
    _navigatorKey.currentState?.pushReplacementNamed(routeName);
  }

  void goBack() {
    _navigatorKey.currentState?.pop();
  }
}
