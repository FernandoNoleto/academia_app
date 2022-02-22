import 'package:academiaapp/common/providers/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

/*Paginas*/
import 'detailed_exercise_page.dart';

/*Providers*/
import 'package:academiaapp/common/providers/card_provider.dart';
import 'package:academiaapp/common/providers/container_provider.dart';


/*Plugins*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:academiaapp/firebase_options.dart';



class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.name, required this.uid}) : super(key: key);

  final String uid;
  final String name;
  // User user;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late String exercise = "Exercicio";
  late String repetitions = "Repetições";
  late bool _dontHaveDailyExercise = false;
  final _dataBaseRef = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    // _getExercise();
    // _getRepetitions();
  }

  void _getExercise(){
    _dataBaseRef.child("${widget.uid}/exercise").onValue.listen((event) {
      final Object? description = event.snapshot.value;
      setState(() {
        exercise = "Exercicio: $description";
      });
    });
  }

  void _getRepetitions(){
    _dataBaseRef.child("${widget.uid}/repetitions").onValue.listen((event) {
      final Object? description = event.snapshot.value;
      setState(() {
        if (description == null || description == ""){
          _dontHaveDailyExercise = true;
        }
        repetitions = "Repetições: $description";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bem vindo de volta ${widget.name}"),
      ),
      body:
      !_dontHaveDailyExercise ?
      ContainerProvider(
        horizontal: 10,
        vertical: 10,
        child: Center(
          child: ListView(
            children: <Widget>[
              CardProvider(
                title: Text(exercise),
                subtitle: Text(repetitions),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return const DetailedExercisePage();
                    }),
                  );

                },
              ),
            ],
          ),
        ),
      )
    :
        const Text("Primeiro login"),
    );
  }
}
