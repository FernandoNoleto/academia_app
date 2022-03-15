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
  String dropdownValue = "";
  String day = "";
  late bool isDailyExerciseConfigured;


  @override
  void initState(){
    super.initState();
    _getUser(widget.localId);
    listOfExercises = FirebaseStorageProvider().getExercises();
    //TODO: Corrigir erro que lança exceção toda vez que abre pela primeira vez pq nao deu tempo de carregar as informaçãoes
    // dropdownValue = listOfExercises.firstWhere((element) => element == listOfExercises.first, orElse: () => "");
    dropdownValue = listOfExercises.first;
    // if (listOfExercises.isNotEmpty){
    //   dropdownValue = listOfExercises.first;
    // }
    // else{
    //   dropdownValue = " ";
    // }
  }

  void _getUser(String id) {
    dbRef.child("Users/$id").onValue.listen((event) {
      userObject = event.snapshot.value;
      // print(userObject);
      user = User.fromJson(jsonDecode(jsonEncode(Map<String, dynamic>.from(userObject as Map<dynamic, dynamic>))));
      print(user);
    });
  }

  void _getExerciseFromUser() async{
    final userRef = dbRef.child('/Users/${widget.localId}/Exerciciododia/$day/${exercise.name}');
    try{
      await userRef.update(exercise.toJson());
      print("Exercicio cadastrado no bd do usuário!");
    } catch (error){
      print("Deu o seguinte erro: $error");
    }
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

  void _deleteExercise(String nameExercise, day) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmar exclusão'),
            content: Text("Tem certeza que deseja excluir o exercício '$nameExercise'?"),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    dbRef.child("Users/${widget.localId}/Exerciciododia/$day/$nameExercise").remove();
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Sim'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Não'),
              ),
            ],
          );
        }
      );
    // dbRef.child("Users/${widget.localId}/Exerciciododia/$day/$nameExercise").remove();
  }

  void showModal(String day){
    dbRef.child("Users/${widget.localId}/Exerciciododia/$day").onValue.listen((event) async {
      isDailyExerciseConfigured = event.snapshot.exists;
    });
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ContainerProvider(
          vertical: 10,
          horizontal: 10,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                StreamBuilder(
                  stream: dbRef.child("Users/${widget.localId}/Exerciciododia/$day").orderByKey().onValue,
                  builder: (context, snapshot){
                    final tilesList = <Widget>[];
                    if (snapshot.hasData && isDailyExerciseConfigured) {
                      tilesList.add(Text("Exercícios de '$day' já adicionados:"));
                      tilesList.add(const SizedBox(height: 10,),);
                      print("tem dados");
                      final myExercises = (snapshot.data! as DatabaseEvent).snapshot.value as Map<Object, dynamic>;
                      myExercises.forEach((key, value) {
                        final nextExercise = Map<String, dynamic>.from(value);
                        final exerciseCard = CardProvider(
                          title: Text(nextExercise['name']),
                          subtitle: Text("Repetições:" +nextExercise['repetitions']),
                          logo: const Icon(Icons.account_circle, size: 32),
                          trailing: IconButton(
                            tooltip: "Alternar exercício configurado",
                            onPressed: () {
                              _deleteExercise(nextExercise['name'], day);
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        );
                        tilesList.add(exerciseCard);
                        tilesList.add(const SizedBox(height: 10,),);
                      });
                    }
                    else{
                      print("nao tem dados");
                      return Container();
                    }
                    return ListView(
                      shrinkWrap: true,
                      children: tilesList,
                    );
                  },
                ),
                Column(
                  children: [
                    StatefulBuilder(
                      builder: (BuildContext context, void Function(void Function()) setState) {
                        return DropdownButton<String>(
                          value: dropdownValue,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          style: const TextStyle(color: Colors.blue),
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
                        Exercise exercise = Exercise(
                          name: dropdownValue,
                          interval: _intervalInputController.text,
                          series: _seriesInputController.text,
                          repetitions: _repetitionsInputController.text,
                          day: day,
                        );
                        _writeExerciseForUser(exercise, day);
                        // Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
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
                showModal("Segunda-Feira");
                // showModalBottomSheet( //Modal
                //   context: context,
                //   builder: (BuildContext context){
                //     return Container(
                //       height: MediaQuery.of(context).size.height/2,
                //       color: Colors.black12,
                //       child: Center(
                //         child: ContainerProvider(
                //           horizontal: 10,
                //           vertical: 10,
                //           child: Column(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             mainAxisSize: MainAxisSize.max,
                //             children: <Widget>[
                //               StatefulBuilder(
                //                 builder: (BuildContext context, void Function(void Function()) setState) {
                //                   return DropdownButton<String>(
                //                     value: dropdownValue,
                //                     icon: const Icon(Icons.arrow_downward),
                //                     elevation: 16,
                //                     style: const TextStyle(color: Colors.deepPurple),
                //                     underline: Container(
                //                       height: 2,
                //                       color: Colors.deepPurpleAccent,
                //                     ),
                //                     onChanged: (String? newValue) {
                //                       setState(() {
                //                         dropdownValue = newValue!;
                //                         print(newValue);
                //                       });
                //                     },
                //                     items: listOfExercises.map<DropdownMenuItem<String>>((String value) {
                //                       return DropdownMenuItem<String>(
                //                         value: value,
                //                         child: Text(value),
                //                       );
                //                     }).toList(),
                //                   );
                //                 },
                //               ),
                //               const SizedBox(height: 10,),
                //               SetExerciseForm(
                //                 formKey: _formKey,
                //                 intervalInputController: _intervalInputController,
                //                 repetitionsInputController: _repetitionsInputController,
                //                 seriesInputController: _seriesInputController,
                //               ),
                //               const SizedBox(height: 10,),
                //               ElevatedButton(
                //                 child: const Text('Ok'),
                //                 onPressed: () {
                //                   // print(_intervalInputController.text);
                //                   Exercise exercise = Exercise(
                //                     name: dropdownValue,
                //                     interval: _intervalInputController.text,
                //                     series: _seriesInputController.text,
                //                     repetitions: _repetitionsInputController.text,
                //                     day: "Segunda-Feira",
                //                   );
                //                   day = "Segunda-Feira";
                //                   print(exercise.toString());
                //                   _writeExerciseForUser(exercise, day);
                //                   Navigator.pop(context);
                //                 },
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     );
                //   }, // Modal
                // );
              },
            ),
            const SizedBox(height: 10,),
            CardProvider(
              title: const Text("Terça Feira"),
              subtitle: const Text("Não configurado"),
              onTap: (){
                showModal("Terça-Feira");
                // showModalBottomSheet(
                //   context: context,
                //   builder: (BuildContext context){
                //     return Container(
                //       height: MediaQuery.of(context).size.height/2,
                //       color: Colors.black12,
                //       child: Center(
                //         child: ContainerProvider(
                //           horizontal: 10,
                //           vertical: 10,
                //           child: Column(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             mainAxisSize: MainAxisSize.max,
                //             children: <Widget>[
                //               StatefulBuilder(
                //                 builder: (BuildContext context, void Function(void Function()) setState) {
                //                   return DropdownButton<String>(
                //                     value: dropdownValue,
                //                     icon: const Icon(Icons.arrow_downward),
                //                     elevation: 16,
                //                     style: const TextStyle(color: Colors.deepPurple),
                //                     underline: Container(
                //                       height: 2,
                //                       color: Colors.deepPurpleAccent,
                //                     ),
                //                     onChanged: (String? newValue) {
                //                       setState(() {
                //                         dropdownValue = newValue!;
                //                         print(newValue);
                //                       });
                //                     },
                //                     items: listOfExercises.map<DropdownMenuItem<String>>((String value) {
                //                       return DropdownMenuItem<String>(
                //                         value: value,
                //                         child: Text(value),
                //                       );
                //                     }).toList(),
                //                   );
                //                 },
                //               ),
                //               const SizedBox(height: 10,),
                //               SetExerciseForm(
                //                 formKey: _formKey,
                //                 intervalInputController: _intervalInputController,
                //                 repetitionsInputController: _repetitionsInputController,
                //                 seriesInputController: _seriesInputController,
                //               ),
                //               const SizedBox(height: 10,),
                //               ElevatedButton(
                //                 child: const Text('Ok'),
                //                 onPressed: () {
                //                   // print(_intervalInputController.text);
                //                   Exercise exercise = Exercise(
                //                     name: dropdownValue,
                //                     interval: _intervalInputController.text,
                //                     series: _seriesInputController.text,
                //                     repetitions: _repetitionsInputController.text,
                //                     day: "Terça-Feira",
                //                   );
                //                   day = "Terça-Feira";
                //                   print(exercise.toString());
                //                   _writeExerciseForUser(exercise, day);
                //                   Navigator.pop(context);
                //                 },
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     );
                //   },
                // );
              },
            ),
            const SizedBox(height: 10,),
            CardProvider(
              title: const Text("Quarta Feira"),
              subtitle: const Text("Não configurado"),
              onTap: (){
                showModal("Quarta-Feira");
                // showModalBottomSheet(
                //   context: context,
                //   builder: (BuildContext context){
                //     return Container(
                //       height: MediaQuery.of(context).size.height/2,
                //       color: Colors.black12,
                //       child: Center(
                //         child: ContainerProvider(
                //           horizontal: 10,
                //           vertical: 10,
                //           child: Column(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             mainAxisSize: MainAxisSize.max,
                //             children: <Widget>[
                //               StatefulBuilder(
                //                 builder: (BuildContext context, void Function(void Function()) setState) {
                //                   return DropdownButton<String>(
                //                     value: dropdownValue,
                //                     icon: const Icon(Icons.arrow_downward),
                //                     elevation: 16,
                //                     style: const TextStyle(color: Colors.deepPurple),
                //                     underline: Container(
                //                       height: 2,
                //                       color: Colors.deepPurpleAccent,
                //                     ),
                //                     onChanged: (String? newValue) {
                //                       setState(() {
                //                         dropdownValue = newValue!;
                //                         print(newValue);
                //                       });
                //                     },
                //                     items: listOfExercises.map<DropdownMenuItem<String>>((String value) {
                //                       return DropdownMenuItem<String>(
                //                         value: value,
                //                         child: Text(value),
                //                       );
                //                     }).toList(),
                //                   );
                //                 },
                //               ),
                //               const SizedBox(height: 10,),
                //               SetExerciseForm(
                //                 formKey: _formKey,
                //                 intervalInputController: _intervalInputController,
                //                 repetitionsInputController: _repetitionsInputController,
                //                 seriesInputController: _seriesInputController,
                //               ),
                //               const SizedBox(height: 10,),
                //               ElevatedButton(
                //                 child: const Text('Ok'),
                //                 onPressed: () {
                //                   // print(_intervalInputController.text);
                //                   Exercise exercise = Exercise(
                //                     name: dropdownValue,
                //                     interval: _intervalInputController.text,
                //                     series: _seriesInputController.text,
                //                     repetitions: _repetitionsInputController.text,
                //                     day: "Quarta-Feira",
                //                   );
                //                   day = "Quarta-Feira";
                //                   print(exercise.toString());
                //                   _writeExerciseForUser(exercise, day);
                //                   Navigator.pop(context);
                //                 },
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     );
                //   },
                // );
              },
            ),
            const SizedBox(height: 10,),
            CardProvider(
              title: const Text("Quinta Feira"),
              subtitle: const Text("Não configurado"),
              onTap: (){
                showModal("Quinta-Feira");
                // showModalBottomSheet(
                //   context: context,
                //   builder: (BuildContext context){
                //     return Container(
                //       height: MediaQuery.of(context).size.height/2,
                //       color: Colors.black12,
                //       child: Center(
                //         child: ContainerProvider(
                //           horizontal: 10,
                //           vertical: 10,
                //           child: Column(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             mainAxisSize: MainAxisSize.max,
                //             children: <Widget>[
                //               StatefulBuilder(
                //                 builder: (BuildContext context, void Function(void Function()) setState) {
                //                   return DropdownButton<String>(
                //                     value: dropdownValue,
                //                     icon: const Icon(Icons.arrow_downward),
                //                     elevation: 16,
                //                     style: const TextStyle(color: Colors.deepPurple),
                //                     underline: Container(
                //                       height: 2,
                //                       color: Colors.deepPurpleAccent,
                //                     ),
                //                     onChanged: (String? newValue) {
                //                       setState(() {
                //                         dropdownValue = newValue!;
                //                         print(newValue);
                //                       });
                //                     },
                //                     items: listOfExercises.map<DropdownMenuItem<String>>((String value) {
                //                       return DropdownMenuItem<String>(
                //                         value: value,
                //                         child: Text(value),
                //                       );
                //                     }).toList(),
                //                   );
                //                 },
                //               ),
                //               const SizedBox(height: 10,),
                //               SetExerciseForm(
                //                 formKey: _formKey,
                //                 intervalInputController: _intervalInputController,
                //                 repetitionsInputController: _repetitionsInputController,
                //                 seriesInputController: _seriesInputController,
                //               ),
                //               const SizedBox(height: 10,),
                //               ElevatedButton(
                //                 child: const Text('Ok'),
                //                 onPressed: () {
                //                   // print(_intervalInputController.text);
                //                   Exercise exercise = Exercise(
                //                     name: dropdownValue,
                //                     interval: _intervalInputController.text,
                //                     series: _seriesInputController.text,
                //                     repetitions: _repetitionsInputController.text,
                //                     day: "Quinta-Feira",
                //                   );
                //                   day = "Quinta-Feira";
                //                   print(exercise.toString());
                //                   _writeExerciseForUser(exercise, day);
                //                   Navigator.pop(context);
                //                 },
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     );
                //   },
                // );
              },
            ),
            const SizedBox(height: 10,),
            CardProvider(
              title: const Text("Sexta Feira"),
              subtitle: const Text("Não configurado"),
              onTap: (){
                showModal("Sexta-Feira");
                // showModalBottomSheet(
                //   context: context,
                //   builder: (BuildContext context){
                //     return Container(
                //       height: MediaQuery.of(context).size.height/2,
                //       color: Colors.black12,
                //       child: Center(
                //         child: ContainerProvider(
                //           horizontal: 10,
                //           vertical: 10,
                //           child: Column(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             mainAxisSize: MainAxisSize.max,
                //             children: <Widget>[
                //               StatefulBuilder(
                //                 builder: (BuildContext context, void Function(void Function()) setState) {
                //                   return DropdownButton<String>(
                //                     value: dropdownValue,
                //                     icon: const Icon(Icons.arrow_downward),
                //                     elevation: 16,
                //                     style: const TextStyle(color: Colors.deepPurple),
                //                     underline: Container(
                //                       height: 2,
                //                       color: Colors.deepPurpleAccent,
                //                     ),
                //                     onChanged: (String? newValue) {
                //                       setState(() {
                //                         dropdownValue = newValue!;
                //                         print(newValue);
                //                       });
                //                     },
                //                     items: listOfExercises.map<DropdownMenuItem<String>>((String value) {
                //                       return DropdownMenuItem<String>(
                //                         value: value,
                //                         child: Text(value),
                //                       );
                //                     }).toList(),
                //                   );
                //                 },
                //               ),
                //               const SizedBox(height: 10,),
                //               SetExerciseForm(
                //                 formKey: _formKey,
                //                 intervalInputController: _intervalInputController,
                //                 repetitionsInputController: _repetitionsInputController,
                //                 seriesInputController: _seriesInputController,
                //               ),
                //               const SizedBox(height: 10,),
                //               ElevatedButton(
                //                 child: const Text('Ok'),
                //                 onPressed: () {
                //                   // print(_intervalInputController.text);
                //                   Exercise exercise = Exercise(
                //                     name: dropdownValue,
                //                     interval: _intervalInputController.text,
                //                     series: _seriesInputController.text,
                //                     repetitions: _repetitionsInputController.text,
                //                     day: "Sexta-Feira",
                //                   );
                //                   day = "Sexta-Feira";
                //                   print(exercise.toString());
                //                   _writeExerciseForUser(exercise, day);
                //                   Navigator.pop(context);
                //                 },
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     );
                //   },
                // );
              },
            ),
            const SizedBox(height: 10,),
            CardProvider(
              title: const Text("Sábado"),
              subtitle: const Text("Não configurado"),
              onTap: (){
                showModal("Sábado");
                // showModalBottomSheet(
                //   context: context,
                //   builder: (BuildContext context){
                //     return Container(
                //       height: MediaQuery.of(context).size.height/2,
                //       color: Colors.black12,
                //       child: Center(
                //         child: ContainerProvider(
                //           horizontal: 10,
                //           vertical: 10,
                //           child: Column(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             mainAxisSize: MainAxisSize.max,
                //             children: <Widget>[
                //               StatefulBuilder(
                //                 builder: (BuildContext context, void Function(void Function()) setState) {
                //                   return DropdownButton<String>(
                //                     value: dropdownValue,
                //                     icon: const Icon(Icons.arrow_downward),
                //                     elevation: 16,
                //                     style: const TextStyle(color: Colors.deepPurple),
                //                     underline: Container(
                //                       height: 2,
                //                       color: Colors.deepPurpleAccent,
                //                     ),
                //                     onChanged: (String? newValue) {
                //                       setState(() {
                //                         dropdownValue = newValue!;
                //                         print(newValue);
                //                       });
                //                     },
                //                     items: listOfExercises.map<DropdownMenuItem<String>>((String value) {
                //                       return DropdownMenuItem<String>(
                //                         value: value,
                //                         child: Text(value),
                //                       );
                //                     }).toList(),
                //                   );
                //                 },
                //               ),
                //               const SizedBox(height: 10,),
                //               SetExerciseForm(
                //                 formKey: _formKey,
                //                 intervalInputController: _intervalInputController,
                //                 repetitionsInputController: _repetitionsInputController,
                //                 seriesInputController: _seriesInputController,
                //               ),
                //               const SizedBox(height: 10,),
                //               ElevatedButton(
                //                 child: const Text('Ok'),
                //                 onPressed: () {
                //                   // print(_intervalInputController.text);
                //                   Exercise exercise = Exercise(
                //                     name: dropdownValue,
                //                     interval: _intervalInputController.text,
                //                     series: _seriesInputController.text,
                //                     repetitions: _repetitionsInputController.text,
                //                     day: "Sábado",
                //                   );
                //                   day = "Sábado";
                //                   print(exercise.toString());
                //                   _writeExerciseForUser(exercise, day);
                //                   Navigator.pop(context);
                //                 },
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     );
                //   },
                // );
              },
            ),
            const SizedBox(height: 10,),
            CardProvider(
              title: const Text("Domingo"),
              subtitle: Text("Não configurado"),
              onTap: () {
                showModal("Domingo");
                // showModalBottomSheet(
                //   context: context,
                //   builder: (BuildContext context){
                //     return Container(
                //       height: MediaQuery.of(context).size.height/2,
                //       color: Colors.black12,
                //       child: Center(
                //         child: ContainerProvider(
                //           horizontal: 10,
                //           vertical: 10,
                //           child: Column(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             mainAxisSize: MainAxisSize.max,
                //             children: <Widget>[
                //               StatefulBuilder(
                //                 builder: (BuildContext context, void Function(void Function()) setState) {
                //                   return DropdownButton<String>(
                //                     value: dropdownValue,
                //                     icon: const Icon(Icons.arrow_downward),
                //                     elevation: 16,
                //                     style: const TextStyle(color: Colors.deepPurple),
                //                     underline: Container(
                //                       height: 2,
                //                       color: Colors.deepPurpleAccent,
                //                     ),
                //                     onChanged: (String? newValue) {
                //                       setState(() {
                //                         dropdownValue = newValue!;
                //                         print(newValue);
                //                       });
                //                     },
                //                     items: listOfExercises.map<DropdownMenuItem<String>>((String value) {
                //                       return DropdownMenuItem<String>(
                //                         value: value,
                //                         child: Text(value),
                //                       );
                //                     }).toList(),
                //                   );
                //                 },
                //               ),
                //               const SizedBox(height: 10,),
                //               SetExerciseForm(
                //                 formKey: _formKey,
                //                 intervalInputController: _intervalInputController,
                //                 repetitionsInputController: _repetitionsInputController,
                //                 seriesInputController: _seriesInputController,
                //               ),
                //               const SizedBox(height: 10,),
                //               ElevatedButton(
                //                 child: const Text('Ok'),
                //                 onPressed: () {
                //                   // print(_intervalInputController.text);
                //                   Exercise exercise = Exercise(
                //                     name: dropdownValue,
                //                     interval: _intervalInputController.text,
                //                     series: _seriesInputController.text,
                //                     repetitions: _repetitionsInputController.text,
                //                     day: "Domingo",
                //                   );
                //                   day = "Domingo";
                //                   print(exercise.toString());
                //                   _writeExerciseForUser(exercise, day);
                //                   Navigator.pop(context);
                //                 },
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     );
                //   },
                // );
              },
            ),
          ],
        ),
      ),
    );
  }


}
