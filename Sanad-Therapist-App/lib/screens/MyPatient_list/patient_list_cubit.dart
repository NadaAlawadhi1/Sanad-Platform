
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import 'package:sanad_therapists/services/database_service.dart';

import '../../models/chatUser_model.dart';
part 'patient_list_state.dart';

class PatientListCubit extends Cubit<PatientListState> {
  PatientListCubit() : super(PatientListInitial());
  static PatientListCubit get(context) => BlocProvider.of(context);


  late StreamSubscription<List<String>> _PatientsIdSubscription;
  // Fetch therapists' IDs
  void fetchMyPatientsId() {
    try {
      emit(PatientsLoading());  // Emit loading state while fetching data

      _PatientsIdSubscription = DatabaseService.getMyPatientsId().listen(
            (patientIds) {
          if (patientIds.isEmpty) {
            emit(PatientsEmpty());  // Emit empty state if no therapists found
          } else {
            emit(PatientsLoaded(patientIds));  // Emit loaded state with therapist IDs
            getAllMYPatients(patientIds);  // Fetch therapist details using the IDs
          }
        },
        onError: (e) {
          emit(PatientsError("Error fetching Patients' IDs: $e"));  // Emit error state if fetching fails
        },
      );
    } catch (e) {
      emit(PatientsError("Error fetching Patients' IDs: $e"));
      log('Error fetching: $e');
    }
  }

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>> getAllMYPatients(List<String> patientIds) {
    return FirebaseFirestore.instance
        .collection('users')
        .where('id', whereIn: patientIds.isEmpty ? [''] : patientIds)
        .snapshots()
        .listen(
          (event) {
        final data = event.docs;

        // Convert the data to a list of ChatUser objects
        List<ChatUser_NEW> PatientList = data
            .map((e) => ChatUser_NEW.fromMap(e.data()))
            .toList();

        // Log each therapist's data (optional)
        for (var therapist in data) {
          log("Patients Data: ${jsonEncode(therapist.data())}");
        }

        // Emit the updated list of therapists
        if (PatientList.isEmpty) {
          emit(PatientsEmpty()); // Emit empty state if no therapists are found
        } else {
          emit(PatientsLoadedDetails(PatientList)); // Emit the loaded therapists
        }
      },
      onError: (error) {
        emit(PatientsError("Error fetching Patients' details: $error")); // Handle errors
      },
    );
  }


}
