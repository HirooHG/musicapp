import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:musicapp/modelview/musicbloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:musicapp/modelview/music.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  late double width;
  late double height;

  final TextEditingController nameController = TextEditingController();

  Future dia ({required BuildContext context, required String path}) async {
    var name = path.split("/")[6];

    await showDialog(
      context: context,
      builder: (context) {
        return BlocBuilder<MusicBloc, MusicState>(
          builder: (context, musicState) {
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
                            ),
                          ),
                        )
                      ),
                      SizedBox(
                        width: width * 0.5,
                        child: TextField(
                          style: const TextStyle(
                            color: Colors.white
                          ),
                          decoration: const InputDecoration(
                            labelText: "artist",
                            labelStyle: TextStyle(
                              color: Colors.white
                            )
                          ),
                          onSubmitted: (value) {
                          },
                        )
                      ),
                      SizedBox(
                          width: width * 0.5,
                          child: TextField(
                            style: const TextStyle(
                                color: Colors.white
                            ),
                            decoration: const InputDecoration(
                                labelText: "Category",
                                labelStyle: TextStyle(
                                    color: Colors.white
                                )
                            ),
                            onSubmitted: (value) {

                            },
                          )
                      ),
                      SizedBox(
                        width: width * 0.5,
                        child: DropdownButtonFormField(
                          value: musicState.currentArtist,
                          items: musicState.artists.map((e) {
                            return DropdownMenuItem(
                              value: e,
                              child: Text(
                                e.name,
                                style: const TextStyle(
                                  color: Colors.white
                                )
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                          },
                        ),
                      ),
                      SizedBox(
                        width: width * 0.5,
                        child: DropdownButtonFormField(
                          value: musicState.currentCategory,
                          items: musicState.categories.map((e) {
                            return DropdownMenuItem(
                              value: e,
                              child: Text(
                                  e.name,
                                  style: const TextStyle(
                                      color: Colors.white
                                  )
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      var name = nameController.text;

                      if(name.isNotEmpty) {
                        nameController.text = "";
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
          },
        );
      }
    );
  }

  bool isLoaded = false;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    //if(!isLoaded) {
    //  BlocProvider.of<MusicBloc>(context).add(const InitMusicEvent());
    //  isLoaded = true;
    //}

    Hive.openBox<Music>("musics").then((value) {
      for (var i in value.values) {
        print(i.name);
      }

      for (var i in value.values) {
        i.name = "yay";
        print(i.name);
      }
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
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(9),
                child: const Text(
                  "File",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                  )
                ),
              )
            )
          )
        )
      )
    );
  }
}

