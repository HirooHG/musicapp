
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:musicapp/modelview/musicbloc.dart';
import 'package:musicapp/modelview/music.dart';
import 'homeview.dart';

class MusicView extends StatelessWidget {
  MusicView({super.key, required this.music});

  late double width;
  late double height;

  final Music music;
  final jump = 93;

  @override
  Widget build(BuildContext context) {

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

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
          padding: const EdgeInsets.all(20),
          child: BlocBuilder<MusicBloc, MusicState>(
            builder: (context, musicState) {
              return SizedBox(
                width: width,
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
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
                        SizedBox(
                          height: height * 0.1,
                        ),
                        Container(
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
                        Container(
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
                      ],
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