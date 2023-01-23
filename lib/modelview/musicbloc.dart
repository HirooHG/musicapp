
import 'package:bloc/bloc.dart';

abstract class MusicEvent {
  const MusicEvent();
}

abstract class MusicState {
  MusicState();
}

class InitMusicState extends MusicState {
  InitMusicState();
}

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  MusicBloc() : super(InitMusicState()) {
    on<MusicEvent>(onMusicEvent);
  }

  onMusicEvent(event, emit) {
    switch(event.runtimeType) {

    }
  }
}
