import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';

import 'music.dart';
import 'package:musicapp/model/hivehandler.dart';


// Events
abstract class MusicEvent {
  const MusicEvent();
}
class InitMusicEvent extends MusicEvent {
  const InitMusicEvent();
}
class ChangeCategoryEvent extends MusicEvent {
  ChangeCategoryEvent({required this.category});

  final Category category;
}
class ChangeArtistEvent extends MusicEvent {
  ChangeArtistEvent({required this.artist});

  final Artist artist;
}
class SaveJsonDataEvent extends MusicEvent {
  const SaveJsonDataEvent();
}
class GetAllMusic extends MusicEvent {
  const GetAllMusic();
}
class SearchMusic extends MusicEvent {
  const SearchMusic();
}

// CRUD
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
class SelectMusicEvent extends MusicEvent {
  SelectMusicEvent({required this.music});

  final Music music;
}

// States
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

    musics = await hiveHandler.getMusics();
    categories = await hiveHandler.getCategories();
    artists = await hiveHandler.getArtist();
    
    musics.sort((a, b) => a.artist.name.compareTo(b.artist.name));

    for(var i in musics) {
      var z = categories.singleWhere((element) => element.name == i.category.name);
      var w = artists.singleWhere((element) => element.name == i.artist.name);
      i.category = z;
      i.artist = w;
    }

    if(allMusics.isEmpty) {
      allMusics.addAll(musics);
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

    currentCategory = categories.singleWhere((element) => element.name == "All");
    currentArtist = artists.singleWhere((element) => element.name == "All");
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

  Future change() async {
    musics = allMusics.where(
      (element) {
        if(currentCategory.name == "All" && currentArtist.name == "All"){
          return true;
        } else if (currentCategory.name == "All") {
          return element.artist == currentArtist;
        } else if (currentArtist.name == "All") {
          return element.category == currentCategory;
        } else {
          return element.category == currentCategory && element.artist == currentArtist;
        }
      }
    ).toList();
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

  Future change() async {
    musics = allMusics.where(
      (element) {
        if(currentCategory.name == "All" && currentArtist.name == "All"){
          return true;
        } else if (currentCategory.name == "All") {
          return element.artist == currentArtist;
        } else if (currentArtist.name == "All") {
          return element.category == currentCategory;
        } else {
          return element.category == currentCategory && element.artist == currentArtist;
        }
      }
    ).toList();
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
    required super.hiveHandler
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
class GotAllMusic extends MusicState {
  GotAllMusic({
    required super.musics,
    required super.categories,
    required super.artists,
    required super.allMusics,
    required super.currentMusic,
    required super.currentCategory,
    required super.currentArtist,
    required super.hiveHandler
  });

  void get() {
    musics.clear();
    musics.addAll(allMusics);
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
    required super.hiveHandler
  });
}

//CRUD
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
    required super.hiveHandler
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
    required super.hiveHandler
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
    required super.hiveHandler
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
    required super.hiveHandler
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
    required super.hiveHandler
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
    required super.hiveHandler
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
    required super.hiveHandler
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
    required super.hiveHandler
  });

  Future delete(Music music) async {
    await hiveHandler.delete(music);
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
    required super.hiveHandler
  });
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
      case GetAllMusic:
        GotAllMusic nextState = GotAllMusic(
          musics: state.musics,
          allMusics: state.allMusics,
          categories: state.categories,
          currentMusic: state.currentMusic,
          currentCategory: state.currentCategory,
          artists: state.artists,
          currentArtist: state.currentArtist,
          hiveHandler: state.hiveHandler
        );
        nextState.get();
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
      case ChangeCategoryEvent:
        ChangedCategoryState nextState = ChangedCategoryState(
          musics: state.musics,
          allMusics: state.allMusics,
          categories: state.categories,
          currentMusic: state.currentMusic,
          currentCategory: (event as ChangeCategoryEvent).category,
          artists: state.artists,
          currentArtist: state.currentArtist,
          hiveHandler: state.hiveHandler
        );
        await nextState.change();
        emit(nextState);
        break;
      case ChangeArtistEvent:
        ChangedArtistState nextState = ChangedArtistState(
          musics: state.musics,
          allMusics: state.allMusics,
          categories: state.categories,
          currentMusic: state.currentMusic,
          currentCategory: state.currentCategory,
          artists: state.artists,
          currentArtist: (event as ChangeArtistEvent).artist,
          hiveHandler: state.hiveHandler
        );
        await nextState.change();
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
          hiveHandler: state.hiveHandler
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
          hiveHandler: state.hiveHandler
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
          hiveHandler: state.hiveHandler
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
          hiveHandler: state.hiveHandler
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
          hiveHandler: state.hiveHandler
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
          hiveHandler: state.hiveHandler
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
          hiveHandler: state.hiveHandler
        );
        await nextState.delete((event as DeleteMusicEvent).music);
        emit(nextState);
        break;
      case SelectMusicEvent:
        SelectedMusicState nextState = SelectedMusicState(
          musics: state.musics,
          allMusics: state.allMusics,
          categories: state.categories,
          currentMusic: (event as SelectMusicEvent).music,
          currentCategory: state.currentCategory,
          artists: state.artists,
          currentArtist: state.currentArtist,
          hiveHandler: state.hiveHandler
        );
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
          hiveHandler: state.hiveHandler
        );
        emit(nextState);
    }
  }
}
