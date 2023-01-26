
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

//class
class Music extends HiveObject {

  String name;
  Artist artist;
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
    artist = Artist.empty(),
    link = "",
    category = Category.empty();

  Map<String, dynamic> toMap() {
    return {
      "key": key,
      "box": {
        "name": box!.name,
        "path": box!.path,
      },
      "name": name,
      "artist": artist.toMap(),
      "link": link,
      "category": category.toMap(),
    };
  }

  @override bool operator ==(Object other) {
    return other.runtimeType == Music
        && name == (other as Music).name
        && artist == other.artist
        && link == other.link
        && category == other.category
        && key == other.key
        && box == other.box;
  }
}
class Category extends HiveObject{
  String name;

  Category({required this.name});
  Category.empty() :
    name = "No category";

  Map<String, dynamic> toMap() {
    return {
      "key": key,
      "name": name
    };
  }

  @override bool operator ==(Object other) {
    return other.runtimeType == Category
        && name == (other as Category).name
        && key == other.key
        && box == other.box;
  }
}
class Artist extends HiveObject{

  String name;

  Artist({required this.name});
  Artist.empty() :
    name = "unknown";

  Map<String, dynamic> toMap() {
    return {
      "key": key,
      "name": name
    };
  }

  @override bool operator ==(Object other) {
    return other.runtimeType == Artist
        && name == (other as Artist).name
        && key == other.key
        && box == other.box;
  }
}

//adapter Hive
class MusicAdapter extends TypeAdapter<Music> {
  @override
  final typeId = 0;

  @override
  Music read(BinaryReader reader) {
    var map = reader.read() as Map<dynamic, dynamic>;
    return Music(name: map["name"], artist: Artist(name: map["artist"]), link: map["link"], category: Category(name: map["category"]));
  }

  @override
  void write(BinaryWriter writer, Music obj) {
    writer.write({"name": obj.name,"artist": obj.artist.name, "link": obj.link, "category": obj.category.name});
  }
}
class ArtistAdapter extends TypeAdapter<Artist> {
  @override
  final typeId = 1;

  @override
  Artist read(BinaryReader reader) {
    return Artist(name: reader.read());
  }

  @override
  void write(BinaryWriter writer, Artist obj) {
    writer.write(obj.name);
  }
}
class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final typeId = 2;

  @override
  Category read(BinaryReader reader) {
    return Category(name: reader.read());
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    writer.write(obj.name);
  }
}
