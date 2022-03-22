import 'dart:convert';

import 'package:academiaapp/common/providers/card_provider.dart';
import 'package:academiaapp/common/providers/container_provider.dart';
// import 'package:academiaapp/common/providers/firebase_storage.dart';
import 'package:academiaapp/common/providers/set_exercise_form_provider.dart';
import 'package:academiaapp/common/providers/snack_bar_provider.dart';
import 'package:flutter/material.dart';

/*Models*/
import 'package:academiaapp/common/models/exercise.dart';
import 'package:academiaapp/common/models/user.dart';


/*Plugins*/
import 'package:firebase_database/firebase_database.dart';


class SetDailyExercisesPage extends StatefulWidget {
  const SetDailyExercisesPage({
    Key? key,
    required this.localId,
    required this.list,
  }) : super(key: key);
  final String localId;
  final List<String> list;


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
  late User? user;
  late Exercise exercise;
  late List<String> listOfExercises;
  late String dropdownValue = "";
  late String day = "";
  late bool isDailyExerciseConfigured;


  @override
  void initState(){
    super.initState();
    _getUser(widget.localId);
    widget.list.isNotEmpty ? listOfExercises = widget.list : listOfExercises.add(""); // Lista é carregada desde a tela anterior
    dropdownValue = listOfExercises.first;
  }

  void _getUser(String id) async{
    dbRef.child("Users/$id").onValue.listen((event) {
      userObject = event.snapshot.value;
      // setState(() {
      user = User.fromJson(jsonDecode(jsonEncode(Map<String, dynamic>.from(userObject as Map<dynamic, dynamic>))));
      // });
    });
  }

