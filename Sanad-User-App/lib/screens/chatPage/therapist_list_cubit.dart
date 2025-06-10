import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sanad/models/DoctorUser_Model.dart';
import 'package:sanad/services/database_service.dart';

part 'therapist_list_state.dart';

class TherapistListCubit extends Cubit<TherapistListState> {
  static TherapistListCubit get(context) => BlocProvider.of(context);
  TherapistListCubit() : super(TherapistListInitial());

  late StreamSubscription<List<String>> _therapistsIdSubscription;
  // Fetch therapists' IDs
  void fetchMyTherapistsId() {
    try {
      emit(TherapistsLoading());  // Emit loading state while fetching data

      _therapistsIdSubscription = DatabaseService.getMyTherapistsId().listen(
            (therapistsIds) {
          if (therapistsIds.isEmpty) {
            emit(TherapistsEmpty());  // Emit empty state if no therapists found
          } else {
            emit(TherapistsLoaded(therapistsIds));  // Emit loaded state with therapist IDs
            getAllMYTherapists(therapistsIds);  // Fetch therapist details using the IDs
          }
        },
        onError: (e) {
          emit(TherapistsError("Error fetching therapists' IDs: $e"));  // Emit error state if fetching fails
        },
      );
    } catch (e) {
      emit(TherapistsError("Error fetching therapists' IDs: $e"));
    }
  }

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>> getAllMYTherapists(List<String> therapistIds) {
    return FirebaseFirestore.instance
        .collection('therapists')
        .where('id', whereIn: therapistIds.isEmpty ? [''] : therapistIds)
        .snapshots()
        .listen(
          (event) {
        final data = event.docs;

        // Convert the data to a list of ChatUser objects
        List<Doctor> therapistList = data
            .map((e) => Doctor.fromMap(e.data()))
            .toList();

        // Log each therapist's data (optional)
        for (var therapist in data) {
          log("Therapist Data: ${jsonEncode(therapist.data())}");
        }

        // Emit the updated list of therapists
        if (therapistList.isEmpty) {
          emit(TherapistsEmpty()); // Emit empty state if no therapists are found
        } else {
          emit(TherapistsLoadedDetails(therapistList)); // Emit the loaded therapists
        }
      },
      onError: (error) {
        emit(TherapistsError("Error fetching therapists' details: $error")); // Handle errors
      },
    );
  }

}
