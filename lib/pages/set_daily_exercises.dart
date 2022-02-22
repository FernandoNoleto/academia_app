import 'dart:collection';
import 'dart:convert';

import 'package:academiaapp/common/providers/card_provider.dart';
import 'package:academiaapp/common/providers/container_provider.dart';
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


  final dbRef = FirebaseDatabase.instance.ref();
  // var _userId = "";
  late Object? userObject;
  late User user;

  @override
  void initState(){
    super.initState();
    _getUser(widget.localId);
  }

  void _getUser(String id) {
    dbRef.child("Users/$id").onValue.listen((event) {
      userObject = event.snapshot.value;
      print("entrou no get user");
      print(userObject);

      // Map<String, dynamic> json = Map<String, dynamic>.from(userObject as Map<dynamic, dynamic>);
      // print(jsonEncode(json));
      user = User.fromJson(jsonDecode(jsonEncode(Map<String, dynamic>.from(userObject as Map<dynamic, dynamic>))));
      print(user.toString());
    });

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
          children: const [
            CardProvider(
              title: Text("Segunda Feira"),
              subtitle: Text("Não configurado"),
            ),
            SizedBox(height: 10,),
            CardProvider(
              title: Text("Terça Feira"),
              subtitle: Text("Não configurado"),
            ),
            SizedBox(height: 10,),
            CardProvider(
              title: Text("Quarta Feira"),
              subtitle: Text("Não configurado"),
            ),
            SizedBox(height: 10,),
            CardProvider(
              title: Text("Quinta Feira"),
              subtitle: Text("Não configurado"),
            ),
            SizedBox(height: 10,),
            CardProvider(
              title: Text("Sexta Feira"),
              subtitle: Text("Não configurado"),
            ),
            SizedBox(height: 10,),
            CardProvider(
              title: Text("Sábado"),
              subtitle: Text("Não configurado"),
            ),
            SizedBox(height: 10,),
            CardProvider(
              title: Text("Domingo"),
              subtitle: Text("Não configurado"),
            ),
          ],
        ),
      ),
    );
  }
}
