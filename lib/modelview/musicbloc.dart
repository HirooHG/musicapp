import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'music.dart';
import 'package:musicapp/model/hivehandler.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';


// Events
abstract class MusicEvent {
  const MusicEvent();
}
class SaveJsonDataEvent extends MusicEvent {
  const SaveJsonDataEvent();
}
class SearchMusic extends MusicEvent {
  const SearchMusic({required this.value, required this.searchValue});

  final String value;
  final int searchValue;
}
class InitMusicEvent extends MusicEvent {
  const InitMusicEvent({required this.context});

  final BuildContext context;
}
class SortMusicsEvent extends MusicEvent {
  const SortMusicsEvent({
    required this.value
  });

  final int value;
}
class NextMusicEvent extends MusicEvent {
  const NextMusicEvent();
}
class SelectMusicEvent extends MusicEvent {
  SelectMusicEvent({this.music});

  final Music? music;
}

// States
abstract class MusicState {
  // musics
  List<Music> musics;
  List<Music> allMusics;
  Music currentMusic;

  // categories
  List<Category> categories;
  Category currentCategory;

  // artists
  List<Artist> artists;
  Artist currentArtist;

  // modeling
  HiveHandler hiveHandler;

  // others
  final AssetsAudioPlayer assetAudio;
  final ScrollController scrollController;
  final jump = 93;

  MusicState({
    required this.musics,
    required this.artists,
    required this.categories,
    required this.allMusics,
    required this.currentMusic,
    required this.currentCategory,
    required this.currentArtist,
    required this.hiveHandler,
    required this.assetAudio,
    required this.scrollController,
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
    required super.assetAudio,
    required super.hiveHandler,
    required super.scrollController,
  });

  Future<void> init(BuildContext context) async {

    musics = await hiveHandler.getMusics();
    categories = await hiveHandler.getCategories();
    artists = await hiveHandler.getArtist();

    var allC = categories.singleWhere((element) => element.name == "All");
    categories.remove(allC);
    categories.insert(0, allC);

    var noC = categories.singleWhere((element) => element.name == "No category");
    categories.remove(noC);
    categories.insert(0, noC);

    var noA = artists.singleWhere((element) => element.name == "unknown");
    artists.remove(noA);
    artists.insert(0, noA);

    var allA = artists.singleWhere((element) => element.name == "All");
    artists.remove(allA);
    artists.insert(0, allA);

    for(var i in musics) {
      var z = categories.singleWhere((element) => element.name == i.category.name);
      var w = artists.singleWhere((element) => element.name == i.artist.name);
      i.category = z;
      i.artist = w;
    }

    if (!categories.any((element) => element.name == "All")) {
      await hiveHandler.create(Category(name: "All"), (await hiveHandler.categoryBox));
      await hiveHandler.create(Category.empty(), (await hiveHandler.categoryBox));
      categories = await hiveHandler.getCategories();
    }
    if (!artists.any((element) => element.name == "All")) {
      await hiveHandler.create(Artist(name: "All"), (await hiveHandler.artistBox));
      await hiveHandler.create(Artist.empty(), (await hiveHandler.artistBox));
      artists = await hiveHandler.getArtist();
    }

    musics.sort();
    categories.sort();
    artists.sort();
    
    currentCategory = categories.singleWhere((element) => element.name == "All");
    currentArtist = artists.singleWhere((element) => element.name == "All");
  }
}
class SavedJsonDataState extends MusicState {
  SavedJsonDataState({
    required super.musics,
    required super.categories,
    required super.artists,
    required super.allMusics,
    required super.currentMusic,
    required super.currentCategory,
    required super.currentArtist,
    required super.assetAudio,
    required super.hiveHandler,
    required super.scrollController,
  });

  Future save() async {
    Map<String, Map<String, dynamic>> map = {};

    for(var i in musics) {
      map.addAll({ "${i.key}" : i.toMap() });
    }

    var text = jsonEncode(map);
    await File("/data/user/0/fr.HirooHG.musicapp/files/JsonSaved").writeAsString(text);
  }
}
class SearchedMusicState extends MusicState {
  SearchedMusicState({
    required super.musics,
    required super.categories,
    required super.artists,
    required super.allMusics,
    required super.currentMusic,
    required super.currentCategory,
    required super.currentArtist,
    required super.assetAudio,
    required super.hiveHandler,
    required super.scrollController,
  });

