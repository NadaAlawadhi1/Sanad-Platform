import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sanad_therapists/generated/l10n.dart';
import 'package:sanad_therapists/screens/notes_screen.dart';
import 'package:sanad_therapists/services/navigation_service.dart';
import 'package:sanad_therapists/utils.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sanad_therapists/services/database_service.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late NavigationService _navigationService;
  final GetIt _getIt = GetIt.instance;
  DateTime today = DateTime.now();
  Set<DateTime> markedDates = {};

  @override
  void initState() {
    super.initState();
    _navigationService = _getIt.get<NavigationService>();
    _loadMarkedDates();
  }

  // Function to load dates from Firestore
  void _loadMarkedDates() {
    DatabaseService.fetchtherapistsNotes().listen((snapshot) {
      final newMarkedDates = <DateTime>{};
      for (var doc in snapshot.docs) {
        final creationDateTimestamp = doc['creation_date'] as int;
        final creationDate =
        DateTime.fromMillisecondsSinceEpoch(creationDateTimestamp);
        newMarkedDates.add(
            DateTime(creationDate.year, creationDate.month, creationDate.day));
      }
      setState(() {
        markedDates = newMarkedDates;
      });
    });
  }

  Future<void> _addNoteForSelectedDay() async {
    final creationDate = DateTime(today.year, today.month, today.day);

    // Navigate to the NoteEditorScreen and pass the selected date
    _navigationService.push(
      MaterialPageRoute(
        builder: (context) => NoteEditorScreen(
          selectedDate:
          creationDate, // Pass the selected date to the editor screen
        ),
      ),
    );

    // Immediately mark the date (This could happen after saving the note in the editor)
    setState(() {
      markedDates.add(creationDate);
    });
  }

  void _onSelectedDay(DateTime day, DateTime focusedDay) {
    if (day.isAfter(DateTime.now()) || isSameDay(day, DateTime.now())) {
      setState(() {
        today = day;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.lightCornflowerBlue,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Text(S.of(context).calendarMainText, style: TextStyle(color: MyColors.skyBlue, fontWeight: FontWeight.bold, fontSize: 25),),
          ),
          TableCalendar(
            rowHeight: 40,
            availableGestures: AvailableGestures.all,
            onDaySelected: _onSelectedDay,
            selectedDayPredicate: (day) => isSameDay(day, today),
            focusedDay: today,
            firstDay: DateTime.utc(2015, 1, 1),
            lastDay: DateTime.utc(2028, 1, 1),
            calendarStyle: CalendarStyle(
              selectedDecoration: const BoxDecoration(
                color: MyColors.skyBlue,
                shape: BoxShape.circle,
              ),
              todayDecoration: const BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
              defaultDecoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              disabledDecoration: BoxDecoration(
                color: Colors.grey.shade300,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final isMarked = markedDates
                    .contains(DateTime(day.year, day.month, day.day));
                return isMarked
                    ? Center(
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: MyColors.lightSkyBlue,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
                    : null;
              },
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: MyColors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 35, left: 35, top: 20),
                        child: Row(
                          children: [
                            Text(
                            S.of(context).beText,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: MyColors.skyBlue,
                              ),
                            ),
                            Text(
                           S.of(context).readyText,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Text(
                         S.of(context).appointmentMessage,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                       S.of(context).reminderMessage,
                          style: TextStyle(
                            fontSize: 14,
                            color: MyColors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              await _addNoteForSelectedDay();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MyColors.skyBlue,
                              foregroundColor: MyColors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child:  Text(S.of(context).addNoteButtonText),
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
