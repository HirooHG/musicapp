
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:musicapp/modelview/music.dart';

class HiveHandler {

  Future<Box<Music>> get musicBox async => await Hive.openBox("musics");
  Future<Box<Artist>> get artistBox async => await Hive.openBox("artists");
  Future<Box<Category>> get categoryBox async => await Hive.openBox("categories");

  //Create
  Future createMusic(Music music) async {
    await (await musicBox).add(music);
  }
  Future createCategory(Category category) async {
    await (await categoryBox).add(category);
  }
  Future createArtist(Artist artist) async {
    await (await artistBox).add(artist);
  }

  // Read
  Future<List<Music>> getMusics() async {
    return (await musicBox).values.toList();
  }
  Future<List<Artist>> getArtist() async {
    return (await artistBox).values.toList();
  }
  Future<List<Category>> getCategories() async {
    return (await categoryBox).values.toList();
  }

  // Delete
  Future deleteMusic(Music music) async {
    await (await musicBox).delete(music);
  }
  Future deleteArtist(Artist artist) async {
    await (await artistBox).delete(artist);
  }
  Future deleteCategory(Category category) async {
    await (await categoryBox).delete(category);
  }
}