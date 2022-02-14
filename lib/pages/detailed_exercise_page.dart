import 'package:flutter/material.dart';

/*Dependencies*/
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'firebase_options.dart';

/*Providers*/
import 'package:academia_app/common/providers/youtube_player_provider.dart';
import 'package:academia_app/common/providers/card_provider.dart';
import 'package:academia_app/common/providers/container_provider.dart';




class DetailedExercisePage extends StatefulWidget {
  const DetailedExercisePage({Key? key}) : super(key: key);

  @override
  _DetailedExercisePageState createState() => _DetailedExercisePageState();
}

class _DetailedExercisePageState extends State<DetailedExercisePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nome do exercicio'),
      ),
      body: SingleChildScrollView(
          child: ContainerProvider(
            horizontal: 10,
            vertical: 30,
            child: Column(
              children: <Widget>[
                const CardProvider(
                    title: Text("Nome exercicio"),
                    subtitle: Text("Repetições")
                ),
                const SizedBox(height: 10),
                YoutubePlayer(
                  controller: YoutubeProvider().youtubePlayerController('hwf01VTWMCo'),
                  liveUIColor: Colors.amber,
                ),
              ],
            ),
          )
      ),
    );
  }
}


// Container(
// height: MediaQuery.of(context).size.height,
// padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
// decoration: const BoxDecoration(
// gradient: LinearGradient(
// begin: Alignment.topCenter,
// end: Alignment.bottomCenter,
// colors: [
// Colors.white,
// Colors.white70,
// ],
// ),
// ),
// child: Column(
// children: <Widget>[
// const CardProvider(
// title: Text("Nome exercicio"),
// subtitle: Text("Repetições")
// ),
// const SizedBox(height: 10),
// YoutubePlayer(
// controller: YoutubeProvider().youtubePlayerController('hwf01VTWMCo'),
// liveUIColor: Colors.amber,
// ),
// ],
// ),
// ),