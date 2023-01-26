
import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'music.dart';

import 'package:musicapp/model/hivehandler.dart';

abstract class MusicEvent {
  const MusicEvent();
}
class InitMusicEvent extends MusicEvent {
  const InitMusicEvent();
}
class AddMusicEvent extends MusicEvent {
  AddMusicEvent({required this.music});

  final Music music;
}
class AddCategoryEvent extends MusicEvent {
  AddCategoryEvent({required this.category});

  final Category category;
}
class AddArtistEvent extends MusicEvent {
  AddArtistEvent({required this.artist});

  final Artist artist;
}
class ChangeCategoryEvent extends MusicEvent {
  ChangeCategoryEvent({required this.category});

  final Category category;
}
class ChangeArtistEvent extends MusicEvent {
  ChangeArtistEvent({required this.artist});

  final Artist artist;
}

abstract class MusicState {
  List<Music> musics;
  List<Music> allMusics;
  Music currentMusic;

  List<Category> categories;
  Category currentCategory;

  List<Artist> artists;
  Artist currentArtist;

  HiveHandler hiveHandler;

  MusicState({
    required this.musics,
    required this.artists,
    required this.categories,
    required this.allMusics,
    required this.currentMusic,
    required this.currentCategory,
    required this.currentArtist,
    required this.hiveHandler
  });
}
class InitMusicState extends MusicState {
  InitMusicState({
    required super.musics,
    required super.categories,
    required super.artists,
    required super.allMusics,
    required super.currentMusic,
    required super.currentCategory,
    required super.currentArtist,
    required super.hiveHandler
  });

  Future init() async {
    musics = (await hiveHandler.musicBox).values.toList();
    categories = (await hiveHandler.categoryBox).values.toList();
    artists = (await hiveHandler.artistBox).values.toList();

    if(allMusics.isEmpty) {
      allMusics.addAll(musics);
    }

    if (!categories.any((element) => element.name == "No category")) {
      await hiveHandler.createCategory(Category.empty());
    }

    if (!artists.any((element) => element.name == "unknown")) {
      await hiveHandler.createArtist(Artist.empty());
    }

    currentCategory = categories[0];
    currentArtist = artists[0];
  }
}
class AddedMusicState extends MusicState {
  AddedMusicState({
    required super.musics,
    required super.categories,
    required super.artists,
    required super.allMusics,
    required super.currentMusic,
    required super.currentCategory,
    required super.currentArtist,
    required super.hiveHandler
  });

  Future add(Music music) async {
    if(!musics.any((element) => element == music)) {
      musics.add(music);
      await hiveHandler.createMusic(music);
    }
  }
}
class AddedArtistState extends MusicState {
  AddedArtistState({
    required super.musics,
    required super.categories,
    required super.artists,
    required super.allMusics,
    required super.currentMusic,
    required super.currentCategory,
    required super.currentArtist,
    required super.hiveHandler
  });

  Future add(Artist artist) async {
    if(!artists.any((element) => element == artist)) {
      artists.add(artist);
      await hiveHandler.createArtist(artist);
    }
  }
}
class AddedCategoryState extends MusicState {
  AddedCategoryState({
    required super.musics,
    required super.categories,
    required super.artists,
    required super.allMusics,
    required super.currentMusic,
    required super.currentCategory,
    required super.currentArtist,
    required super.hiveHandler
  });

  Future add(Category category) async {
    if(!categories.any((element) => element == category)) {
      categories.add(category);
      await hiveHandler.createCategory(category);
    }
  }
}
class ChangedCategoryState extends MusicState {
  ChangedCategoryState({
    required super.musics,
    required super.categories,
    required super.artists,
    required super.allMusics,
    required super.currentMusic,
    required super.currentCategory,
    required super.currentArtist,
    required super.hiveHandler
  });

  Future change(Category category) async {
    currentCategory = categories.singleWhere((element) => element == category);
  }
}
class ChangedArtistState extends MusicState {
  ChangedArtistState({
    required super.musics,
    required super.categories,
    required super.artists,
    required super.allMusics,
    required super.currentMusic,
    required super.currentCategory,
    required super.currentArtist,
    required super.hiveHandler
  });

  Future change(Artist artist) async {
    currentArtist = artists.singleWhere((element) => element == artist);
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
    hiveHandler: HiveHandler()
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
          hiveHandler: state.hiveHandler
        );
        await nextState.init();
        emit(nextState);
        break;
      case AddMusicEvent:
        AddedMusicState nextState = AddedMusicState(
          musics: state.musics,
          allMusics: state.allMusics,
          categories: state.categories,
          currentMusic: state.currentMusic,
          currentCategory: state.currentCategory,
          artists: state.artists,
          currentArtist: state.currentArtist,
          hiveHandler: state.hiveHandler
        );
        await nextState.add((event as AddMusicEvent).music);
        emit(nextState);
        break;
      case AddArtistEvent:
        AddedArtistState nextState = AddedArtistState(
          musics: state.musics,
          allMusics: state.allMusics,
          categories: state.categories,
          currentMusic: state.currentMusic,
          currentCategory: state.currentCategory,
          artists: state.artists,
          currentArtist: state.currentArtist,
          hiveHandler: state.hiveHandler
        );
        await nextState.add((event as AddArtistEvent).artist);
        emit(nextState);
        break;
      case AddCategoryEvent:
        AddedCategoryState nextState = AddedCategoryState(
          musics: state.musics,
          allMusics: state.allMusics,
          categories: state.categories,
          currentMusic: state.currentMusic,
          currentCategory: state.currentCategory,
          artists: state.artists,
          currentArtist: state.currentArtist,
          hiveHandler: state.hiveHandler
        );
        await nextState.add((event as AddCategoryEvent).category);
        emit(nextState);
        break;
    }
  }
}
