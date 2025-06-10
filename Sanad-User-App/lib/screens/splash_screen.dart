import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:sanad/generated/l10n.dart";
import "package:sanad/screens/intro_screens.dart";
import "package:sanad/utils.dart";

class Welcome extends StatefulWidget {
  const Welcome({super.key,});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
   Future.delayed(Duration(seconds: 2), () {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const IntroviewScreens()),
      );
    }
  });
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const  BoxDecoration(
          gradient: LinearGradient(
            colors: [ MyColors.skyBlue, MyColors.lightCornflowerBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo2.png',
                height: 150,
                width: 150,
              ),
              Text(
                S.of(context).welcomeText,
                style: const TextStyle(
                  color: MyColors.white,
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Adamina', // Use the specified font family
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                 S.of(context).warningMassage,
                style: TextStyle(
                  fontSize: 10,
                ),
                textAlign:
                    TextAlign.center, // Center the text within the column
              ),
            ],
          ),
        ),
      ),
    );
  }
}
