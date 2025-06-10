import 'package:flutter/material.dart';
import 'package:sanad/screens/login.dart';
import 'package:sanad/utils.dart';

class QuestionnaireScreen extends StatefulWidget {
  final String serviceTitle;

  QuestionnaireScreen({required this.serviceTitle});

  @override
  _QuestionnaireScreenState createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  int currentQuestionIndex = 0;
  List<String> answers = [];

  final Map<String, List<List<String>>> questionsMap = {
    'Therapy': [
        [
        "The price you can afford:",
        "1000 to 3000 / Hour",
        "4000 to 6000 / Hour",
      ],
      [
        "To begin, tell us why you're looking for help today:",
        "I'm feeling anxious or panicky",
        "I'm having difficulty in my relationship",
        "A traumatic experience (past or present)",
        "I've been having trouble sleeping",
        "I'm navigating addiction or difficulty with substance abuse",
        "I'm feeling down or depressed",
        "I'm dealing with stress at work or school",
        "Something else",
      ],
      [
        "How would you rate your sleeping habits?",
        "Excellent",
        "Good",
        "Fair",
        "Poor",
      ],
      [
        "How would you rate your current physical health?",
        "Excellent",
        "Good",
        "Fair",
        "Poor",
      ],
      [
        "What gender do you identify with?",
        "Female",
        "Male",
      ],
      [
        "What gender would you prefer in a provider?",
        "Female",
        "Male",
        "No preference",
      ],
      [
        "What city do you live in most of the year?\n(We’ll find you a licensed provider in that city)",
        "Ibb",
        "Sana'a",
        "Aden",
        "Mukala",
        "Taiz",
        "Hodeidah",
        "Dhamar",
        "Al-Mukha",
        "Al-Jawf",
        "Marib",
        "Raymah",
        "Amran",
        "Sa'dah",
        "Al-Bayda",
      ],
    ],
    'Teen Therapy': [
      [
        "The price you can afford:",
        "1000 to 3000 / Hour",
        "4000 to 6000 / Hour",
      ],
      [
        "To begin, tell us why you're looking for help today:",
        "I'm feeling anxious or panicky",
        "I'm having difficulty in my relationship",
        "A traumatic experience (past or present)",
        "I've been having trouble sleeping",
        "I'm navigating addiction or difficulty with substance abuse",
        "I'm feeling down or depressed",
        "I'm dealing with stress at work or school",
        "Something else",
      ],
      [
        "How would you rate your sleeping habits?",
        "Excellent",
        "Good",
        "Fair",
        "Poor",
      ],
      [
        "How would you rate your current physical health?",
        "Excellent",
        "Good",
        "Fair",
        "Poor",
      ],
      [
        "What gender do you identify with?",
        "Female",
        "Male",
      ],
      [
        "What gender would you prefer in a provider?",
        "Female",
        "Male",
        "No preference",
      ],
      [
        "What city do you live in most of the year?\n(We’ll find you a licensed provider in that city)",
        "Ibb",
        "Sana'a",
        "Aden",
        "Mukala",
        "Taiz",
        "Hodeidah",
        "Dhamar",
        "Al-Mukha",
        "Al-Jawf",
        "Marib",
        "Raymah",
        "Amran",
        "Sa'dah",
        "Al-Bayda",
      ],
    ],
    'Couples Therapy': [
      [
        "The price you can afford:",
        "1000 to 3000 / Hour",
        "4000 to 6000 / Hour",
      ],
      [
        "To begin, please select why you thought about getting help from a provider. You can choose more than one:",
        "Improve Our Communication",
        "Decide whether we should separate",
        "Resolve conflicts and disagreements",
        "Overcome adultery",
        "Understand myself better",
        "Understand my partner better",
        "Get to a more fair workload",
        "Reduce tension",
        "Prevent separation or divorce",
        "Learn 'good' ways to fight",
        "Stop hurting each other",
        "Win back my partner's love",
        "Love my partner again",
        "Discuss issues around raising kids",
        "Divorce or separation mediation",
      ],
      [
        "Have you and your partner worked with a couples counselor before?",
        "Yes",
        "No",
      ],
      [
        "Do you currently live with your partner?",
        "Yes",
        "No",
      ],
      [
        "What gender do you identify with?",
        "Female",
        "Male",
      ],
      [
        "What gender would you prefer in a provider?",
        "Female",
        "Male",
        "No preference",
      ],
      [
        "What city do you live in most of the year?\n(We’ll find you a licensed provider in that city)",
        "Ibb",
        "Sana'a",
        "Aden",
        "Mukala",
        "Taiz",
        "Hodeidah",
        "Dhamar",
        "Al-Mukha",
        "Al-Jawf",
        "Marib",
        "Raymah",
        "Amran",
        "Sa'dah",
        "Al-Bayda",
      ],
    ],
    'Psychiatry': [
      [
        "The price you can afford:",
        "1000 to 3000 / Hour",
        "4000 to 6000 / Hour",
      ],
      [
        "To begin, tell us why you're looking for help today:",
        "Anxiety",
        "Depression",
        "Insomnia",
        "Bipolar Disorder",
        "Borderline Personality Disorder",
        "Posttraumatic Stress Disorder",
        "Obsessive-Compulsive Disorder",
        "Other",
      ],
      [
        "Have you ever been prescribed medication to treat a mental health condition?",
        "Yes",
        "No",
        "I'm not sure",
      ],
      [
        "What gender do you identify with?",
        "Female",
        "Male",
      ],
      [
        "What gender would you prefer in a provider?",
        "Female",
        "Male",
        "No preference",
      ],
      [
        "What city do you live in most of the year?\n(We’ll find you a licensed provider in that city)",
        "Ibb",
        "Sana'a",
        "Aden",
        "Mukala",
        "Taiz",
        "Hodeidah",
        "Dhamar",
        "Al-Mukha",
        "Al-Jawf",
        "Marib",
        "Raymah",
        "Amran",
        "Sa'dah",
        "Al-Bayda",
      ],
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.serviceTitle} ')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(questionsMap[widget.serviceTitle]![currentQuestionIndex][0], style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              ...questionsMap[widget.serviceTitle]![currentQuestionIndex].sublist(1).map((option) {
                return _buildChoiceTile(context, option);
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
Widget _buildChoiceTile(BuildContext context, String title) {
  return GestureDetector(
    onTap: () {
      setState(() {
        answers.add(title); // Store the selected answer
        if (currentQuestionIndex < questionsMap[widget.serviceTitle]!.length - 1) {
          currentQuestionIndex++; // Move to the next question
        } else {
          // Handle completion of the questionnaire, e.g., navigate to a summary screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );
        }
      });
    },
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color:MyColors.lightCornflowerBlue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center( // Center the text in the container
        child: Text(title, style: TextStyle(fontSize: 14)),
      ),
    ),
  );
}

// Usage in a Row or Column to maintain equal width
Widget _buildChoices(BuildContext context, List<String> choices) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distributes space evenly
    children: choices.map((choice) => Expanded(
      child: _buildChoiceTile(context, choice),
    )).toList(),
  );

  }
}