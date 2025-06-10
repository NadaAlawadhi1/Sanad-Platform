part of 'patient_list_cubit.dart';

@immutable
sealed class PatientListState {}

final class PatientListInitial extends PatientListState {}

final class PatientsLoading extends PatientListState {}

final class PatientsEmpty extends PatientListState {}

class PatientsLoaded extends PatientListState {
  final List<String> PatientsIds;
  PatientsLoaded(this.PatientsIds);
}

class PatientsLoadedDetails extends PatientListState {
  final List<ChatUser_NEW> Patients;
  PatientsLoadedDetails(this.Patients);
}


class PatientsError extends PatientListState {
  final String message;
  PatientsError(this.message);
}


