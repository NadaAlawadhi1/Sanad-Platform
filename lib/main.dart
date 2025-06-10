import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:sanad_dashboared/navBar.dart';
import 'package:sanad_dashboared/services/share_preference.dart';
import 'package:sanad_dashboared/utils.dart';

void main() async {
  await setup();
  runApp(const MyApp());
}
Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupFirebase();
  await registerServices();
  await CashSaver.init();
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

              home: Navbar(),
    );
  }
}