  void search(int searchValue, String value) {
    if(value.isEmpty) {
      scrollController.jumpTo(0);
      return;
    }

    var list = musics.where((element) {
      var val = (searchValue == 0)
          ? element.name
          : (searchValue == 1)
          ? element.category.name
          : element.artist.name;
      return val.contains(value);
    });
    if(list.isNotEmpty) {
      var music = list.first;
      var pos = musics.indexOf(music).toDouble();
      scrollController.jumpTo(jump * pos);
    }
  }
}
class SortedMusicsState extends MusicState {
  SortedMusicsState({
    required super.musics,
    required super.categories,
    required super.artists,
    required super.allMusics,
    required super.currentMusic,
    required super.currentCategory,
    required super.currentArtist,
    required super.assetAudio,
    required super.hiveHandler,
    required super.scrollController,
  });

  void sort(int value) {
    musics.sort((a, b) {
      switch(value) {
        case 0:
          return a.compareTo(b);
        case 1:
          return a.category.compareTo(b.category);
        default:
          return a.artist.compareTo(b.artist);
      }
    });
  }
}
class NextMusicState extends MusicState {
  NextMusicState({
    required super.musics,
    required super.categories,
    required super.artists,
    required super.allMusics,
    required super.currentMusic,
    required super.currentCategory,
    required super.currentArtist,
    required super.assetAudio,
    required super.hiveHandler,
    required super.scrollController,
  });

  void next() {
    final pos = musics.indexOf(currentMusic) + 1;
    Music nextMusic = musics[pos];
    currentMusic = nextMusic;
    assetAudio.open(Audio.file(nextMusic.link), showNotification: true);
    scrollController.jumpTo(jump * pos.toDouble());
  }
}
class SelectedMusicState extends MusicState {
  SelectedMusicState({
    required super.musics,
    required super.categories,
    required super.artists,
    required super.allMusics,
    required super.currentMusic,
    required super.currentCategory,
    required super.currentArtist,
    required super.assetAudio,
    required super.hiveHandler,
    required super.scrollController,
  });

  void select(Music? music) {
    if(music != null) {
      var pos = musics.indexOf(music);
      assetAudio.open(Audio.file(music.link), showNotification: true);
      scrollController.jumpTo(jump * pos.toDouble());
    } else {
      music = musics[0];
      assetAudio.open(Audio.file(music.link), showNotification: true);
      scrollController.jumpTo(0);
    }
    currentMusic = music;
  }
}

//#region CRUD
class UpdateCategoryEvent extends MusicEvent {
  UpdateCategoryEvent({required this.category});

  final Category category;
}
class UpdateArtistEvent extends MusicEvent {
  UpdateArtistEvent({required this.artist});

  final Artist artist;
}
class UpdateMusicEvent extends MusicEvent {
  UpdateMusicEvent({required this.music});

  final Music music;
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
class DeleteMusicEvent extends MusicEvent {
  DeleteMusicEvent({required this.music});

  final Music music;
}
class DeleteCategoryEvent extends MusicEvent {
  DeleteCategoryEvent({required this.category});

  final Category category;
}
class DeleteArtistEvent extends MusicEvent {
  DeleteArtistEvent({required this.artist});

  final Artist artist;
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
    required super.hiveHandler,
    required super.assetAudio,
    required super.scrollController,
  });

  Future add(Music music) async {
    if(!musics.any((element) => element == music)) {
      musics.add(music);
      await hiveHandler.create(music, (await hiveHandler.musicBox));
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
    required super.assetAudio,
    required super.hiveHandler,
    required super.scrollController,
  });

  Future add(Artist artist) async {
    if(!artists.any((element) => element == artist)) {
      artists.add(artist);
      await hiveHandler.create(artist, (await hiveHandler.artistBox));
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
    required super.assetAudio,
    required super.hiveHandler,
    required super.scrollController,
  });

  Future add(Category category) async {
    if(!categories.any((element) => element == category)) {
      categories.add(category);
      await hiveHandler.create(category, (await hiveHandler.categoryBox));
    }
  }
}
class UpdatedCategoryState extends MusicState {
  UpdatedCategoryState({
    required super.musics,
    required super.categories,
    required super.artists,
    required super.allMusics,
    required super.currentMusic,
    required super.currentCategory,
    required super.currentArtist,
    required super.assetAudio,
    required super.hiveHandler,
    required super.scrollController,
  });

  Future update(Category category) async {
    await hiveHandler.update(category);
  }
}
class UpdatedArtistState extends MusicState {
  UpdatedArtistState({
    required super.musics,
    required super.categories,
    required super.artists,
    required super.allMusics,
    required super.currentMusic,
    required super.currentCategory,
    required super.currentArtist,
    required super.assetAudio,
    required super.hiveHandler,
    required super.scrollController,
  });

  Future update(Artist artist) async {
    await hiveHandler.update(artist);
  }
}
class UpdatedMusicState extends MusicState {
  UpdatedMusicState({
    required super.musics,
    required super.categories,
    required super.artists,
    required super.allMusics,
    required super.currentMusic,
    required super.currentCategory,
    required super.currentArtist,
    required super.assetAudio,
    required super.hiveHandler,
    required super.scrollController,
  });

