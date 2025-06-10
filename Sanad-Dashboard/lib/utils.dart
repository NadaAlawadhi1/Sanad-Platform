import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sanad_dashboared/firebase_options.dart';
import 'package:sanad_dashboared/services/alert_service.dart';
import 'package:sanad_dashboared/services/auth_service.dart';
import 'package:sanad_dashboared/services/database_service.dart';
import 'package:sanad_dashboared/services/media_service.dart';
import 'package:sanad_dashboared/services/storage_service.dart';

import 'services/navigation_service.dart';

class MyColors {
  static const Color skyBlue = Color(0xFF6CAEED);
  static const Color lightSkyBlue = Color(0xFF89CFF0);
  static const Color lightSteelBlue = Color(0xFFBDF0FE);
  static const Color lightCornflowerBlue = Color(0xFFDDEEFA);
  static const Color lightgray = Color(0xf5F5F5F5);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
}

double screenWidth = 0.0;
double screenHeight = 0.0;

final RegExp EMAIL_VALIDATION_REGEX =
    RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

final RegExp PASSWORD_VALIDATION_REGEX =
    RegExp(r"^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$");

final RegExp NAME_VALIDATION_REGEX = RegExp(r"\b([A-ZÀ-ÿ][-,a-z. ']+[ ]*)+");

const String PLACEHOLDER_PFP =
    "https://t3.ftcdn.net/jpg/05/16/27/58/360_F_516275801_f3Fsp17x6HQK0xQgDQEELoTuERO4SsWV.jpg";

final RegExp PHONE_VALIDATION_REGEX = RegExp(r"^\d{9}$");

Future<void> setupFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> registerServices() async {
  final GetIt getIt = GetIt.instance;
  getIt.registerSingleton<AuthService>(AuthService());
  getIt.registerSingleton<NavigationService>(NavigationService());
  getIt.registerSingleton<AlertService>(AlertService());
  getIt.registerSingleton<MediaService>(MediaService());
  getIt.registerSingleton<StorageService>(StorageService());
  getIt.registerSingleton<DatabaseService>(DatabaseService());
}

String generateChatID({required String uid1, required String uid2}) {
  List uids = [uid1, uid2];
  uids.sort();
  String chatID = uids.fold("", (id, uid) => "$id$uid");
  return chatID;
}

class SizeApp {
  static double s2 = 2.0;
  static double s5 = 5.0;
  static double s8 = 8.0;
  static double s10 = 10.0;
  static double s12 = 12.0;
  static double s15 = 15.0;
  static double s20 = 20.0;
  static double s24 = 24.0;
  static double s30 = 30.0;
  static double s40 = 40.0;
  static double s44 = 44.0;
  static double s50 = 50.0;
  static double s70 = 70.0;
  static double homeIcons = 60.0;
  static double icons = 100.0;
  static double smallIcons = 60.0;
  static double logoSize = 165.0;
  static double loginLogoSize = 300.0;
}
