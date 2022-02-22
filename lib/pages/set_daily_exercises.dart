import 'dart:collection';
import 'dart:convert';

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

      Map<String, dynamic> json = Map<String, dynamic>.from(userObject as Map<dynamic, dynamic>);
      print(jsonEncode(json));
      user = User.fromJson(jsonDecode(jsonEncode(json)));
      print(user.toString());
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aluno ${user.displayName}"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            children: [
              ElevatedButton(
                child: const Text("Submeter"),
                onPressed: () => print(widget.localId),
                // onPressed: () async {
                //   try{
                //     await userRef
                //         .set({'exercise': 'flexao', 'repetitions': '20', 'interval': '60'});
                //     print("Exercicio diario escrito!");
                //   } catch (error){
                //     print("Deu o seguinte erro: $error");
                //   }
                // },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