  Future update(Music music) async {
    await hiveHandler.update(music);
  }
}
class DeletedCategoryState extends MusicState {
  DeletedCategoryState({
    required super.musics,
    required super.categories,
    required super.artists,
    required super.allMusics,
    required super.currentMusic,
    required super.currentCategory,
    required super.currentArtist,
    required super.assetAudio,
    required super.hiveHandler,
    required super.scrollController,
  });

  Future delete(Category category) async {
    var list = musics.where((element) => element.category == category);
    for (var i in list) {
      i.category = categories.singleWhere((element) => element.name == "No category");
      await hiveHandler.update(i);
    }
    await hiveHandler.delete(category);
    categories.remove(category);
  }
}
class DeletedArtistState extends MusicState {
  DeletedArtistState({
    required super.musics,
    required super.categories,
    required super.artists,
    required super.allMusics,
    required super.currentMusic,
    required super.currentCategory,
    required super.currentArtist,
    required super.assetAudio,
    required super.hiveHandler,
    required super.scrollController,
  });

  Future delete(Artist artist) async {
    var list = musics.where((element) => element.artist == artist);
    for (var i in list) {
      i.artist = artists.singleWhere((element) => element.name == "unknown");
      await hiveHandler.update(i);
    }
    await hiveHandler.delete(artist);
    artists.remove(artist);
  }
}
class DeletedMusicState extends MusicState {
  DeletedMusicState({
    required super.musics,
    required super.categories,
    required super.artists,
    required super.allMusics,
    required super.currentMusic,
    required super.currentCategory,
    required super.currentArtist,
    required super.assetAudio,
    required super.hiveHandler,
    required super.scrollController,
  });

