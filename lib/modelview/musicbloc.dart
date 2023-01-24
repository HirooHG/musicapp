
import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'music.dart';

abstract class MusicEvent {
  const MusicEvent();
}

class InitMusicEvent extends MusicEvent {
  const InitMusicEvent();
}

abstract class MusicState {
  List<Music> musics;
  List<Music> allMusics;

  List<Category> categories;

  Music currentMusic;
  Category currentCategory;

  MusicState({
    required this.musics,
    required this.allMusics,
    required this.categories,
    required this.currentMusic,
    required this.currentCategory,
  });
}

class InitMusicState extends MusicState {
  InitMusicState({
    required super.musics,
    required super.allMusics,
    required super.categories,
    required super.currentMusic,
    required super.currentCategory,
  });

  Future init() async {
    Hive.openBox<Music>("musics").then((box) async {
      var list = box.values.toList();
      await box.close();
    });
  }
}

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  MusicBloc() : super(InitMusicState(
      musics: [],
      allMusics: [],
      categories: [],
      currentMusic: Music.empty(),
      currentCategory: Category.empty(),
  )) {
    on<MusicEvent>(onMusicEvent);
  }

  onMusicEvent(event, emit) async {
    switch(event.runtimeType) {
      case InitMusicEvent:
        InitMusicState nextState = InitMusicState(
          musics: state.musics,
          allMusics: state.allMusics,
          categories: state.categories,
          currentMusic: state.currentMusic,
          currentCategory: state.currentCategory,
        );
        await nextState.init();
        emit(nextState);
        break;
    }
  }
}
