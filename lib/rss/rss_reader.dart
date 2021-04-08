import 'package:crime_junkies_podcast/pages/my_audio_page.dart';
import 'package:flutter/material.dart';
import 'package:media_player/data_sources.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class RSSReader extends StatefulWidget {
  final String title = '<Crime Junkies>';
  RSSReader() : super();

  @override
  _RSSReaderState createState() => _RSSReaderState();
}

class _RSSReaderState extends State<RSSReader> {
  static const String FEED_URL = 'https://feeds.megaphone.fm/ADL9840290619';
  static const String messageLoading = 'Loading feed...';
  static const String messageErrorLoading = 'Error loading feed...';
  static const String messageErrorOpening = 'Error opening feed...';

  RssFeed _feed;
  String _message;
  Playlist playlist;

  DateFormat _format = DateFormat('yyyy-MM-dd – HH:mm:ss');

  void _updateFeed(RssFeed feed) {
    setState(() {
      _feed = feed;
    });
  }

  void _updateMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  Future<void> openFeed(String url) async{
    if(await canLaunch(url) == true) {
      await launch(url);
      //return;
    }
    _updateMessage(messageErrorOpening);
    return;
  }

  Future<void> loadData() async {
    _updateMessage(messageLoading);
    RssFeed result = await _loadFeed();
    if(result == null || result.toString().isEmpty) {
      _updateMessage(messageErrorLoading);
      return;
    }
    _updateMessage(widget.title);
    _updateFeed(result);
  }

  Future<RssFeed> _loadFeed() async {
    try {
      final client = http.Client();
      final response = await client.get(FEED_URL);
      return RssFeed.parse(response.body);
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  List<MediaFile> initPlaylist(RssFeed feed) {
    if(feed == null || feed.items == null) {
      return null;
    }
    return feed.items.map((item) => MediaFile(
      title: item.title,
      type: item.enclosure.type,
      source: item.enclosure.url,
      desc: item.description,
      image: feed.image.url,
    )).toList();
  }

  MediaFile getSource(RssItem item) => MediaFile(
    title: item.title,
    type: item.enclosure.type,
    source: item.enclosure.url,
    desc: item.description,
    image: _feed.image.url,
  );

  @override
  void initState() {
    super.initState();
    loadData().then((_) {
      playlist = initPlaylist(_feed) as Playlist;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: (_feed == null || _feed.items == null)
        ? Center(child: Text(_message),)
        : SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()
          ),
          child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              child: Image.network(
                _feed.image.url,
                fit: BoxFit.cover,
              ),
            ),
            Text(_feed.image.title),
            FlatButton(
              onPressed: () => openFeed(_feed.link),
              child: Text('Open in Browser >')
            ),
            ListView.builder(
              itemCount: _feed.items.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext ctx, int index) {
                List<RssItem> items = _feed.items.toList();
                RssItem item = items[index];
                return ListTile(
                  trailing: Icon(Icons.play_arrow),
                  title: Text(item.title),
                  subtitle: Text(_format.format(item.pubDate)),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext ctx) => MyAudioPage(
                          playlist: playlist,
                          source: getSource(item),
                          index: index
                      )
                    ));
                  },
                );
              }
            ),
          ],
      ),
        ),
    );
  }
}
