import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sanad/models/notes_model.dart';
import 'package:sanad/services/Time_format.dart';

Widget noteCard(Function()? onTap, QueryDocumentSnapshot doc,context ) {
  // Convert color_id to int if it's a string; default to 0 if parsing fails
  int colorIndex = int.tryParse(doc['color_id'].toString()) ?? 0;

  return InkWell(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: NotesStyle.cardColors[colorIndex], // Use the converted index
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            doc['note_title']?.toString() ?? 'Untitled', // Convert to String with a default fallback
            style: NotesStyle.mainTitle,
          ),
          SizedBox(height: 5),
          Text(
              Format_Time.getLastMessageTime(context: context, time: '${doc['creation_date']?.toString()}'), // Convert date to String with fallback
            style: NotesStyle.dateTitle,
          ),
          SizedBox(height: 5),
          Text(
            doc['note_content']?.toString() ?? 'No content', // Convert content to String with fallback
            style: NotesStyle.mainContent,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );
}

