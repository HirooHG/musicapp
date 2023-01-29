import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import "modelview/music.dart";
import 'musicapp.dart';

void main() async {
  var dir = Directory("/data/user/0/fr.HirooHG.musicapp/musics");
  if(! (await dir.exists())) {
    await dir.create();
  }

  await Hive.initFlutter();
  Hive.registerAdapter(MusicAdapter());
  Hive.registerAdapter(ArtistAdapter());
  Hive.registerAdapter(CategoryAdapter());
  runApp(const MusicApp());
}
