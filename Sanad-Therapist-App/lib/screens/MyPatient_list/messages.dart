import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sanad_therapists/Widgets/chat_tile.dart';
import 'package:sanad_therapists/generated/l10n.dart';
import 'package:sanad_therapists/screens/MyPatient_list/patient_list_cubit.dart';
import 'package:sanad_therapists/screens/chat_page.dart';
import 'package:sanad_therapists/services/navigation_service.dart';
import 'package:sanad_therapists/utils.dart';

class Chatting extends StatefulWidget {
  const Chatting({super.key});

  @override
  State<Chatting> createState() => _ChattingState();
}

class _ChattingState extends State<Chatting> {
  final GetIt _getIt = GetIt.instance;
  late NavigationService _navigationService;

  @override
  void initState() {
    super.initState();
    _navigationService = _getIt.get<NavigationService>();
    // Fetch therapists' IDs when the widget is initialized
    PatientListCubit.get(context).fetchMyPatientsId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
                   S.of(context).messagesMainText,

          style:
          TextStyle(color: MyColors.skyBlue, fontWeight: FontWeight.bold),
        ),
        backgroundColor: MyColors.lightCornflowerBlue,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: BlocBuilder<PatientListCubit, PatientListState>(
            builder: (context, state) {
              if (state is PatientsLoading) {
                // Show loading spinner when data is loading
                return const Center(child: CircularProgressIndicator());
              }

              if (state is PatientsError) {
                // Show error message if fetching therapists' data fails
                return Center(child: Text("Error: ${state.message}"));
              }

              if (state is PatientsEmpty) {
                // Show a message if no therapists are found
                return const Center(child: Text("No Patients found."));
              }

              if (state is PatientsLoaded) {
                // Show loading spinner until therapist details are fetched
                if (state.PatientsIds.isNotEmpty) {
                  log('${state.PatientsIds}');
                  // Fetch therapist details using the loaded therapist IDs
                  PatientListCubit.get(context)
                      .getAllMYPatients(state.PatientsIds);
                }
                return const Center(child: CircularProgressIndicator());
              }

              if (state is PatientsLoadedDetails) {
                // Once therapist details are loaded, display them in a list
                final Patients = state.Patients;
                return ListView.builder(
                  itemCount: Patients.length,
                  itemBuilder: (context, index) {
                    final therapist = Patients[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ChatTile(
                        userProfile: therapist,
                        onTap: () {
                          // Navigate to the chat page when a therapist is tapped
                          _navigationService.push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChatPage(chatUser: therapist),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              }

              return const Center(child: Text("Unexpected State"));
            },
          ),
        ),
      ),
    );
  }
}
