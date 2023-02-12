import 'dart:math';

import 'package:animated_icon/animate_icon.dart';
import 'package:animated_icon/animate_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicapp/view/musicview.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:musicapp/view/playingmusicview.dart';
import 'package:musicapp/modelview/musicbloc.dart';
import 'package:musicapp/modelview/cubits.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  late double width;
  late double height;

  String searchedMusic = "";

  bool isLoaded = false;

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
          child: BlocBuilder<SearchValue, int>(
            builder: (context, searchValue) {
              return BlocBuilder<MusicBloc, MusicState>(
                builder: (context, musicState) {
                  var musics = musicState.musics;

                  if(!isLoaded) {
                    BlocProvider.of<MusicBloc>(context).add(InitMusicEvent(context: context));
                    musicState.assetAudio.playlistAudioFinished.listen((event) {
                      BlocProvider.of<MusicBloc>(context).add(const NextMusicEvent());
                    });
                    isLoaded = true;
                  }

                  return Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: width * 0.3,
                                  height: 40,
                                  child: TextButton(
                                    onPressed: () {
                                      BlocProvider.of<MusicBloc>(context).add(SelectMusicEvent());
                                      BlocProvider.of<PauseCubit>(context).change(true);
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          Icons.play_circle,
                                          color: Colors.white
                                        ),
                                        Text(
                                          "play all",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Ubuntu"
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8)
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      Random rand = Random();
                                      var music = musicState.musics[rand.nextInt(musicState.musics.length)];
                                      BlocProvider.of<MusicBloc>(context).add(SelectMusicEvent(music: music));
                                      BlocProvider.of<PauseCubit>(context).change(true);
                                    },
                                    child: const Text(
                                      "Random",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Ubuntu"
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)
                            ),
                            child: TextField(
                              cursorColor: Colors.black,
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: "Ubuntu"
                              ),
                              decoration: const InputDecoration(
                                label: Text(
                                  "Search",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Ubuntu"
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none)
                              ),
                              onChanged: (value) {
                                BlocProvider.of<MusicBloc>(context).add(
                                  SearchMusic(searchValue: searchValue, value: value)
                                );
                              },
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: (musicState.currentArtist.name != "unknown" && musicState.currentArtist.name != "All")
                                    ? Colors.white
                                    : Colors.grey,
                                  width: 2
                                )
                              ),
                            ),
                            child: DropdownButton<int>(
                                value: searchValue,
                                underline: Container(),
                                menuMaxHeight: height * 0.5,
                                dropdownColor: Colors.black,
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: (musicState.currentArtist.name != "unknown" && musicState.currentArtist.name != "All")
                                    ? Colors.white
                                    : Colors.grey,
                                ),
                                items: [
                                  DropdownMenuItem<int>(
                                    value: 0,
                                    child: SizedBox(
                                      width: width * 0.3,
                                      child: const Text(
                                        "Music",
                                        style: TextStyle(
                                          fontFamily: "Ubuntu",
                                          color: Colors.white
                                        ),
                                      )
                                    )
                                  ),
                                  DropdownMenuItem<int>(
                                    value: 1,
                                    child: SizedBox(
                                      width: width * 0.3,
                                      child: const Text(
                                        "Category",
                                        style: TextStyle(
                                          fontFamily: "Ubuntu",
                                          color: Colors.white
                                        ),
                                      )
                                    )
                                  ),
                                  DropdownMenuItem<int>(
                                    value: 2,
                                    child: SizedBox(
                                      width: width * 0.3,
                                      child: const Text(
                                        "Artist",
                                        style: TextStyle(
                                          fontFamily: "Ubuntu",
                                          color: Colors.white
                                        ),
                                      )
                                    )
                                  ),
                                ],
                                onChanged: (value) {
                                  if(value != null) {
                                    BlocProvider.of<MusicBloc>(context).add(SortMusicsEvent(value: value));
                                    BlocProvider.of<SearchValue>(context).change(value);
                                  }
                                }
                            ),
                          ),
                          Expanded (
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              child: ListView.builder(
                                controller: musicState.scrollController,
                                itemCount: musics.length,
                                itemBuilder: (context, index) {
                                  var music = musics[index];
                                  return GestureDetector(
                                    onTap: () {
                                      BlocProvider.of<MusicBloc>(context).add(SelectMusicEvent(music: music));
                                      BlocProvider.of<PauseCubit>(context).change(true);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(top: 20),
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(color: Colors.grey)
                                        )
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          music.name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Ubuntu",
                                            fontSize: 20
                                          ),
                                        ),
                                        subtitle: Container(
                                          margin: const EdgeInsets.only(left: 40),
                                          child: Text(
                                            music.artist.name,
                                            style: const TextStyle(
                                              fontFamily: "Ubuntu",
                                              color: Colors.white,
                                              fontStyle: FontStyle.italic
                                            ),
                                          ),
                                        ),
                                        trailing: SizedBox(
                                          width: width * 0.22,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              (musicState.currentMusic != music) ? const SizedBox() : AnimateIcon(
                                                iconType: IconType.continueAnimation,
                                                height: 30,
                                                width: 30,
                                                color: Colors.white,
                                                animateIcon: AnimateIcons.circlesMenu2,
                                                onTap: () {
                                                  // do nothing
                                                },
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) => MultiBlocProvider(
                                                        providers: [
                                                          BlocProvider.value(
                                                            value: BlocProvider.of<MusicBloc>(context)
                                                          ),
                                                          BlocProvider.value(
                                                            value: BlocProvider.of<PauseCubit>(context)
                                                          )
                                                        ],
                                                        child: MusicView(music: music)
                                                      )
                                                    )
                                                  );
                                                },
                                                icon: const Icon(Icons.more_vert, color: Colors.white)
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              ),
                            ),
                          )
                        ],
                      ),
                      (musicState.currentMusic.name == "")
                          ? Container()
                          : MusicBar(jump: jump, scrollController: musicState.scrollController)
                    ],
                  );
                },
              );
            },
          ),
        )
      )
    );
  }
}

