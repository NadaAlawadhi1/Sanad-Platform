import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sanad_dashboared/models/complain_model.dart';
import 'package:sanad_dashboared/services/database_service.dart';
import 'package:sanad_dashboared/utils.dart';

// Function to get card color based on complaint type
Color getCardColor(String type) {
  switch (type) {
    case 'Technical':
      return MyColors.lightSkyBlue;
    case 'Administrative':
      return MyColors.lightCornflowerBlue;
    default:
      return Colors.grey;
  }
}

class AdminComplaintsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Complaints',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          StreamBuilder<List<Complaint>>(
            stream: DatabaseService.fetchComplaints(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error loading complaints.'));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No complaints yet.'));
              }

              List<Complaint> complaintsList = snapshot.data!;

              return Column(
                children: complaintsList
                    .asMap()
                    .map((index, complaint) {
                      // Determine card color based on index
                      Color cardColor = (index % 2 == 0)
                          ? MyColors.skyBlue
                          : MyColors.lightCornflowerBlue;
                      Color textColor =
                          (index % 2 == 0) ? MyColors.white : MyColors.black;
                      return MapEntry(
                        index,
                        Card(
                          color: cardColor,
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            // leading: CircleAvatar(
                            //   backgroundImage: NetworkImage(complaint.image),
                            // ),

                            title: Text(
                              complaint.title,
                              style: TextStyle(color: textColor),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Divider(color: textColor),
                                Text(
                                  complaint.description,
                                  style: TextStyle(color: textColor),
                                ),
                                Divider(color: textColor),
                                SizedBox(height: 4.0),
                                Text(
                                  'Submitted by: ${complaint.name}',
                                  style: TextStyle(color: textColor),
                                ),
                                Text(
                                  'Date: ${DateFormat('yyyy-MM-dd').format(complaint.createdAt)}',
                                  style: TextStyle(color: textColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    })
                    .values
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
