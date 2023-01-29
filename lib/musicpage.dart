
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'view/homeview.dart';
import 'modelview/musicbloc.dart';
import 'modelview/cubits.dart';

class MusicPage extends StatelessWidget {
  const MusicPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MusicBloc>(
          create: (_) => MusicBloc()
        ),
        BlocProvider<PauseCubit>(
          create: (_) => PauseCubit()
        ),
      ],
      child: HomeView(),
    );
  }
}
