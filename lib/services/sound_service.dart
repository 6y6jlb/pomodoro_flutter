import 'package:audioplayers/audioplayers.dart';

class SoundService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  final Map<String, String> _soundMap = {
    'toggle': 'sounds/toggle.mp3',
    'request': 'sounds/request.mp3',
    'default': 'sounds/default.mp3',
  };

  Future<void> playSound(String soundKey) async {
    final soundPath = _soundMap[soundKey];
    if (soundPath == null) {
      print('Sound not found for key: $soundKey');
      return;
    }

    try {
      await _audioPlayer.play(AssetSource(soundPath));
      print('Playing sound: $soundPath');
    } catch (e) {
      print('Failed to play sound: $e');
    }
  }
}
