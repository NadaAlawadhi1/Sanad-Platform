import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sanad_therapists/generated/l10n.dart';
import '../utils.dart';
import 'package:sanad_therapists/services/alert_service.dart';
import 'package:sanad_therapists/services/navigation_service.dart';

class Jointherapist extends StatefulWidget {
  const Jointherapist({super.key});

  @override
  State<Jointherapist> createState() => _JointherapistState();
}

class _JointherapistState extends State<Jointherapist> {
  late NavigationService _navigationService;

  @override
  void initState() {
    super.initState();
    // Initialize services
    _navigationService = GetIt.instance.get<NavigationService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.lightCornflowerBlue,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: MyColors.skyBlue,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            joinFirstPart(),
            requirementsSection(),
          ],
        ),
      ),
    );
  }

  Widget joinFirstPart() {
    return Container(
      color: MyColors.lightCornflowerBlue,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 60),
          Text(
            S.of(context).joinTherapistMainText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _navigationService.pushNamed('/applyForm');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColors.skyBlue, // Button background color
              foregroundColor: MyColors.white, // Button text color
              padding:
                  const EdgeInsets.symmetric(vertical: 12), // Button height
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Rounded corners
              ),
            ),
            child: Text(S.of(context).applyButton),
          ),
          SizedBox(
            height: 100,
          )
        ],
      ),
    );
  }

  Widget requirementsSection() {
    return Container(
      color: MyColors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).requirementsTitle,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              requirementCard(
                S.of(context).requirements1,
                Icons.verified_rounded, // Example icon
              ),
              requirementCard(
                S.of(context).requirements2,
                Icons.school, // Example icon
              ),
              requirementCard(
                S.of(context).requirements3,
                Icons.local_hospital_rounded, // Example icon
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget requirementCard(String text, IconData icon) {
    return Stack(
      alignment: Alignment.topCenter, // Aligns the icon at the top center
      children: [
        Center(
          child: Column(
            children: [
              Container(
                child: Padding(
                  padding: EdgeInsets.only(top: 35),
                  child: Container(
                    width: 250,
                    height: 150,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color:
                          MyColors.lightCornflowerBlue, // Light blue background
                      borderRadius:
                          BorderRadius.circular(16), // Rounded corners
                    ),
                    padding: const EdgeInsets.only(
                        top: 40, bottom: 16), // Add top padding for the icon
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: Text(
                        text,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black), // Text color
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
        Positioned(
          top: 0, // Position the icon at the top
          child: Container(
            width: 60,
            height: 60,
            margin:
                const EdgeInsets.only(bottom: 8), // Space between icon and text

            decoration: BoxDecoration(
              color: MyColors.lightCornflowerBlue, // Light blue background
              borderRadius: BorderRadius.circular(16), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // Changes position of shadow
                ),
              ],
            ),
            child: Icon(
              icon,
              color: MyColors.skyBlue, // Icon color
              size: 30, // Icon size
            ),
          ),
        ),
      ],
    );
  }
}
