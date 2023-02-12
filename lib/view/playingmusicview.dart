
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../modelview/cubits.dart';
import '../modelview/musicbloc.dart';
import 'musicview.dart';

class PlayingMusicView extends StatelessWidget {
  PlayingMusicView({super.key});

  late double width;
  late double height;

  @override
  Widget build(BuildContext context) {

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1a1a1a),
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
          color: const Color(0xff2a2a2b),
          padding: const EdgeInsets.all(20),
          width: width,
          height: height,
          child: BlocBuilder<MusicBloc, MusicState>(
            builder: (context, musicState) {
              return Column(
                children: [
                  GestureDetector(
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
                            child: MusicView(music: musicState.currentMusic)
                          )
                        )
                      );
                    },
                    child: Center(
                      child: Hero(
                        tag: "musicphoto",
                        child: Container(
                          width: width * 0.85,
                          height: height * 0.5,
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(40)
                          ),
                          child: const Center(
                            child: Text(
                              "Photo",
                              style: TextStyle(
                                color: Colors.white
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30, bottom: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          musicState.currentMusic.name,
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: "Ubuntu",
                            fontWeight: FontWeight.bold,
                            fontSize: 25
                          ),
                        ),
                        Text(
                          musicState.currentMusic.artist.name,
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: "Ubuntu",
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  StreamBuilder(
                    stream: musicState.assetAudio.currentPosition,
                    builder: (context, snapshot) {
                      double percent = 0;
                      Duration duration = const Duration();
                      Duration pos = const Duration();
                      String minPos = "";
                      String secPos = "";

                      String minDur = "";
                      String secDur = "";

                      try {
                        duration = musicState.assetAudio.current.value!.audio.duration;
                        pos = snapshot.data!;
                        percent = pos.inSeconds / duration.inSeconds;

                        if(pos.inSeconds % 60 >= 10) { secPos = "${pos.inSeconds % 60}"; }
                        else { secPos = "0${pos.inSeconds % 60}"; }

                        if(duration.inSeconds % 60 >= 10) { secDur = "${duration.inSeconds % 60}"; }
                        else { secDur = "0${duration.inSeconds % 60}"; }

                        if(duration.inMinutes >= 10) { minDur = "${duration.inMinutes}"; }
                        else { minDur = "0${duration.inMinutes}"; }

                        if(pos.inMinutes >= 10) { minPos = "${pos.inMinutes}"; }
                        else { minPos = "0${pos.inMinutes}"; }

                      } catch(e) {/**/}

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LinearPercentIndicator(
                            width: width * 0.6,
                            percent: percent,
                            curve: Curves.bounceIn,
                            barRadius: const Radius.circular(8),
                            lineHeight: 14,
                            backgroundColor: Colors.black,
                            progressColor: Colors.white,
                            leading: Text(
                              "$minPos:$secPos",
                              style: const TextStyle(
                                  fontFamily: "Ubuntu",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              ),
                            ),
                            trailing: Text(
                              "$minDur:$secDur",
                              style: const TextStyle(
                                  fontFamily: "Ubuntu",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () async {
                            BlocProvider.of<PauseCubit>(context).change(true);
                            BlocProvider.of<MusicBloc>(context).add(const PreviousMusicEvent());
                          },
                          child: const Icon(Icons.skip_previous, color: Colors.white, size: 40),
                        ),
                        TextButton(
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
                          child: BlocBuilder<PauseCubit, bool>(
                            builder: (context, isPaused) {
                              return Icon(
                                (!isPaused)
                                  ? Icons.play_circle
                                  : Icons.pause_circle,
                                color: Colors.white,
                                size: 60
                              );
                            },
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            BlocProvider.of<PauseCubit>(context).change(true);
                            BlocProvider.of<MusicBloc>(context).add(const NextMusicEvent());
                          },
                          child: const Icon(Icons.skip_next, color: Colors.white, size: 40),
                        )
                      ],
                    ),
                  )
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}