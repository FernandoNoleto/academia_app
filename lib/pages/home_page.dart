import 'package:flutter/material.dart';

/*Paginas*/
import 'detailed_exercise_page.dart';

/*Providers*/
import 'package:academiaapp/common/providers/card_provider.dart';
import 'package:academiaapp/common/providers/container_provider.dart';

/*Models*/
import 'package:academiaapp/common/models/user.dart';


/*Plugins*/
import 'package:firebase_database/firebase_database.dart';
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

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{

  late AnimationController controller;
  late Object? userObject;
  late Object? exerciseObject;
  late Object? exercisesObject;
  late User user;
  late User userr;
  late String exercise = "Exercicio";
  late String repetitions = "Repetições";
  late bool isDailyExerciseConfigured;
  final _dataBaseRef = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();

    _dataBaseRef.child("Users/${widget.localId}").onValue.listen((event) async {
      userObject = event.snapshot.value;
      user = User.fromJson(jsonDecode(jsonEncode(Map<String, dynamic>.from(userObject as Map<dynamic, dynamic>))));
    });

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addListener(() {
      setState(() {});
    });
    controller.repeat(reverse: true);

  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String _getDayOfWeek(){
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
                              fontSize: 22,
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
                              fontSize: 48,
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
              // AQUI VAI A RECUPERAÇÃO DA LISTA DE EXERCICIOS DO DIA
              // ----------------------------------------------------
              ContainerProvider(
                horizontal: 10,
                vertical: 30,
                child: StreamBuilder(
                  stream: _dataBaseRef.child("Users/${widget.localId}/Exerciciododia/${_getDayOfWeek()}").orderByKey().onValue,
                  builder: (context, snapshot){
                    final tilesList = <Widget>[];
                    if (snapshot.hasData) {
                      print("tem dados");
                      final myExercises = (snapshot.data! as DatabaseEvent).snapshot.value as Map<Object, dynamic>;
                      myExercises.forEach((key, value) {
                        final nextExercise = Map<String, dynamic>.from(value);
                        final exerciseCard = CardProvider(
                          title: Text(nextExercise['name']),
                          subtitle: Text("Repetições:" +nextExercise['repetitions']),
                          logo: const Icon(Icons.account_circle, size: 32),
                          // borderColor: nextExercise['haveConfiguredExercises'] ? const Color.fromARGB(255, 34, 187, 51) : const Color.fromARGB(255, 187, 33, 36),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => DetailedExercisePage(name: nextExercise['name'])),
                            );
                          },
                        );
                        tilesList.add(exerciseCard);
                        tilesList.add(const SizedBox(height: 10,),);
                      });
                      return CircularProgressIndicator(
                        value: controller.value,
                      );
                    }
                    else{
                      print("nao tem dados");
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            CircularProgressIndicator(
                              value: controller.value,
                            ),
                            const Text(
                              "Seu personal não passou exercícios para este dia",
                              style: TextStyle(
                                fontSize: 28,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView(
                      children: tilesList,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}