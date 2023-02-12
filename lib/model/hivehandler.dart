
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:musicapp/modelview/music.dart';

class HiveHandler {

  Future<Box<Music>> get musicBox async => await Hive.openBox("musics");
  Future<Box<Artist>> get artistBox async => await Hive.openBox("artists");
  Future<Box<Category>> get categoryBox async => await Hive.openBox("categories");

  Future create(HiveObject obj, Box box) async {
    if(!obj.isInBox) {
      await box.add(obj);
    }
  }
  Future update(HiveObject obj) async => await obj.save();
  Future delete(HiveObject obj) async => await obj.delete();

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
}