import 'dart:developer';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sanad/generated/l10n.dart';
import 'package:sanad/models/notes_model.dart';
import 'package:sanad/services/database_service.dart';
import 'package:sanad/services/navigation_service.dart';
import 'package:sanad/utils.dart';
import 'package:sanad/widgets/note_card.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  late NavigationService _navigationService;
  final GetIt _getIt = GetIt.instance;

  @override
  void initState() {
    super.initState();
    _navigationService = _getIt.get<NavigationService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.lightCornflowerBlue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 10),
            child: Text(
              S.of(context).diaryMainText,
              style: GoogleFonts.roboto(
                  color: MyColors.skyBlue,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              S.of(context).writedownMessage,
              style: GoogleFonts.aBeeZee(
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: DatabaseService.fetchUserNotes(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                /// Later, create something different here.. nadoosh
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                      child: Text(S.of(context).noNotesMessage,
                          style: GoogleFonts.nunito(color: MyColors.black)));
                }

                // If data exists, create the grid view
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final note = snapshot.data!.docs[index];
                    print('$note');
                    return noteCard(() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NoteReaderScreen(note),
                          ));
                    }, note, context);
                  },
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NoteEditorScreen(),
              ));
        },
        label: Text(
          S.of(context).addNoteButtonText,
          style: TextStyle(color: MyColors.white),
        ),
        backgroundColor:
            MyColors.skyBlue, // Set the background color of the FAB
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////

class NoteReaderScreen extends StatefulWidget {
  NoteReaderScreen(this.doc, {Key? key}) : super(key: key);
  QueryDocumentSnapshot doc;
  @override
  State<NoteReaderScreen> createState() => _NoteReaderScreenState();
}

class _NoteReaderScreenState extends State<NoteReaderScreen> {
  @override
  Widget build(BuildContext context) {
    int colorIndex = int.tryParse(widget.doc['color_id'].toString()) ??
        0; // Default to 0 if parsing fails

    return Scaffold(
      backgroundColor: NotesStyle.cardColors[colorIndex],
      appBar: AppBar(
        title: Text(S.of(context).notereader),
        backgroundColor: NotesStyle.cardColors[colorIndex],
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.doc['note_title']?.toString() ??
                  'Untitled', // Convert to string if needed
              style: NotesStyle.mainTitle,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.doc['creation_date']?.toString() ??
                  'Unknown date', // Convert to string
              style: NotesStyle.dateTitle,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.doc['note_content']?.toString() ??
                  'No content available', // Convert to string
              style: NotesStyle.mainContent,
            ),
          ],
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////
class NoteEditorScreen extends StatefulWidget {
  final DateTime? selectedDate; // Accept selected date

  const NoteEditorScreen({this.selectedDate, super.key});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  @override
  Widget build(BuildContext context) {
    int colorId = Random().nextInt(NotesStyle.cardColors.length);
    String date = widget.selectedDate.toString(); // Use selected date
    TextEditingController _titleController = TextEditingController();
    TextEditingController _mainController = TextEditingController();

    return Scaffold(
      backgroundColor: NotesStyle.cardColors[colorId],
      appBar: AppBar(
        title: Text(S.of(context).addNewNoteTitle),
        backgroundColor: NotesStyle.cardColors[colorId],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: S.of(context).noteTitleHint,
              ),
              style: NotesStyle.mainTitle,
            ),
            Text(date, style: NotesStyle.dateTitle),
            SizedBox(height: 28.0),
            TextField(
              controller: _mainController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: S.of(context).noteContentHint,
              ),
              style: NotesStyle.mainContent,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await DatabaseService.addNote(
            title: _titleController.text,
            content: _mainController.text,
            colorId: colorId,
            creationDate: widget.selectedDate, // Pass the selected date here
          );
          Navigator.pop(context);
        },
        child: Icon(Icons.save),
        backgroundColor: MyColors.white,
      ),
    );
  }
}
