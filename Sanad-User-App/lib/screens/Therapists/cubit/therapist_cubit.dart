
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'therapist_state.dart';

class TherapistCubit extends Cubit<TherapistState> {
  TherapistCubit() : super(TherapistInitial(0));
  static TherapistCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  void changePage(int index) {

    emit(TherapistPageChanged(index));
  }

  void DotsIndicator(int index) {
    currentIndex = index;
    emit(DotsIndicatorChanged(index));
  }
}
