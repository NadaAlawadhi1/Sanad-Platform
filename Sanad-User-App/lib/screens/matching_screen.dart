import 'package:flutter/material.dart';
import 'package:sanad/screens/questionnaire_screen.dart';
import 'package:sanad/utils.dart';

class MatchingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: MyColors.lightSkyBlue,
                    size: 25,
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Navigate back
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Text(
                      'What type of service are you looking for?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuestionnaireScreen(serviceTitle: 'Therapy'),
                        ),
                      );
                    },
                    child: ServiceCard(
                      title: 'Therapy',
                      description: 'Individualized support from a licensed therapist for ages 18+',
                      color: MyColors.skyBlue,
                      icon: Icons.person,
                    ),
                  ),
                  SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuestionnaireScreen(serviceTitle: 'Teen Therapy'),
                        ),
                      );
                    },
                    child: ServiceCard(
                      title: 'Teen Therapy',
                      description: 'Specialized support designed for youth ages 13–17',
                      color: MyColors.lightSkyBlue,
                      icon: Icons.emoji_people,
                    ),
                  ),
                  SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuestionnaireScreen(serviceTitle: 'Couples Therapy'),
                        ),
                      );
                    },
                    child: ServiceCard(
                      title: 'Couples Therapy',
                      description: 'Relationship support to improve your connection with your partner',
                      color: MyColors.skyBlue,
                      icon: Icons.favorite,
                    ),
                  ),
                  SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuestionnaireScreen(serviceTitle: 'Psychiatry'),
                        ),
                      );
                    },
                    child: ServiceCard(
                      title: 'Psychiatry',
                      description: 'Psychiatric evaluations, diagnoses, and medication',
                      color: MyColors.lightSkyBlue,
                      icon: Icons.medical_services,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String title;
  final String description;
  final Color color;
  final IconData icon;

  const ServiceCard({
    required this.title,
    required this.description,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ],
      ),
    );
  }
}