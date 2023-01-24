import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

import '../modelview/music.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  Box? box;

  late double width;
  late double height;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController artistController = TextEditingController();

  Future dia ({required BuildContext context, required String path}) async {
    var name = path.split("/")[6];

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "select music name for \n$name",
            style: const TextStyle(
              fontFamily: "Ubuntu",
              fontWeight: FontWeight.bold,
              color: Color(0xff7dba7a),
              fontSize: 15
            )
          ),
          backgroundColor: const Color(0xFF1a1a1a),
          content: SizedBox(
            height: height * 0.3,
            child: Column(
              children: [
                SizedBox(
                  width: width * 0.5,
                  child: TextField(
                    controller: nameController,
                    style: const TextStyle(
                      color: Colors.white
                    ),
                    decoration: const InputDecoration(
                      labelText: "name",
                      labelStyle: TextStyle(
                        color: Colors.white
                      )
                    ),
                  )
                ),
                SizedBox(
                  width: width * 0.5,
                  child: TextField(
                    controller: artistController,
                    style: const TextStyle(
                      color: Colors.white
                    ),
                    decoration: const InputDecoration(
                      labelText: "artist",
                      labelStyle: TextStyle(
                        color: Colors.white
                      )
                    ),
                  )
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                var name = nameController.text;
                var artist = artistController.text;

                if(name.isNotEmpty && artist.isNotEmpty && box != null) {
                  var music = Music(name: name, artist: Artist(name: artist), link: path, category: Category.empty());
                  box!.add(music);
                  nameController.text = ""; artistController.text = "";
                  Navigator.of(context).pop();
                }
              },
              child: const Text(
               "register",
                style: TextStyle(
                  fontFamily: "Ubuntu",
                  fontWeight: FontWeight.bold,
                  color: Color(0xffff7bff)
                )
              )
            )
          ]
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    Hive.openBox("musics").then((tbox) async {
      box = tbox;
      await box!.delete(0);
      await box!.delete(1);
      print(box!.values);
    });

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: const Color(0xFF1a1a1a),
          child: Center(
            child: TextButton(
              onPressed: () async {
                var dir = Directory("/data/user/0/fr.HirooHG.musicapp/musics");
                var files = dir.listSync();
                for(var i in files) {
                  await dia(context: context, path: i.path);
                }
              },
              child: const Text("File")
            )
          )
        )
      )
    );
  }
}

