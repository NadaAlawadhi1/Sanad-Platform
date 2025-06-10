import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sanad_dashboared/models/application_doc.dart';
import 'package:sanad_dashboared/services/database_service.dart';
import 'package:sanad_dashboared/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class JoinTherapistScreen extends StatefulWidget {
  const JoinTherapistScreen({super.key});

  @override
  _JoinTherapistScreenState createState() => _JoinTherapistScreenState();
}

class _JoinTherapistScreenState extends State<JoinTherapistScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Submitted Applications',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: DatabaseService.fetchApplications(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Text('An error occurred while fetching data.'),
                );
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No applications found.'),
                );
              }

              // Map Firestore documents to TherapistApplication models
              final applications = snapshot.data!.docs
                  .map((doc) => TherapistApplication.fromJson(doc.data()))
                  .toList();

              return SingleChildScrollView(
                child: _displaySubmittedData(applications),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _displaySubmittedData(List<TherapistApplication> applications) {
    return Wrap(
      spacing: 20.0, // Space between cards
      runSpacing: 20.0, // Space between rows
      children: applications.map((application) {
        return Card(
          elevation: 3,
          color: MyColors.lightCornflowerBlue, // Set card background color
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Submitted Application Data',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text('Name: ${application.full_name}'),
                Text('Email: ${application.email}'),
                Text('Phone: ${application.phoneNumber}'),
                Text('City: ${application.city}'),
                Text('Gender: ${application.gender}'),
                Text('Years of Experience: ${application.yearsOfExperience}'),
                const SizedBox(height: 10),
                if (application.uploadedFilePath != null)
                  TextButton(
                    onPressed: () async {
                      final url = application.uploadedFilePath!;
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: const Text(
                      'View CV',
                      style: TextStyle(color: MyColors.skyBlue),
                    ),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
