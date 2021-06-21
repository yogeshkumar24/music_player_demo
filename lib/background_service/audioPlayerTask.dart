import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerTask extends BackgroundAudioTask {
  final _audioPlayer = AudioPlayer();


  @override
  Future<void> onStart(Map<String, dynamic> params) async {
    // Connect to the URL
    print("test");
String url ='https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3';

    await _audioPlayer.setUrl('https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3');
    // Now we're ready to play
    _audioPlayer.play(url);
  }

  @override
  Future<void> onStop() async {
    // Stop playing audio
    await _audioPlayer.stop();
    // Shut down this background task
    await super.onStop();
  }



  List<Map<String, String>> list = [
    {
      'track': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      "name": "First Song"
    },
    {
      'track': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
      "name": "Sixth Song"
    },
    {
      'track': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
      "name": "Second Song"
    },
    {
      'track': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
      "name": "Third Song"
    },
    {
      'track': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3',
      "name": "Fourth Song"
    },
    {
      'track': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3',
      "name": "Fifth Song"
    },

  ];
}