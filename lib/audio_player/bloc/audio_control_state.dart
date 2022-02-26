part of 'audio_control_bloc.dart';

class AudioControlState extends Equatable {
  const AudioControlState({
    this.muted = false,
  });

  final bool muted;

  @override
  List<Object> get props => [muted];
}