import 'package:flutter/material.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeProvider{

  YoutubePlayerController youtubePlayerController(String urlVideo){
    late YoutubePlayerController controller;
    try{
      controller = YoutubePlayerController(
        initialVideoId: urlVideo,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
      return controller;
    }
    catch(error){
      return controller;
      print(error);
    }
  }
}