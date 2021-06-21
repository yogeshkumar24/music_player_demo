import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/notifications.dart';
import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import 'package:intl/intl.dart';
import 'package:audio_manager/audio_manager.dart';
import 'album.dart';
import 'background_service/audioPlayerTask.dart';

void _backgroundTaskEntrypoint() {
  AudioServiceBackground.run(() => AudioPlayerTask());
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AudioServiceWidget(child:MyHomePage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int timeProgress = 0;
  int audioDuration = 0;
  List<Track> trackLis = [];

  int songNumber = 0;
  AudioPlayer audioPlayer = AudioPlayer();
  PlayerState playerState = PlayerState.PAUSED;


  // start() =>
  //     AudioService.start(backgroundTaskEntrypoint: _backgroundTaskEntrypoint);
  //
  // stop() => AudioService.stop();

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

  List<Track> fetchSongs() {
    List<Track> trackList = [];
    list.forEach((element) {
      trackList.add(Track.fromJson(element));
    });
    return trackList;
  }

  @override
  void initState() {

    trackLis = fetchSongs();
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        playerState = state;
      });
    });

    audioPlayer.onDurationChanged.listen((Duration duration) {

      setState(() {
        audioDuration = duration.inMilliseconds;
      });
    });

    audioPlayer.setUrl(trackLis[songNumber].track);

    audioPlayer.onAudioPositionChanged.listen((Duration duration) {
      setState(() {
        timeProgress = duration.inMilliseconds;
      });
    });

    super.initState();
  }

  playMusic(String url) async {
    await audioPlayer.play(url);
  }

  pauseMusic() async {
    await audioPlayer.pause();
  }

  Widget slider() {
    return Container(
      child: Slider.adaptive(
        value: (timeProgress / 1000),
        max: (audioDuration / 1000),
        onChanged: (value) {
          seekToSec(value.toInt());
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Music Player"),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListView.builder(
                itemCount: trackLis.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        songNumber = index;
                        audioPlayer.setUrl(trackLis[index].track);
                        playMusic(trackLis[index].track);
                      });
                    },
                    child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("${trackLis[index].name}"),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Divider()
                          ],
                        ),),
                  );
                }),
            buildRow(),
            buildButtons()
          ],
        ),
      ),
    );
  }


   buildButtons()  {
    return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: ()  {
                    setState(() {
                      if(songNumber > 0){
                      audioPlayer.setUrl(trackLis[songNumber--].track);
                    }else{
                        print("This is the first song");
                      }});
                  },
                  icon: Icon(Icons.skip_previous)),
              IconButton(
                  onPressed: () {
                    setState(() {
                      playerState == PlayerState.PLAYING
                          ? pauseMusic()
                          : playMusic(trackLis[songNumber].track);
                    });
                  },
                  icon: Icon(playerState == PlayerState.PAUSED
                      ? Icons.play_arrow
                      : Icons.pause)),

              IconButton(
                  onPressed: ()  {
           setState(() {
             if(songNumber < trackLis.length-1){
                audioPlayer.setUrl(trackLis[songNumber++].track);
                }
           else{
             print("This is last song");
             }});
            },
                  icon: Icon(Icons.skip_next)),
            ],
          );
  }

  Column buildRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(trackLis[songNumber].name),
        Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(getTime(timeProgress)),
                  SizedBox(width: 20),
                  Container(width: 250, child: slider()),
                  SizedBox(width: 20),
                  Text(getTime(audioDuration))
                ],
              ),
      ],
    );
  }

  void seekToSec(int sec) {
    Duration duration = Duration(seconds: sec);

    audioPlayer.seek(duration);
  }

  getTime(millisecond){
   var d = Duration(milliseconds: millisecond);
   return "${d.toString().substring(2,7)}";

  }
}
