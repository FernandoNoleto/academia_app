import 'package:academiaapp/common/models/user.dart';
import 'package:academiaapp/common/providers/container_provider.dart';
import 'package:academiaapp/pages/register_exercises.dart';
import 'package:academiaapp/pages/set_daily_exercises.dart';
import 'package:flutter/material.dart';


/*Plugins*/
import 'dart:async';
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


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Area do administrador"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            StreamBuilder(
              stream: _dataBaseRef.child("Users").orderByKey().limitToLast(10).onValue,
              builder: (context, snapshot){
                final tilesList = <ListTile>[];
                if (snapshot.hasData) {
                  final myUsers = (snapshot.data! as DatabaseEvent).snapshot.value as Map<Object, dynamic>;
                  myUsers.forEach((key, value) {
                    final nextUser = Map<String, dynamic>.from(value);
                    final userTile = ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      leading: const Icon(Icons.account_circle),
                      title: Text(nextUser['displayName']),
                      tileColor: nextUser['haveConfiguredExercises'] ? Colors.green : Colors.red,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SetDailyExercisesPage(localId: nextUser['localId'])),
                        );
                      },
                    );
                    tilesList.add(userTile);
                  });
                  // tilesList.addAll(
                  //     myUsers.values.map((value) {
                  //       final nextUser = User.fromJson(json)
                  //     }),
                  // );
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
                return Expanded(
                  child: ListView(
                    children: tilesList,
                  ),
                );
              },
            ),
          ],
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
