
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 0)
class Music extends HiveObject {

  @HiveField(0)
  String name;

  @HiveField(1)
  String artist;

  @HiveField(2)
  String link;

  @HiveField(3)
  Category category;

  Audio? _audio;

  Audio? get audio {
    _audio ??= Audio(link);
    return _audio;
  }

  Music(
    this.name,
    this.artist,
    this.link,
    this.category
  );
}

@HiveType(typeId: 1)
class Category extends HiveObject {

  @HiveField(0)
  String name;

  Category(this.name);
}
