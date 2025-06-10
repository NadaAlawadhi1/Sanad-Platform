part of 'therapist_list_cubit.dart';

@immutable
sealed class TherapistListState {}

final class TherapistListInitial extends TherapistListState {}

class TherapistsLoading extends TherapistListState {}

class TherapistsLoaded extends TherapistListState {
  final List<String> therapistsIds;
  TherapistsLoaded(this.therapistsIds);
}

class TherapistsLoadedDetails extends TherapistListState {
  final List<Doctor> therapists;
  TherapistsLoadedDetails(this.therapists);
}

class TherapistsEmpty extends TherapistListState {}

class TherapistsError extends TherapistListState {
  final String message;
  TherapistsError(this.message);
}