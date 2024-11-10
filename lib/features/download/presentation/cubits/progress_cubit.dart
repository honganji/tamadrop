import 'package:flutter_bloc/flutter_bloc.dart';

class ProgressCubit extends Cubit<double> {
  ProgressCubit() : super(0.0);

  void updateProgress(double progress) {
    emit(progress);
  }
}
