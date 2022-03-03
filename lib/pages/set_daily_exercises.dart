import 'dart:convert';

import 'package:academiaapp/common/providers/card_provider.dart';
import 'package:academiaapp/common/providers/container_provider.dart';
import 'package:academiaapp/common/providers/firebase_storage.dart';
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


  @override
  void initState(){
    super.initState();
    _getUser(widget.localId);
    listOfExercises = FirebaseStorageProvider().getExercises();
    dropdownValue = listOfExercises.first;
  }

  void _getUser(String id) {
    dbRef.child("Users/$id").onValue.listen((event) {
      userObject = event.snapshot.value;
      // print(userObject);
      user = User.fromJson(jsonDecode(jsonEncode(Map<String, dynamic>.from(userObject as Map<dynamic, dynamic>))));
    });

  }

  void _writeExerciseForUser(Exercise exercise) async {
    final userRef = dbRef.child('/Users/${widget.localId}');
    try{
      await userRef.update(exercise.toJson());
      print("Exercicio cadastrado no bd de exercicios!");
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
                              Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      controller: _repetitionsInputController,
                                      autofocus: true,
                                      decoration: const InputDecoration(
                                        hintText: 'Quantidade de repetições',
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                            borderSide: BorderSide(color: Colors.blue)
                                        ),
                                        filled: true,
                                        contentPadding:
                                        EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                                        labelText: "Repetições",
                                        prefixIcon: Icon(
                                          Icons.repeat_outlined,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      validator: (String? repetitions) {
                                        if (repetitions == null || repetitions.isEmpty) {
                                          return 'Numero inválido';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      controller: _intervalInputController,
                                      decoration: const InputDecoration(
                                        hintText: 'Insira o intervalo',
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                          borderSide: BorderSide(color: Colors.blue),

                                        ),
                                        filled: true,
                                        contentPadding:
                                        EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                                        labelText: "Intervalo",
                                        prefixIcon: Icon(
                                          Icons.pause_outlined,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10,),
                                    TextFormField(
                                      controller: _seriesInputController,
                                      decoration: const InputDecoration(
                                        hintText: 'Insira o número de séries',
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                          borderSide: BorderSide(color: Colors.blue),

                                        ),
                                        filled: true,
                                        contentPadding:
                                        EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                                        labelText: "Séries",
                                        prefixIcon: Icon(
                                          Icons.linear_scale_outlined,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10,),
                              ElevatedButton(
                                child: const Text('Ok'),
                                onPressed: () {
                                  // Exercise exercise = Exercise(
                                  //     name: name,
                                  //     linkYouTube: linkYouTube
                                  // ),
                                  // _writeExerciseOnDatabse();
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
            const CardProvider(
              title: Text("Terça Feira"),
              subtitle: Text("Não configurado"),
            ),
            const SizedBox(height: 10,),
            const CardProvider(
              title: Text("Quarta Feira"),
              subtitle: Text("Não configurado"),
            ),
            const SizedBox(height: 10,),
            const CardProvider(
              title: Text("Quinta Feira"),
              subtitle: Text("Não configurado"),
            ),
            const SizedBox(height: 10,),
            const CardProvider(
              title: Text("Sexta Feira"),
              subtitle: Text("Não configurado"),
            ),
            const SizedBox(height: 10,),
            const CardProvider(
              title: Text("Sábado"),
              subtitle: Text("Não configurado"),
            ),
            const SizedBox(height: 10,),
            const CardProvider(
              title: Text("Domingo"),
              subtitle: Text("Não configurado"),
            ),
          ],
        ),
      ),
    );
  }
}
