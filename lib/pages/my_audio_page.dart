import 'package:crime_junkies_podcast/widgets/player_buttons.dart';
import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';
import 'package:media_player/data_sources.dart';
import 'package:media_player/media_player.dart';
import 'package:media_player/ui.dart';

class MyAudioPage extends StatefulWidget {
  final Playlist playlist;
  final MediaFile source;
  final int index;

  MyAudioPage({this.playlist, this.source, this.index});

  @override
  _MyAudioPageState createState() => _MyAudioPageState();
}

class _MyAudioPageState extends State<MyAudioPage> {
  MediaPlayer player;
  MediaFile currentSource;
  int currentIndex;

  void initPlayer() async {
    await player.initialize();

    player.valueNotifier.addListener(() {
      this.currentIndex = player.valueNotifier.value.currentIndex;
      this.currentSource = player.valueNotifier.value.source;
      setState(() {});
    });

    if(widget.source != null) {
      await player.setSource(widget.source);
    }
    if(widget.playlist != null ) {
      await player.setPlaylist(widget.playlist);
    }
    player.play();
  }

  @override
  void initState() {
    player = MediaPlayerPlugin.create(
      isBackground: false,
      showNotification: false,
    );

    initPlayer();
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.source.title),
      ),
      body: Column(
        children: [
          VideoPlayerView(player),
          VideoProgressIndicator(
            player,
            allowScrubbing: true,
            padding: const EdgeInsets.symmetric(
              vertical: 5.0,
            ),
          ),
          SizedBox(height: 20.0,),
          PlayerButtons(player),
        ],
      ),
    );
  }
}
