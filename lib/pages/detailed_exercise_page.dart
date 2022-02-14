import 'package:flutter/material.dart';

/*dependencies*/
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'firebase_options.dart';






class DetailedExercisePage extends StatefulWidget {
  const DetailedExercisePage({Key? key}) : super(key: key);

  @override
  _DetailedExercisePageState createState() => _DetailedExercisePageState();
}

class _DetailedExercisePageState extends State<DetailedExercisePage> {
  //@override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     floatingActionButton: null,
  //     body: StreamBuilder(
  //         stream: Firestore.instance.collection('Videos').snapshots(),
  //         builder:
  //             (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //           if (!snapshot.hasData) {
  //             return const Center(
  //               child: CircularProgressIndicator(),
  //             );
  //           }
  //
  //           return ListView(
  //             children: snapshot.data.documents.map((document) {
  //               var url = document['url'];
  //
  //               YoutubePlayerController _controller = YoutubePlayerController(
  //                 initialVideoId: YoutubePlayer.convertUrlToId(url)!,
  //                 flags: const YoutubePlayerFlags(
  //                   autoPlay: false,
  //                   mute: false,
  //                   disableDragSeek: false,
  //                   loop: false,
  //                   isLive: false,
  //                   forceHD: false,
  //                 ),
  //               );
  //
  //               return Center(
  //                 child: SizedBox(
  //                   width: MediaQuery.of(context).size.width / 1.2,
  //                   child: Column(
  //                     children: <Widget>[
  //                       Padding(
  //                         padding: const EdgeInsets.only(top: 20, bottom: 5,),
  //                         child: Text(document['title']),
  //                       ),
  //                       YoutubePlayer(
  //                         controller: _controller,
  //                         liveUIColor: Colors.amber,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               );
  //             }).toList(),
  //           );
  //         }),
  //   );
  // }

  static String myVideoId = 'hwf01VTWMCo';

  // Initiate the Youtube player controller
  final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: myVideoId,
    flags: const YoutubePlayerFlags(
      autoPlay: true,
      mute: false,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter and Youtube'),
        ),
        body: YoutubePlayer(
          controller: _controller,
          liveUIColor: Colors.amber,
        )
    );
  }
}
