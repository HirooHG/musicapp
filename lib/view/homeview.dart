import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:musicapp/modelview/musicbloc.dart';
import 'package:musicapp/modelview/cubits.dart';
import 'package:musicapp/modelview/music.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  late double width;
  late double height;

  bool isLoaded = false;
  bool isLoadedCat = false;
  bool isLoadedArt = false;

  final ScrollController scrollController = ScrollController();
  final assetAudio = AssetsAudioPlayer();

  String searchedMusic = "";

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    if(!isLoaded) {
      BlocProvider.of<MusicBloc>(context).add(const InitMusicEvent());
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

              var searchedMusics = <Music>[];
              searchedMusics.addAll(musicState.musics);

              searchedMusics.retainWhere((s){
                return s.name.contains(searchedMusic.toLowerCase());
              });

              return Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: height * 0.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: (musicState.allMusics.length == musicState.musics.length)
                                      ? Colors.white
                                      : Colors.grey,
                                    width: 2
                                  )
                                )
                              ),
                              child: TextButton(
                                onPressed: () {
                                  BlocProvider.of<MusicBloc>(context).add(const GetAllMusic());
                                },
                                child: Text(
                                  "Tous",
                                  style: TextStyle(
                                    fontFamily: "Ubuntu",
                                    fontWeight: FontWeight.bold,
                                    color: (musicState.allMusics.length == musicState.musics.length)
                                      ? Colors.white
                                      : Colors.grey
                                  ),
                                )
                              )
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: (musicState.currentCategory.name != "No category" && musicState.currentCategory.name != "All")
                                      ? Colors.white
                                      : Colors.grey,
                                    width: 2
                                  )
                                ),
                              ),
                              child: DropdownButton<Category>(
                                value: musicState.currentCategory,
                                dropdownColor: Colors.black,
                                menuMaxHeight: height * 0.2,
                                underline: Container(),
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: (musicState.currentCategory.name != "No category" && musicState.currentCategory.name != "All")
                                    ? Colors.white
                                    : Colors.grey,
                                ),
                                items: musicState.categories.map((cat) {
                                  return DropdownMenuItem(
                                    value: cat,
                                    child: SizedBox(
                                      width: width * 0.3,
                                      child: Text(
                                        cat.name,
                                        style: TextStyle(
                                          fontFamily: "Ubuntu",
                                          color: (musicState.currentCategory.name != "No category" && musicState.currentCategory.name != "All")
                                            ? Colors.white
                                            : Colors.grey,
                                        ),
                                      ),
                                    )
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if(value != null) {
                                    BlocProvider.of<MusicBloc>(context).add(ChangeCategoryEvent(category: value));
                                  }
                                }
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
                              child: DropdownButton<Artist>(
                                value: musicState.currentArtist,
                                underline: Container(),
                                menuMaxHeight: height * 0.5,
                                dropdownColor: Colors.black,
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: (musicState.currentArtist.name != "unknown" && musicState.currentArtist.name != "All")
                                    ? Colors.white
                                    : Colors.grey,
                                ),
                                items: musicState.artists.map((art) {
                                  return DropdownMenuItem(
                                    value: art,
                                    child: SizedBox(
                                      width: width * 0.3,
                                      child: Text(
                                        art.name,
                                        style: TextStyle(
                                          fontFamily: "Ubuntu",
                                          color: (musicState.currentArtist.name != "unknown" && musicState.currentArtist.name != "All")
                                            ? Colors.white
                                            : Colors.grey,
                                        ),
                                      )
                                    )
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if(value != null) {
                                    BlocProvider.of<MusicBloc>(context).add(ChangeArtistEvent(artist: value));
                                  }
                                }
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: width * 0.3,
                            height: 40,
                            child: TextButton(
                              onPressed: () {
                                var music = musicState.musics[0];
                                BlocProvider.of<MusicBloc>(context).add(SelectMusicEvent(music: music));
                                BlocProvider.of<PauseCubit>(context).change(true);
                                assetAudio.open(Audio.file(music.link), showNotification: true);
                                scrollController.jumpTo(0);
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
                                assetAudio.open(Audio.file(music.link), showNotification: true);
                                var pos = musicState.musics.indexOf(music);
                                scrollController.jumpTo(109 * pos.toDouble());
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
                            searchedMusic = value;
                            BlocProvider.of<MusicBloc>(context).add(const SearchMusic());
                          },
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: searchedMusics.length,
                            itemBuilder: (context, index) {
                              var music = searchedMusics[index];
                              return GestureDetector(
                                onTap: () {
                                  BlocProvider.of<MusicBloc>(context).add(SelectMusicEvent(music: music));
                                  assetAudio.open(Audio.file(music.link), showNotification: true);
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
                                    isThreeLine: true,
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
                                  ),
                                ),
                              );
                            }
                          ),
                        ),
                      )
                    ],
                  ),
                  (musicState.currentMusic.name == "") ? Container() : Positioned(
                    bottom: 0,
                    child: Container(
                      width: width,
                      height: height * 0.085,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
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
                          Expanded(
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
                          StreamBuilder(
                            stream: assetAudio.currentPosition,
                            builder: (context, snapshot) {
                              var pos = snapshot.data;
                              double percent = 0;

                              try {
                                var duration = assetAudio.current.value!.audio.duration;
                                var posSec = pos!.inSeconds;
                                percent = posSec / duration.inSeconds;
                              } catch(e) {
                                //
                              }

                              return CircularPercentIndicator(
                                radius: 15,
                                lineWidth: 2.0,
                                percent: percent,
                                center: IconButton(
                                  onPressed: () async {
                                    if(assetAudio.isPlaying.value) {
                                       await assetAudio.pause().whenComplete(() {
                                         BlocProvider.of<PauseCubit>(context).change(false);
                                       });
                                    } else {
                                      await assetAudio.play().whenComplete(() {
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
                              Music nextMusic;
                              try {
                                nextMusic = musicState.musics[musicState.musics.indexOf(musicState.currentMusic) + 1];
                              } catch(e) {
                                nextMusic = musicState.musics[0];
                              }
                              BlocProvider.of<MusicBloc>(context).add(SelectMusicEvent(music: nextMusic));
                              assetAudio.open(Audio.file(nextMusic.link), showNotification: true);
                              var posMusic = musicState.musics.indexOf(nextMusic);
                              scrollController.jumpTo(109 * posMusic.toDouble());
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
                  )
                ],
              );
            },
          )
        )
      )
    );
  }
}