class MusicBar extends StatelessWidget {
  MusicBar({required this.jump, super.key, this.scrollController});

  final int jump;
  final ScrollController? scrollController;
  double? width;
  double? height;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return BlocBuilder<MusicBloc, MusicState>(
      builder: (context, musicState) {
        return Positioned(
          bottom: 0,
          child: Container(
            width: width,
            height: height! * 0.085,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Hero(
                  tag: "musicphoto",
                  child: Container(
                    margin: const EdgeInsets.only(left: 20),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.black,
                    ),
                    child: const Center(
                      child: Text(
                        "photo",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MultiBlocProvider(
                            providers: [
                              BlocProvider.value(
                                value: BlocProvider.of<MusicBloc>(context)
                              ),
                              BlocProvider.value(
                                value: BlocProvider.of<PauseCubit>(context)
                              )
                            ],
                            child: PlayingMusicView()
                          )
                        )
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            musicState.currentMusic.name,
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: "Ubuntu",
                              fontWeight: FontWeight.bold,
                              fontSize: 18
                            ),
                          ),
                          Text(
                            musicState.currentMusic.artist.name,
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: "Ubuntu",
                              fontStyle: FontStyle.italic
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    BlocProvider.of<PauseCubit>(context).change(true);
                    BlocProvider.of<MusicBloc>(context).add(const PreviousMusicEvent());
                  },
                  icon: const Icon(Icons.skip_previous),
                ),
                StreamBuilder(
                  stream: musicState.assetAudio.currentPosition,
                  builder: (context, snapshot) {
                    double percent = 0;
                    Duration duration = const Duration();
                    Duration pos = const Duration();

                    try {
                      duration = musicState.assetAudio.current.value!.audio.duration;
                      pos = snapshot.data!;
                      percent = pos.inSeconds / duration.inSeconds;
                    } catch(e) {
                      //
                    }

                    return CircularPercentIndicator(
                      radius: 15,
                      lineWidth: 2.0,
                      percent: percent,
                      center: IconButton(
                        onPressed: () async {
                          if(musicState.assetAudio.isPlaying.value) {
                            await musicState.assetAudio.pause().whenComplete(() {
                              BlocProvider.of<PauseCubit>(context).change(false);
                            });
                          } else {
                            await musicState.assetAudio.play().whenComplete(() {
                              BlocProvider.of<PauseCubit>(context).change(true);
                            });
                          }
                        },
                        icon: BlocBuilder<PauseCubit, bool>(
                          builder: (context, isPaused) {
                            return Icon(
                              (!isPaused) ? Icons.play_arrow : Icons.pause,
                              color: Colors.black,
                              size: 15,
                            );
                          },
                        ),
                      ),
                      backgroundColor: Colors.white,
                      progressColor: Colors.black,
                    );
                  },
                ),
                IconButton(
                  onPressed: () async {
                    BlocProvider.of<PauseCubit>(context).change(true);
                    BlocProvider.of<MusicBloc>(context).add(const NextMusicEvent());
                  },
                  icon: const Icon(Icons.skip_next),
                ),
                IconButton(
                  onPressed: () {
                    //TODO: implement playlists
                  },
                  icon: const Icon(Icons.playlist_add),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}