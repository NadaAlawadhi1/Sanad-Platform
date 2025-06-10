import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad/Widgets/chat_tile.dart'; // Ensure this widget exists
import 'package:sanad/generated/l10n.dart';
import 'package:sanad/screens/chatPage/therapist_list_cubit.dart'; // Import the Cubit
import 'package:sanad/screens/chat_page.dart'; // Import the ChatPage
import 'package:sanad/services/navigation_service.dart'; // Import NavigationService
import 'package:get_it/get_it.dart';
import 'package:sanad/utils.dart';

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
    TherapistListCubit.get(context).fetchMyTherapistsId();
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
          child: BlocBuilder<TherapistListCubit, TherapistListState>(
            builder: (context, state) {
              if (state is TherapistsLoading) {
                // Show loading spinner when data is loading
                return const Center(child: CircularProgressIndicator());
              }

              if (state is TherapistsError) {
                // Show error message if fetching therapists' data fails
                return Center(child: Text("Error: ${state.message}"));
              }

              if (state is TherapistsEmpty) {
                // Show a message if no therapists are found
                return const Center(child: Text("No therapists found."));
              }

              if (state is TherapistsLoaded) {
                // Show loading spinner until therapist details are fetched
                if (state.therapistsIds.isNotEmpty) {
                  log('${state.therapistsIds}');
                  // Fetch therapist details using the loaded therapist IDs
                  TherapistListCubit.get(context)
                      .getAllMYTherapists(state.therapistsIds);
                }
                return const Center(child: CircularProgressIndicator());
              }

              if (state is TherapistsLoadedDetails) {
                // Once therapist details are loaded, display them in a list
                final therapists = state.therapists;
                return ListView.builder(
                  itemCount: therapists.length,
                  itemBuilder: (context, index) {
                    final therapist = therapists[index];
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
