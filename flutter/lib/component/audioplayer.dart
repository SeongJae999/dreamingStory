import 'package:audioplayers/audioplayers.dart';

final AudioPlayer backgroundMusicPlayer = AudioPlayer();
final AudioPlayer btnSoundPlayer = AudioPlayer();

void playBackgroundMusic() async {
  await backgroundMusicPlayer
      .setSource(AssetSource('audios/dreaming_story.wav'));
  backgroundMusicPlayer.setVolume(0.5);
  backgroundMusicPlayer.setReleaseMode(ReleaseMode.loop);
  backgroundMusicPlayer.resume();
}

Future<void> playbtnSoundMusic() async {
  await btnSoundPlayer.setSource(AssetSource('audios/btn_sound.mp3'));
  btnSoundPlayer.setVolume(0.8);
  btnSoundPlayer.setReleaseMode(ReleaseMode.stop);
  btnSoundPlayer.resume();
}
