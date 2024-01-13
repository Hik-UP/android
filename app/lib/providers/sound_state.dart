import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class SoundState extends ChangeNotifier {
  final AudioPlayer audioPlayer = AudioPlayer();

  playAudio({required String soundSource}) {
    audioPlayer.play(AssetSource(soundSource));
  }

  setVolume({required double volume}) async {
    await audioPlayer.setVolume(volume);
  }

  AudioPlayer instance() {
    return audioPlayer;
  }
}