  Future delete(Music music) async {
    await hiveHandler.delete(music);
  }
}
//#endregion

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  MusicBloc() : super(InitMusicState(
    musics: [],
    allMusics: [],
    categories: [],
    artists: [],
    currentMusic: Music.empty(),
    currentCategory: Category.empty(),
    currentArtist: Artist.empty(),
    hiveHandler: HiveHandler(),
    assetAudio: AssetsAudioPlayer(),
    scrollController: ScrollController()
  )) {
    on<MusicEvent>(onMusicEvent);
  }

  onMusicEvent(event, emit) async {
    switch(event.runtimeType) {
      //#region CRUD
      case AddMusicEvent:
        AddedMusicState nextState = AddedMusicState(
          musics: state.musics,
          allMusics: state.allMusics,
          categories: state.categories,
          currentMusic: state.currentMusic,
          currentCategory: state.currentCategory,
          artists: state.artists,
          currentArtist: state.currentArtist,
          assetAudio: state.assetAudio,
          hiveHandler: state.hiveHandler,
          scrollController: state.scrollController,
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
          assetAudio: state.assetAudio,
          hiveHandler: state.hiveHandler,
          scrollController: state.scrollController,
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
          assetAudio: state.assetAudio,
          hiveHandler: state.hiveHandler,
          scrollController: state.scrollController,
        );
        await nextState.add((event as AddCategoryEvent).category);
        emit(nextState);
        break;
      case SaveJsonDataEvent:
        SavedJsonDataState nextState = SavedJsonDataState(
          musics: state.musics,
          allMusics: state.allMusics,
          categories: state.categories,
          currentMusic: state.currentMusic,
          currentCategory: state.currentCategory,
          artists: state.artists,
          currentArtist: state.currentArtist,
          assetAudio: state.assetAudio,
          hiveHandler: state.hiveHandler,
          scrollController: state.scrollController,
        );
        await nextState.save();
        emit(nextState);
        break;
      case UpdateArtistEvent:
        UpdatedArtistState nextState = UpdatedArtistState(
          musics: state.musics,
          allMusics: state.allMusics,
          categories: state.categories,
          currentMusic: state.currentMusic,
          currentCategory: state.currentCategory,
          artists: state.artists,
          currentArtist: state.currentArtist,
          assetAudio: state.assetAudio,
          hiveHandler: state.hiveHandler,
          scrollController: state.scrollController,
        );
        await nextState.update((event as UpdateArtistEvent).artist);
        emit(nextState);
        break;
      case UpdateCategoryEvent:
        UpdatedCategoryState nextState = UpdatedCategoryState(
          musics: state.musics,
          allMusics: state.allMusics,
          categories: state.categories,
          currentMusic: state.currentMusic,
          currentCategory: state.currentCategory,
          artists: state.artists,
          currentArtist: state.currentArtist,
          assetAudio: state.assetAudio,
          hiveHandler: state.hiveHandler,
          scrollController: state.scrollController,
        );
        await nextState.update((event as UpdateCategoryEvent).category);
        emit(nextState);
        break;
      case UpdateMusicEvent:
        UpdatedMusicState nextState = UpdatedMusicState(
          musics: state.musics,
          allMusics: state.allMusics,
          categories: state.categories,
          currentMusic: state.currentMusic,
          currentCategory: state.currentCategory,
          artists: state.artists,
          currentArtist: state.currentArtist,
          assetAudio: state.assetAudio,
          hiveHandler: state.hiveHandler,
          scrollController: state.scrollController,
        );
        await nextState.update((event as UpdateMusicEvent).music);
        emit(nextState);
        break;
      case DeleteArtistEvent:
        DeletedArtistState nextState = DeletedArtistState(
          musics: state.musics,
          allMusics: state.allMusics,
          categories: state.categories,
          currentMusic: state.currentMusic,
          currentCategory: state.currentCategory,
          artists: state.artists,
          currentArtist: state.currentArtist,
          assetAudio: state.assetAudio,
          hiveHandler: state.hiveHandler,
          scrollController: state.scrollController,
        );
        await nextState.delete((event as DeleteArtistEvent).artist);
        emit(nextState);
        break;
      case DeleteCategoryEvent:
        DeletedCategoryState nextState = DeletedCategoryState(
          musics: state.musics,
          allMusics: state.allMusics,
          categories: state.categories,
          currentMusic: state.currentMusic,
          currentCategory: state.currentCategory,
          artists: state.artists,
          currentArtist: state.currentArtist,
          assetAudio: state.assetAudio,
          hiveHandler: state.hiveHandler,
          scrollController: state.scrollController,
        );
        await nextState.delete((event as DeleteCategoryEvent).category);
        emit(nextState);
        break;
      case DeleteMusicEvent:
        DeletedMusicState nextState = DeletedMusicState(
          musics: state.musics,
          allMusics: state.allMusics,
          categories: state.categories,
          currentMusic: state.currentMusic,
          currentCategory: state.currentCategory,
          artists: state.artists,
          currentArtist: state.currentArtist,
          assetAudio: state.assetAudio,
          hiveHandler: state.hiveHandler,
          scrollController: state.scrollController,
        );
        await nextState.delete((event as DeleteMusicEvent).music);
        emit(nextState);
        break;
        //#endregion
      case SelectMusicEvent:
        SelectedMusicState nextState = SelectedMusicState(
          musics: state.musics,
          allMusics: state.allMusics,
          categories: state.categories,
          currentMusic: state.currentMusic,
          currentCategory: state.currentCategory,
          artists: state.artists,
          currentArtist: state.currentArtist,
          assetAudio: state.assetAudio,
          hiveHandler: state.hiveHandler,
          scrollController: state.scrollController,
        )
          ..select(event.music);
        emit(nextState);
        break;
      case SearchMusic:
        SearchedMusicState nextState = SearchedMusicState(
          musics: state.musics,
          allMusics: state.allMusics,
          categories: state.categories,
          currentMusic: state.currentMusic,
          currentCategory: state.currentCategory,
          artists: state.artists,
          currentArtist: state.currentArtist,
          assetAudio: state.assetAudio,
          hiveHandler: state.hiveHandler,
          scrollController: state.scrollController,
        )
          ..search((event as SearchMusic).searchValue, event.value);
        emit(nextState);
        break;
      case InitMusicEvent:
        InitMusicState nextState = InitMusicState(
          musics: state.musics,
          allMusics: state.allMusics,
          categories: state.categories,
          currentMusic: state.currentMusic,
          currentCategory: state.currentCategory,
          artists: state.artists,
          currentArtist: state.currentArtist,
          assetAudio: state.assetAudio,
          hiveHandler: state.hiveHandler,
          scrollController: state.scrollController,
        );
        await nextState.init((event as InitMusicEvent).context);
        emit(nextState);
        break;
      case SortMusicsEvent:
        SortedMusicsState nextState = SortedMusicsState(
          musics: state.musics,
          allMusics: state.allMusics,
          categories: state.categories,
          currentMusic: state.currentMusic,
          currentCategory: state.currentCategory,
          artists: state.artists,
          currentArtist: state.currentArtist,
          assetAudio: state.assetAudio,
          hiveHandler: state.hiveHandler,
          scrollController: state.scrollController,
        )
          ..sort((event as SortMusicsEvent).value);
        emit(nextState);
        break;
      case NextMusicEvent:
        NextMusicState nextState = NextMusicState(
          musics: state.musics,
          allMusics: state.allMusics,
          categories: state.categories,
          currentMusic: state.currentMusic,
          currentCategory: state.currentCategory,
          artists: state.artists,
          currentArtist: state.currentArtist,
          assetAudio: state.assetAudio,
          hiveHandler: state.hiveHandler,
          scrollController: state.scrollController,
        )
          ..next();
        emit(nextState);
        break;
    }
  }
}