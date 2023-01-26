import 'dart:io';
import 'dart:convert';

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

  bool isLoaded = false;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    if(!isLoaded) {
      BlocProvider.of<MusicBloc>(context).add(const InitMusicEvent());
      isLoaded = true;
    }

    Hive.openBox<Music>("musics").then((value) {
      Map<int, Map<String, dynamic>> map = {};

      for(var i in value.values) {
        map.addAll({ i.key: i.toMap() });
      }

      var text = jsonEncode(map);
      print(text);
    });

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: const Color(0xFF1a1a1a),
          child: Center(
            child: BlocBuilder<MusicBloc, MusicState>(
              builder: (context, musicState) {
                return Container();
              },
            )
          )
        )
      )
    );
  }
}