  void _writeExerciseForUser(Exercise exercise, day) async {
    final userRef = dbRef.child('/Users/${widget.localId}/Exerciciododia/$day/${exercise.name}');
    try{
      await userRef.update(exercise.toJson());
      // print("Exercicio cadastrado no bd do usuário!");
    } catch (error){
      SnackBarProvider().showError(error.toString());
      // print("Deu o seguinte erro: $error");
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
  }

  bool isDailyExercise(String day){
    bool flag = false;

    dbRef.child("Users/${widget.localId}/Exerciciododia/$day").onValue.listen((event) async {
      flag = event.snapshot.exists;
    });
    // print(flag);
    return flag;
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
                  stream: dbRef.child("Users/${widget.localId}/Exerciciododia/$day").onValue,
                  builder: (context, AsyncSnapshot<DatabaseEvent> snapshot){
                    final tilesList = <Widget>[];
                    if (snapshot.hasData && isDailyExerciseConfigured) {
                      tilesList.add(Text("Exercícios de '$day' já adicionados:"));
                      tilesList.add(const SizedBox(height: 10,),);
                      // print("tem dados");
                      // final myExercises = (snapshot.data! as DatabaseEvent).snapshot.value as Map<Object, dynamic>;
                      final Map<String,dynamic> myExercises = Map<String,dynamic>.from(jsonDecode(jsonEncode((snapshot.data!).snapshot.value)));
                      myExercises.forEach((key, value) {
                        final nextExercise = Map<String, dynamic>.from(value);
                        final exerciseCard = CardProvider(
                          title: Text(nextExercise['name']),
                          subtitle: Text("Repetições:" +nextExercise['repetitions']),
                          logo: const Icon(Icons.account_circle, size: 32),
                          trailing: IconButton(
                            tooltip: "Deletar exercício configurado",
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
                      // print("nao tem dados");
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
                              // print(newValue);
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
                        setState(() {
                          _writeExerciseForUser(exercise, day);
                          _formKey.currentState?.reset();
                          SnackBarProvider().showExerciseAddConfirmAlert(exercise.name);
                        });
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
        title: user?.displayName != null ? Text("Aluno ${user?.displayName}") : const Text("Aluno"),
      ),
      body: ContainerProvider(
        vertical: 10,
        horizontal: 10,
        child: ListView(
          children: <Widget> [
            CardProvider(
              title: const Text("Segunda Feira"),
              //TODO: no celular, as informações visuais não atualizam quando tem ou não exercício configurado
              subtitle: isDailyExercise("Segunda-Feira") ? const Text("Configurado") : const Text("Não configurado"),
              borderColor: isDailyExercise("Segunda-Feira") ? const Color.fromARGB(255, 34, 187, 51) : const Color.fromARGB(255, 187, 33, 36),
              logo: isDailyExercise("Segunda-Feira") ? const Image(image: AssetImage('assets/images/exercise.png')) : const Image(image: AssetImage('assets/images/rest.png')),
              onTap: (){
                showModal("Segunda-Feira");
              },
            ),
            const SizedBox(height: 10,),
            CardProvider(
              title: const Text("Terça Feira"),
              subtitle: isDailyExercise("Terça-Feira") ? const Text("Configurado") : const Text("Não configurado"),
              borderColor: isDailyExercise("Terça-Feira") ? const Color.fromARGB(255, 34, 187, 51) : const Color.fromARGB(255, 187, 33, 36),
              logo: isDailyExercise("Terça-Feira") ? const Image(image: AssetImage('assets/images/exercise.png')) : const Image(image: AssetImage('assets/images/rest.png')),
              onTap: (){
                showModal("Terça-Feira");
              },
            ),
            const SizedBox(height: 10,),
            CardProvider(
              title: const Text("Quarta Feira"),
              subtitle: isDailyExercise("Quarta-Feira") ? const Text("Configurado") : const Text("Não configurado"),
              borderColor: isDailyExercise("Quarta-Feira") ? const Color.fromARGB(255, 34, 187, 51) : const Color.fromARGB(255, 187, 33, 36),
              logo: isDailyExercise("Quarta-Feira") ? const Image(image: AssetImage('assets/images/exercise.png')) : const Image(image: AssetImage('assets/images/rest.png')),
              onTap: (){
                showModal("Quarta-Feira");
              },
            ),
            const SizedBox(height: 10,),
            CardProvider(
              title: const Text("Quinta Feira"),
              subtitle: isDailyExercise("Quinta-Feira") ? const Text("Configurado") : const Text("Não configurado"),
              borderColor: isDailyExercise("Quinta-Feira") ? const Color.fromARGB(255, 34, 187, 51) : const Color.fromARGB(255, 187, 33, 36),
              logo: isDailyExercise("Quinta-Feira") ? const Image(image: AssetImage('assets/images/exercise.png')) : const Image(image: AssetImage('assets/images/rest.png')),
              onTap: (){
                showModal("Quinta-Feira");
              },
            ),
            const SizedBox(height: 10,),
            CardProvider(
              title: const Text("Sexta Feira"),
              subtitle: isDailyExercise("Sexta-Feira") ? const Text("Configurado") : const Text("Não configurado"),
              borderColor: isDailyExercise("Sexta-Feira") ? const Color.fromARGB(255, 34, 187, 51) : const Color.fromARGB(255, 187, 33, 36),
              logo: isDailyExercise("Sexta-Feira") ? const Image(image: AssetImage('assets/images/exercise.png')) : const Image(image: AssetImage('assets/images/rest.png')),
              onTap: (){
                showModal("Sexta-Feira");
              },
            ),
            const SizedBox(height: 10,),
            CardProvider(
              title: const Text("Sábado"),
              subtitle: isDailyExercise("Sábado") ? const Text("Configurado") : const Text("Não configurado"),
              borderColor: isDailyExercise("Sábado") ? const Color.fromARGB(255, 34, 187, 51) : const Color.fromARGB(255, 187, 33, 36),
              logo: isDailyExercise("Sábado") ? const Image(image: AssetImage('assets/images/exercise.png')) : const Image(image: AssetImage('assets/images/rest.png')),
              onTap: (){
                showModal("Sábado");
              },
            ),
            const SizedBox(height: 10,),
            CardProvider(
              title: const Text("Domingo"),
              subtitle: isDailyExercise("Domingo") ? const Text("Configurado") : const Text("Não configurado"),
              borderColor: isDailyExercise("Domingo") ? const Color.fromARGB(255, 34, 187, 51) : const Color.fromARGB(255, 187, 33, 36),
              logo: isDailyExercise("Domingo") ? const Image(image: AssetImage('assets/images/exercise.png')) : const Image(image: AssetImage('assets/images/rest.png')),
              onTap: () {
                showModal("Domingo");
              },
            ),
          ],
        ),
      ),
    );
  }
}
