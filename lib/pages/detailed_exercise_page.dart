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
  late String? link = "";
  late YoutubePlayerController _controller;


  @override
  void initState(){
    super.initState();
    _getExercise();
  }

  void _getExercise()async{
    DatabaseEvent event = await FirebaseDatabase.instance.ref("/Exercises/${widget.name}").once();
    setState(() {
      exercise = Exercise.fromJson(jsonDecode(jsonEncode(Map<String, dynamic>.from(event.snapshot.value as Map<dynamic, dynamic>))));
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
        vertical:10,
        horizontal: 10,
        child: link! != "" ?
        YouTubePlayerProvider(urlVideo: link!)
            :
        const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}