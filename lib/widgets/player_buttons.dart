import 'package:flutter/material.dart';
import 'package:media_player/media_player.dart';

class PlayerButtons extends StatefulWidget {
  final MediaPlayer player;

  PlayerButtons(this.player);

  @override
  _PlayerButtonsState createState() => _PlayerButtonsState();
}

class _PlayerButtonsState extends State<PlayerButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FlatButton.icon(
            onPressed: () {
              widget.player.rewind(10);
            },
            icon: Icon(Icons.fast_rewind),
            label: Text('Rewind')
        ),
        FlatButton.icon(
            onPressed: () {
              widget.player.play();
            },
            icon: Icon(Icons.play_arrow),
            label: Text('Play')
        ),
        FlatButton.icon(
            onPressed: () {
              widget.player.pause();
            },
            icon: Icon(Icons.pause),
            label: Text('Pause')
        ),
        FlatButton.icon(
            onPressed: () {
              widget.player.fastForward(10);
            },
            icon: Icon(Icons.fast_forward),
            label: Text('Forward')
        )
      ],
    );
  }
}
