
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
  Music currentMusic;

  List<Category> categories;
  Category currentCategory;

  List<Artist> artists;
  Artist currentArtist;

  MusicState({
    required this.musics,
    required this.allMusics,
    required this.categories,
    required this.currentMusic,
    required this.currentCategory,
    required this.currentArtist,
    required this.artists,
  });
}

class InitMusicState extends MusicState {
  InitMusicState({
    required super.musics,
    required super.allMusics,
    required super.categories,
    required super.currentMusic,
    required super.currentCategory,
    required super.currentArtist,
    required super.artists,
  });

  Future init() async {
    Hive.openBox<Music>("musics").then((box) async {
      musics = box.values.toList();
      await box.close();
    });
  }
}

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  MusicBloc() : super(InitMusicState(
      musics: [],
      allMusics: [],
      categories: [],
      artists: [],
      currentMusic: Music.empty(),
      currentCategory: Category.empty(),
      currentArtist: Artist.empty(),
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
          artists: state.artists,
          currentArtist: state.currentArtist,
        );
        await nextState.init();
        emit(nextState);
        break;
    }
  }
}
