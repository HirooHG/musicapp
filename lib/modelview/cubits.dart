
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';

class PauseCubit extends Cubit<bool> {
  PauseCubit() : super(false);

  void change(bool change) => emit(change);
}

class SearchValue extends Cubit<int> {
  SearchValue() : super(0);

  void change(int change) => emit(change);
}