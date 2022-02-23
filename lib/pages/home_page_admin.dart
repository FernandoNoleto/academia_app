import 'package:academiaapp/common/models/user.dart';
import 'package:academiaapp/common/providers/container_provider.dart';
import 'package:academiaapp/pages/register_exercises.dart';
import 'package:academiaapp/pages/set_daily_exercises.dart';
import 'package:flutter/material.dart';


/*Plugins*/
import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';

/*Providers*/
import 'package:academiaapp/common/providers/card_provider.dart';


class HomePageAdmin extends StatefulWidget {
  const HomePageAdmin({Key? key}) : super(key: key);

  @override
  _HomePageAdminState createState() => _HomePageAdminState();
}

class _HomePageAdminState extends State<HomePageAdmin> {

  final _dataBaseRef = FirebaseDatabase.instance.ref();
  late StreamSubscription _srtmSubscription;
  late List listOfUsers = [];
  var _displayText = "";


  @override
  void initState(){
    super.initState();
    // _getListOfUsers();
    // _activateListeners();
    // listOfUsers = _getListOfUsers();
  }

  @override
  void deactivate(){
    _srtmSubscription.cancel();
    super.deactivate();
  }

  void _getListOfUsers(){
    _srtmSubscription = _dataBaseRef.child("Users").onValue.listen((event) {
      final Object? description = event.snapshot.children;
      setState(() {

        print("Exercicio: $description");
      });
    });
  }

  Future _activateListeners() async {
    _srtmSubscription = _dataBaseRef.child("exerciciododia").onValue.listen((event) {
      final data = Map<String, dynamic>.from(event.snapshot.value as dynamic);
      final exercise = data['exercise'] as String;
      final repetitions = data['repetitions'] as String;
      final interval = data['interval'] as String;
      setState(() {
        _displayText = "Exercicio do dia: $exercise com $repetitions repetições e intervalo de $interval segundos";
      });
    });
  }

  _toggleHaveConfiguredExercise(User user, bool toggle) async{
    final userRef = _dataBaseRef.child('/Users/${user.localId}');
    try{
      user.haveConfiguredExercises = toggle;
      await userRef.update(user.toJson());
      print("Usuário atualizado no bd!");
    } catch (error){
      print("Deu o seguinte erro: $error");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Area do administrador"),
      ),
      body: ContainerProvider(
        vertical: 10,
        horizontal: 10,
        child: StreamBuilder(
          stream: _dataBaseRef.child("Users").orderByKey().onValue,
          builder: (context, snapshot){
            final tilesList = <Widget>[];
            if (snapshot.hasData) {
              final myUsers = (snapshot.data! as DatabaseEvent).snapshot.value as Map<Object, dynamic>;
              myUsers.forEach((key, value) {
                final nextUser = Map<String, dynamic>.from(value);
                final userCard = CardProvider(
                  title: Text(nextUser['displayName']),
                  subtitle: const Text("subtitle"),
                  logo: const Icon(Icons.account_circle, size: 32),
                  borderColor: nextUser['haveConfiguredExercises'] ? const Color.fromARGB(255, 34, 187, 51) : const Color.fromARGB(255, 187, 33, 36),
                  trailing: IconButton(
                    tooltip: "Alternar exercício configurado",
                    icon: nextUser['haveConfiguredExercises'] ? const Icon(Icons.check) : const Icon(Icons.clear),
                    onPressed: () {
                      nextUser['haveConfiguredExercises'] ? _toggleHaveConfiguredExercise(User.fromJson(value), false):_toggleHaveConfiguredExercise(User.fromJson(value), true);
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SetDailyExercisesPage(localId: nextUser['localId'])),
                    );
                  },
                );
                tilesList.add(userCard);
                tilesList.add(const SizedBox(height: 10,),);
              });
            }
            else{
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const <Widget>[
                    CircularProgressIndicator(),
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
      floatingActionButton: FloatingActionButton(
        tooltip: "Registrar novo exercício",
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegisterExercisesPage()),
          );
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}