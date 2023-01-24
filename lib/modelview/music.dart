
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Music extends HiveObject {

  String name;
  String artist;
  String link;
  Category category;

  Audio? _audio;

  Audio? get audio {
    _audio ??= Audio(link);
    return _audio;
  }

  Music({
    required this.name,
    required this.artist,
    required this.link,
    required this.category
  });

  Music.empty() :
    name = "",
    artist = "",
    link = "",
    category = Category.empty();
}
class Category extends HiveObject {
  String name;

  Category({required this.name});
  Category.empty() :
    name = "";
}

class MusicAdapter extends TypeAdapter<Music> {
  @override
  final typeId = 0;

  @override
  Music read(BinaryReader reader) {
    var map = reader.read() as Map<dynamic, dynamic>;
    return Music(name: map["name"], artist: map["artist"], link: map["link"], category: Category(name: map["category"]));
  }

  @override
  void write(BinaryWriter writer, Music obj) {
    writer.write({"name": obj.name,"artist": obj.artist, "link": obj.link, "category": obj.category.name});
  }
}

