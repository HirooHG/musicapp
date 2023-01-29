
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';

class PauseCubit extends Cubit<bool> {
  PauseCubit() : super(false);

  void change(bool change) {
    emit(change);
  }
}