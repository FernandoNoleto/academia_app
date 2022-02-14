import 'package:flutter/material.dart';

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
        title: Text("Exercicio detalhado"),
      ),
      body: const Text("Exercicio detalhado"),
    );
  }
}
