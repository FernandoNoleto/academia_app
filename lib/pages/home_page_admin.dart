import 'package:flutter/material.dart';


/*Plugins*/
import 'dart:async';
import 'dart:html';
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
  late String _displayText;

  @override
  void initState(){
    super.initState();
    // _getListOfUsers();
    _activateListeners();
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


  void _activateListeners(){
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
            Text(_displayText, style: const TextStyle(color: Colors.blue)),

            StreamBuilder(
              stream: _dataBaseRef.child("Users").orderByKey().limitToLast(10).onValue,
              builder: (context, snapshot){
                final tilesList = <ListTile>[];
                if (snapshot.hasData) {
                  final myUsers = (snapshot.data! as DatabaseEvent).snapshot.value as Map<Object, dynamic>;
                  myUsers.forEach((key, value) {
                    final nextUser = Map<String, dynamic>.from(value);
                    final userTile = ListTile(
                      leading: const Icon(Icons.account_circle),
                      title: Text(nextUser['name']),
                    );
                    tilesList.add(userTile);
                  });
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
    );
  }
}
