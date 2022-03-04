import 'dart:convert';

import 'package:academiaapp/common/providers/card_provider.dart';
import 'package:academiaapp/common/providers/container_provider.dart';
import 'package:academiaapp/common/providers/firebase_storage.dart';
import 'package:academiaapp/common/providers/set_exercise_form_provider.dart';
import 'package:flutter/material.dart';

/*Models*/
import 'package:academiaapp/common/models/exercise.dart';
import 'package:academiaapp/common/models/user.dart';


/*Plugins*/
import 'package:firebase_database/firebase_database.dart';



class SetDailyExercisesPage extends StatefulWidget {
  const SetDailyExercisesPage({Key? key, required this.localId}) : super(key: key);
  final String localId;


  @override
  _SetDailyExercisesPageState createState() => _SetDailyExercisesPageState();
}

class _SetDailyExercisesPageState extends State<SetDailyExercisesPage> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _intervalInputController = TextEditingController();
  final TextEditingController _repetitionsInputController = TextEditingController();
  final TextEditingController _seriesInputController = TextEditingController();

  final dbRef = FirebaseDatabase.instance.ref();
  late Object? userObject;
  late Object? exerciseObject;
  late User user;
  late Exercise exercise;
  List<String> listOfExercises = [];
  String dropdownValue = '';
  String day = "";


  @override
  void initState(){
    super.initState();
    _getUser(widget.localId);
    listOfExercises = FirebaseStorageProvider().getExercises();
    // aqui está o erro
    if (listOfExercises.isNotEmpty){
      dropdownValue = listOfExercises.first;
    }
    else{
      dropdownValue = " ";
    }
  }

  void _getUser(String id) {
    dbRef.child("Users/$id").onValue.listen((event) {
      userObject = event.snapshot.value;
      // print(userObject);
      user = User.fromJson(jsonDecode(jsonEncode(Map<String, dynamic>.from(userObject as Map<dynamic, dynamic>))));
    });

  }

  void _writeExerciseForUser(Exercise exercise, day) async {
    final userRef = dbRef.child('/Users/${widget.localId}/Exerciciododia/$day/${exercise.name}');
    try{
      await userRef.update(exercise.toJson());
      print("Exercicio cadastrado no bd do usuário!");
    } catch (error){
      print("Deu o seguinte erro: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aluno ${user.displayName}"),
      ),
      body: ContainerProvider(
        vertical: 10,
        horizontal: 10,
        child: ListView(
          children: <Widget> [
            CardProvider(
              title: const Text("Segunda Feira"),
              subtitle: const Text("Não configurado"),
              onTap: (){
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context){
                    return Container(
                      height: MediaQuery.of(context).size.height/2,
                      color: Colors.black12,
                      child: Center(
                        child: ContainerProvider(
                          horizontal: 10,
                          vertical: 10,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              StatefulBuilder(
                                builder: (BuildContext context, void Function(void Function()) setState) {
                                  return DropdownButton<String>(
                                    value: dropdownValue,
                                    icon: const Icon(Icons.arrow_downward),
                                    elevation: 16,
                                    style: const TextStyle(color: Colors.deepPurple),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownValue = newValue!;
                                        print(newValue);
                                      });
                                    },
                                    items: listOfExercises.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                              const SizedBox(height: 10,),
                              SetExerciseForm(
                                formKey: _formKey,
                                intervalInputController: _intervalInputController,
                                repetitionsInputController: _repetitionsInputController,
                                seriesInputController: _seriesInputController,
                              ),
                              const SizedBox(height: 10,),
                              ElevatedButton(
                                child: const Text('Ok'),
                                onPressed: () {
                                  // print(_intervalInputController.text);
                                  Exercise exercise = Exercise(
                                    name: dropdownValue,
                                    interval: _intervalInputController.text,
                                    series: _seriesInputController.text,
                                    repetitions: _repetitionsInputController.text,
                                    day: "Segunda-Feira",
                                  );
                                  day = "Segunda-Feira";
                                  print(exercise.toString());
                                  _writeExerciseForUser(exercise, day);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 10,),
            CardProvider(
              title: const Text("Terça Feira"),
              subtitle: const Text("Não configurado"),
              onTap: (){
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context){
                    return Container(
                      height: MediaQuery.of(context).size.height/2,
                      color: Colors.black12,
                      child: Center(
                        child: ContainerProvider(
                          horizontal: 10,
                          vertical: 10,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              StatefulBuilder(
                                builder: (BuildContext context, void Function(void Function()) setState) {
                                  return DropdownButton<String>(
                                    value: dropdownValue,
                                    icon: const Icon(Icons.arrow_downward),
                                    elevation: 16,
                                    style: const TextStyle(color: Colors.deepPurple),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownValue = newValue!;
                                        print(newValue);
                                      });
                                    },
                                    items: listOfExercises.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                              const SizedBox(height: 10,),
                              SetExerciseForm(
                                formKey: _formKey,
                                intervalInputController: _intervalInputController,
                                repetitionsInputController: _repetitionsInputController,
                                seriesInputController: _seriesInputController,
                              ),
                              const SizedBox(height: 10,),
                              ElevatedButton(
                                child: const Text('Ok'),
                                onPressed: () {
                                  // print(_intervalInputController.text);
                                  Exercise exercise = Exercise(
                                    name: dropdownValue,
                                    interval: _intervalInputController.text,
                                    series: _seriesInputController.text,
                                    repetitions: _repetitionsInputController.text,
                                    day: "Terça-Feira",
                                  );
                                  day = "Terça-Feira";
                                  print(exercise.toString());
                                  _writeExerciseForUser(exercise, day);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 10,),
            CardProvider(
              title: Text("Quarta Feira"),
              subtitle: Text("Não configurado"),
              onTap: (){
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context){
                    return Container(
                      height: MediaQuery.of(context).size.height/2,
                      color: Colors.black12,
                      child: Center(
                        child: ContainerProvider(
                          horizontal: 10,
                          vertical: 10,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              StatefulBuilder(
                                builder: (BuildContext context, void Function(void Function()) setState) {
                                  return DropdownButton<String>(
                                    value: dropdownValue,
                                    icon: const Icon(Icons.arrow_downward),
                                    elevation: 16,
                                    style: const TextStyle(color: Colors.deepPurple),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownValue = newValue!;
                                        print(newValue);
                                      });
                                    },
                                    items: listOfExercises.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                              const SizedBox(height: 10,),
                              SetExerciseForm(
                                formKey: _formKey,
                                intervalInputController: _intervalInputController,
                                repetitionsInputController: _repetitionsInputController,
                                seriesInputController: _seriesInputController,
                              ),
                              const SizedBox(height: 10,),
                              ElevatedButton(
                                child: const Text('Ok'),
                                onPressed: () {
                                  // print(_intervalInputController.text);
                                  Exercise exercise = Exercise(
                                    name: dropdownValue,
                                    interval: _intervalInputController.text,
                                    series: _seriesInputController.text,
                                    repetitions: _repetitionsInputController.text,
                                    day: "Quarta-Feira",
                                  );
                                  day = "Quarta-Feira";
                                  print(exercise.toString());
                                  _writeExerciseForUser(exercise, day);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 10,),
            CardProvider(
              title: const Text("Quinta Feira"),
              subtitle: Text("Não configurado"),
              onTap: (){
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context){
                    return Container(
                      height: MediaQuery.of(context).size.height/2,
                      color: Colors.black12,
                      child: Center(
                        child: ContainerProvider(
                          horizontal: 10,
                          vertical: 10,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              StatefulBuilder(
                                builder: (BuildContext context, void Function(void Function()) setState) {
                                  return DropdownButton<String>(
                                    value: dropdownValue,
                                    icon: const Icon(Icons.arrow_downward),
                                    elevation: 16,
                                    style: const TextStyle(color: Colors.deepPurple),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownValue = newValue!;
                                        print(newValue);
                                      });
                                    },
                                    items: listOfExercises.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                              const SizedBox(height: 10,),
                              SetExerciseForm(
                                formKey: _formKey,
                                intervalInputController: _intervalInputController,
                                repetitionsInputController: _repetitionsInputController,
                                seriesInputController: _seriesInputController,
                              ),
                              const SizedBox(height: 10,),
                              ElevatedButton(
                                child: const Text('Ok'),
                                onPressed: () {
                                  // print(_intervalInputController.text);
                                  Exercise exercise = Exercise(
                                    name: dropdownValue,
                                    interval: _intervalInputController.text,
                                    series: _seriesInputController.text,
                                    repetitions: _repetitionsInputController.text,
                                    day: "Quinta-Feira",
                                  );
                                  day = "Quinta-Feira";
                                  print(exercise.toString());
                                  _writeExerciseForUser(exercise, day);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 10,),
            CardProvider(
              title: const Text("Sexta Feira"),
              subtitle: Text("Não configurado"),
              onTap: (){
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context){
                    return Container(
                      height: MediaQuery.of(context).size.height/2,
                      color: Colors.black12,
                      child: Center(
                        child: ContainerProvider(
                          horizontal: 10,
                          vertical: 10,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              StatefulBuilder(
                                builder: (BuildContext context, void Function(void Function()) setState) {
                                  return DropdownButton<String>(
                                    value: dropdownValue,
                                    icon: const Icon(Icons.arrow_downward),
                                    elevation: 16,
                                    style: const TextStyle(color: Colors.deepPurple),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownValue = newValue!;
                                        print(newValue);
                                      });
                                    },
                                    items: listOfExercises.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                              const SizedBox(height: 10,),
                              SetExerciseForm(
                                formKey: _formKey,
                                intervalInputController: _intervalInputController,
                                repetitionsInputController: _repetitionsInputController,
                                seriesInputController: _seriesInputController,
                              ),
                              const SizedBox(height: 10,),
                              ElevatedButton(
                                child: const Text('Ok'),
                                onPressed: () {
                                  // print(_intervalInputController.text);
                                  Exercise exercise = Exercise(
                                    name: dropdownValue,
                                    interval: _intervalInputController.text,
                                    series: _seriesInputController.text,
                                    repetitions: _repetitionsInputController.text,
                                    day: "Sexta-Feira",
                                  );
                                  day = "Sexta-Feira";
                                  print(exercise.toString());
                                  _writeExerciseForUser(exercise, day);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 10,),
            CardProvider(
              title: const Text("Sábado"),
              subtitle: Text("Não configurado"),
              onTap: (){
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context){
                    return Container(
                      height: MediaQuery.of(context).size.height/2,
                      color: Colors.black12,
                      child: Center(
                        child: ContainerProvider(
                          horizontal: 10,
                          vertical: 10,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              StatefulBuilder(
                                builder: (BuildContext context, void Function(void Function()) setState) {
                                  return DropdownButton<String>(
                                    value: dropdownValue,
                                    icon: const Icon(Icons.arrow_downward),
                                    elevation: 16,
                                    style: const TextStyle(color: Colors.deepPurple),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownValue = newValue!;
                                        print(newValue);
                                      });
                                    },
                                    items: listOfExercises.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                              const SizedBox(height: 10,),
                              SetExerciseForm(
                                formKey: _formKey,
                                intervalInputController: _intervalInputController,
                                repetitionsInputController: _repetitionsInputController,
                                seriesInputController: _seriesInputController,
                              ),
                              const SizedBox(height: 10,),
                              ElevatedButton(
                                child: const Text('Ok'),
                                onPressed: () {
                                  // print(_intervalInputController.text);
                                  Exercise exercise = Exercise(
                                    name: dropdownValue,
                                    interval: _intervalInputController.text,
                                    series: _seriesInputController.text,
                                    repetitions: _repetitionsInputController.text,
                                    day: "Sábado",
                                  );
                                  day = "Sábado";
                                  print(exercise.toString());
                                  _writeExerciseForUser(exercise, day);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 10,),
            CardProvider(
              title: const Text("Domingo"),
              subtitle: Text("Não configurado"),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context){
                    return Container(
                      height: MediaQuery.of(context).size.height/2,
                      color: Colors.black12,
                      child: Center(
                        child: ContainerProvider(
                          horizontal: 10,
                          vertical: 10,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              StatefulBuilder(
                                builder: (BuildContext context, void Function(void Function()) setState) {
                                  return DropdownButton<String>(
                                    value: dropdownValue,
                                    icon: const Icon(Icons.arrow_downward),
                                    elevation: 16,
                                    style: const TextStyle(color: Colors.deepPurple),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownValue = newValue!;
                                        print(newValue);
                                      });
                                    },
                                    items: listOfExercises.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                              const SizedBox(height: 10,),
                              SetExerciseForm(
                                formKey: _formKey,
                                intervalInputController: _intervalInputController,
                                repetitionsInputController: _repetitionsInputController,
                                seriesInputController: _seriesInputController,
                              ),
                              const SizedBox(height: 10,),
                              ElevatedButton(
                                child: const Text('Ok'),
                                onPressed: () {
                                  // print(_intervalInputController.text);
                                  Exercise exercise = Exercise(
                                    name: dropdownValue,
                                    interval: _intervalInputController.text,
                                    series: _seriesInputController.text,
                                    repetitions: _repetitionsInputController.text,
                                    day: "Domingo",
                                  );
                                  day = "Domingo";
                                  print(exercise.toString());
                                  _writeExerciseForUser(exercise, day);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
