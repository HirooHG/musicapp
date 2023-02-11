
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicapp/view/homeview.dart';
import 'modelview/cubits.dart';
import 'modelview/musicbloc.dart';

class MusicApp extends MaterialApp {
  MusicApp({super.key}) : super(
    home: MultiBlocProvider(
      providers: [
        BlocProvider<MusicBloc>(
            create: (_) => MusicBloc()
        ),
        BlocProvider<PauseCubit>(
            create: (_) => PauseCubit()
        ),
        BlocProvider<SearchValue>(
          create: (_) => SearchValue(),
        )
      ],
      child: HomeView(),
    ),
    debugShowCheckedModeBanner: false
  );
}
