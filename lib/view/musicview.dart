import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:musicapp/modelview/cubits.dart';
import 'package:path_provider/path_provider.dart';

import 'package:musicapp/modelview/musicbloc.dart';
import 'package:musicapp/modelview/music.dart';
import 'homeview.dart';

class MusicView extends StatelessWidget {
  MusicView({super.key, required this.music});

  late double width;
  late double height;

  final Music music;
  final jump = 93;

  late TextEditingController nameController;
  late TextEditingController linkController;

  bool isLoaded = false;

  @override
  Widget build(BuildContext context) {

    if(!isLoaded) {
      width = MediaQuery.of(context).size.width;
      height = MediaQuery.of(context).size.height;

      nameController = TextEditingController();
      linkController = TextEditingController();

      nameController.clear();
      linkController.clear();

      nameController.text = music.name;
      linkController.text = "${music.link.split("/")[5]}/${music.link.split("/")[6]}";
      isLoaded = true;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1a1a1a),
        shadowColor: Colors.white,
        elevation: 2.0,
        title: const Text(
          "Music",
          style: TextStyle(
            fontFamily: "Ubuntu"
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: const Color(0xFF1a1a1a),
          child: BlocBuilder<MusicBloc, MusicState>(
            builder: (context, musicState) {
              return SizedBox(
                width: width,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: width,
                            child: Text(
                              music.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: "Ubuntu",
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                              ),
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 30, bottom: 30),
                                    child: const Divider(
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: width,
                                    child: TextField(
                                      controller: nameController,
                                      cursorColor: Colors.white,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Ubuntu",
                                      ),
                                      decoration: const InputDecoration(
                                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                          label: Text(
                                            "Name",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "Ubuntu"
                                            ),
                                          )
                                      ),
                                      onSubmitted: (value) {
                                        if(value.isNotEmpty && value != music.name) {
                                          music.name = value;
                                          BlocProvider.of<MusicBloc>(context).add(UpdateMusicEvent(music: music));
                                        } else {
                                          nameController.text = music.name;
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: width,
                                    child: TextField(
                                      controller: linkController,
                                      cursorColor: Colors.white,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Ubuntu",
                                      ),
                                      decoration: const InputDecoration(
                                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                          label: Text(
                                            "Link",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "Ubuntu"
                                            ),
                                          )
                                      ),
                                      readOnly: true,
                                      onTap: () async {
                                        FilePickerResult? res = await FilePicker.platform.pickFiles(
                                          type: FileType.audio,
                                        );

                                        if(res != null) {
                                          var path = res.files.single.path;
                                          File file = File(path!);

                                          if(path != music.link && file.path.substring(file.path.length - 4, file.path.length) == ".mp3") {
                                            var newPath = "/data/user/0/fr.HirooHG.musicapp/musics/${music.artist.name} - ${music.name}.mp3";
                                            await file.copy(newPath);
                                            await File(music.link).delete();
                                            file.delete().whenComplete(() {
                                              music.link = newPath;
                                              BlocProvider.of<MusicBloc>(context).add(UpdateMusicEvent(music: music));
                                            });
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.1,
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.white,
                                                width: 2
                                            )
                                        ),
                                      ),
                                      child: DropdownButton<Artist>(
                                          value: music.artist,
                                          underline: Container(),
                                          menuMaxHeight: height * 0.5,
                                          dropdownColor: const Color(0xFF1a1a1a),
                                          icon: const Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: Colors.white,
                                          ),
                                          items: musicState.artists.map((e) {
                                            return DropdownMenuItem<Artist>(
                                                value: e,
                                                child: Text(
                                                  e.name,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: "Ubuntu",
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            if(value != null && value != music.artist) {
                                              BlocProvider.of<MusicBloc>(context).add(UpdateMusicEvent(music: music));
                                            }
                                          }
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.white,
                                                    width: 2
                                                )
                                            ),
                                          ),
                                          child: DropdownButton<Category>(
                                              value: music.category,
                                              underline: Container(),
                                              menuMaxHeight: height * 0.5,
                                              dropdownColor: const Color(0xFF1a1a1a),
                                              icon: const Icon(
                                                Icons.keyboard_arrow_down_rounded,
                                                color: Colors.white,
                                              ),
                                              items: musicState.categories.map((e) {
                                                return DropdownMenuItem<Category>(
                                                  value: e,
                                                  child: Text(
                                                    e.name,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: "Ubuntu",
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  )
                                                );
                                              }).toList(),
                                              onChanged: (value) {
                                                if(value != null && value != music.artist) {
                                                  BlocProvider.of<MusicBloc>(context).add(UpdateMusicEvent(music: music));
                                                }
                                              }
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          BlocProvider.of<PauseCubit>(context).change(true);
                                          BlocProvider.of<MusicBloc>(context).add(SelectMusicEvent(music: music));
                                        },
                                        icon: const Icon(Icons.play_circle, color: Colors.white, size: 50),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: height * 0.05,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(8)
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        BlocProvider.of<MusicBloc>(context).add(DeleteMusicEvent(music: music));
                                      },
                                      child: const Text(
                                        "Delete",
                                        style: TextStyle(
                                          fontFamily: "Ubuntu",
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    (musicState.currentMusic.name == "")
                      ? Container()
                      : MusicBar(jump: jump)
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}