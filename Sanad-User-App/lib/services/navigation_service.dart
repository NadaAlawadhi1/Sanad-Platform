import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sanad/mainPage.dart';
import 'package:sanad/screens/calendar_screen.dart';
import 'package:sanad/screens/intro_screens.dart';
import 'package:sanad/screens/login.dart';
import 'package:sanad/screens/matching_screen.dart';
import 'package:sanad/screens/notes_screen.dart';
import 'package:sanad/screens/settings_screen.dart';
import 'package:sanad/screens/signin.dart';
import 'package:flutter/material.dart';
import "package:sanad/screens/chatPage/messages.dart";
import 'package:sanad/screens/splash_screen.dart';
import 'package:sanad/widgets/rating_dialog.dart';

class NavigationService {
  late GlobalKey<NavigatorState> _navigatorKey;
  final Map<String, Widget Function(BuildContext)> _routes = {
    "/main": (context) => MainPage(),
    "/settings": (context) => SettingsScreen(),
    "/welcome": (context) => const Welcome(),
    "/chatting": (context) => const Chatting(),
    "/intro": (context) => const IntroviewScreens(),
    "/signin": (context) => const Signin(),
    "/login": (context) => const Login(),
    "/notes": (context) => NotesScreen(),
    "/calendar": (context) => CalendarScreen(),
    "/matching": (context) => MatchingScreen(),

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
