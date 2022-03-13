import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'audio_control_event.dart';
part 'audio_control_state.dart';

class AudioControlBloc extends Bloc<AudioControlEvent, AudioControlState> {
  AudioControlBloc() : super(const AudioControlState()) {
    on<AudioToggled>(_onAudioToggled);
  }

  void _onAudioToggled(AudioToggled event, Emitter<AudioControlState> emit) {
    debugPrint("Muted ${!state.muted}");
    emit(AudioControlState(muted: !state.muted));
  }
}
