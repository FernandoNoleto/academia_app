import 'package:flutter/material.dart';

/*Paginas*/
import 'detailed_exercise_page.dart';

/*Providers*/
import 'package:academiaapp/common/providers/firebase_storage.dart';
import 'package:academiaapp/common/providers/card_provider.dart';
import 'package:academiaapp/common/providers/container_provider.dart';

/*Models*/
import 'package:academiaapp/common/models/user.dart';


/*Plugins*/
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:academiaapp/firebase_options.dart';
import 'package:intl/intl.dart';
import 'dart:convert';




class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.name, required this.localId}) : super(key: key);

  final String localId;
  final String name;
  // User user;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late Object? userObject;
  late User user;
  late String exercise = "Exercicio";
  late String repetitions = "Repetições";
  late bool _haveDailyExercise = false;
  final _dataBaseRef = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();

    _dataBaseRef.child("Users/${widget.localId}").onValue.listen((event) {
      userObject = event.snapshot.value;
      // print("entrou no get user");
      // print(userObject);

      user = User.fromJson(jsonDecode(jsonEncode(Map<String, dynamic>.from(userObject as Map<dynamic, dynamic>))));
      print(user.toString());
    });


    print(_getHaveDailyExercise());
    // _getExercise();
    // _getRepetitions();
  }

  String _getDayOfWeek(){
    String dayOfWeek = "";
    DateTime date = DateTime.now();
    switch (DateFormat('EEEE').format(date)){
      case "Monday": return "Segunda-Feira"; break;
      case "Tuesday": return "Terça-Feira"; break;
      case "Wednesday": return "Quarta-Feira"; break;
      case "Thursday": return "Quinta-Feira"; break;
      case "Friday": return "Sexta-Feira"; break;
      case "Saturday": return "Sábado"; break;
      case "Sunday": return "Domingo"; break;
      default: return "Não foi possível obter qual dia é hoje"; break;
    }
  }

  // void _getUser(String id) {
  //   _dataBaseRef.child("Users/$id").onValue.listen((event) {
  //     userObject = event.snapshot.value;
  //     print("entrou no get user");
  //     print(userObject);
  //
  //     // Map<String, dynamic> json = Map<String, dynamic>.from(userObject as Map<dynamic, dynamic>);
  //     // print(jsonEncode(json));
  //     user = User.fromJson(jsonDecode(jsonEncode(Map<String, dynamic>.from(userObject as Map<dynamic, dynamic>))));
  //     print(user.toString());
  //   });
  //
  // }

  bool _getHaveDailyExercise(){
    print("${user.haveConfiguredExercises}");
    return user.haveConfiguredExercises ?? false;
  }

  void _getExercise() async {
    // _dataBaseRef.child("${widget.localId}/exercise").onValue.listen((event) {
    //   final Object? description = event.snapshot.value;
    //   setState(() {
    //     exercise = "Exercicio: $description";
    //   });
    // });
    final userRef = _dataBaseRef.child('/Users/${widget.localId}/Exerciciododia/${_getDayOfWeek()}');
    try{
      // await userRef.update(exercise.toJson());
      print("Exercicio cadastrado no bd do usuário!");
    } catch (error){
      print("Deu o seguinte erro: $error");
    }
  }

  void _getRepetitions(){
    _dataBaseRef.child("${widget.localId}/repetitions").onValue.listen((event) {
      final Object? description = event.snapshot.value;
      setState(() {
        if (description == null || description == ""){
          _haveDailyExercise = false;
        }
        repetitions = "Repetições: $description";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Bem vindo de volta ${widget.name}",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: ContainerProvider(
        vertical: 10,
        horizontal: 10,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                height: 210,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/exercise-icon.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 50,),
                    Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent.withOpacity(0.5),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: const Text("Exercício de",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                            strutStyle: StrutStyle(
                              fontSize: 16.0,
                              height: 1.8,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent.withOpacity(0.5),
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Text(_getDayOfWeek(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                            ),
                            strutStyle: const StrutStyle(
                              fontSize: 16.0,
                              height: 1.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                ),
              ),
              true ?
              ContainerProvider(
                horizontal: 10,
                vertical: 30,
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
              )
                  :
              const Text("Primeiro login"),
            ],
          ),
        ),
      ),
    );
  }
}