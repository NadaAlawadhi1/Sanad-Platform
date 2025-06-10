part of 'therapist_cubit.dart';

@immutable
sealed class TherapistState {}

class TherapistInitial extends TherapistState {
  final int currentPage;
  TherapistInitial(this.currentPage);
}

class TherapistPageChanged extends TherapistState {
  final int currentPage;
  TherapistPageChanged(this.currentPage);
}
class DotsIndicatorChanged extends TherapistState {
  final int currentDots;
  DotsIndicatorChanged(this.currentDots);
}
