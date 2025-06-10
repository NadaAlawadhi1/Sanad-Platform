import 'package:flutter/material.dart';
import 'package:sanad_therapists/services/database_service.dart';
import 'package:sanad_therapists/utils.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
   setState(() {
     DatabaseService.getSelfInfo();
   });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [MyColors.white, MyColors.lightCornflowerBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Container(
              color: MyColors.white,
              height: 60,
            ),
            Container(
              width: double.infinity,
              height: 300, // Adjust height as needed
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/therapist_main.jpg'),
                  fit: BoxFit.cover,
                ),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(90)),
              ),
            ),
            const SizedBox(height: 10),
            // Title section

             Text(
              "Welcome ${DatabaseService.me.name}",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: MyColors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            // Description section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "You are making a difference, one session at a time! Remember to check in on your patients' well-being today. Your care matters! ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: MyColors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
