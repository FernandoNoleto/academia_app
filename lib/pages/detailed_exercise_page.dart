import 'package:flutter/material.dart';

/*Dependencies*/
import 'package:firebase_database/firebase_database.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:convert';

/*Providers*/
import 'package:academiaapp/common/providers/youtube_player_provider.dart';
import 'package:academiaapp/common/providers/container_provider.dart';

/*Model*/
import 'package:academiaapp/common/models/exercise.dart';


class DetailedExercisePage extends StatefulWidget {
  final String name;
  const DetailedExercisePage({Key? key, required this.name}) : super(key: key);

  @override
  _DetailedExercisePageState createState() => _DetailedExercisePageState();
}

class _DetailedExercisePageState extends State<DetailedExercisePage> {

  final dbRef = FirebaseDatabase.instance.ref();
  late Object? exerciseObject;
  late Exercise exercise;
  String link = "";

  @override
  void initState(){
    super.initState();
    dbRef.child("Exercises/${widget.name}").onValue.listen((event) {
      exerciseObject = event.snapshot.value;
      exercise = Exercise.fromJson(jsonDecode(jsonEncode(Map<String, dynamic>.from(exerciseObject as Map<dynamic, dynamic>))));
      var arr = exercise.linkYouTube.split("=");
      link = arr[1]; // dividir o link do YT onde tem o '=' e pegar somente a segunda parte
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Exercício'),
      ),
      body: ContainerProvider(
        horizontal: 10,
        vertical: 10,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget> [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(widget.name,
                  style: const TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              YoutubePlayer(
                controller: YoutubeProvider().youtubePlayerController(link),
                liveUIColor: Colors.amber,
              ),
              const SizedBox(height: 5,),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Vídeo explicativo do exercício:",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}