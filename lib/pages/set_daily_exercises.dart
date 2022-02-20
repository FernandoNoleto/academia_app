import 'package:flutter/material.dart';

/*Plugins*/
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';


class SetDailyExercisesPage extends StatefulWidget {
  const SetDailyExercisesPage({Key? key}) : super(key: key);

  @override
  _SetDailyExercisesPageState createState() => _SetDailyExercisesPageState();
}

class _SetDailyExercisesPageState extends State<SetDailyExercisesPage> {

  final database = FirebaseDatabase.instance.ref();
  @override
  Widget build(BuildContext context) {

    final userRef = database.child('/qnggfarRIdVN5MR9Yg2qDUADku62');
    var obj = {'exercise': 'flexao', 'repetitions': '20', 'interval': '60'};

    return Scaffold(
      appBar: AppBar(
        title: const Text("Painel de controle"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            children: [
              ElevatedButton(
                child: const Text("Submeter"),
                onPressed: () async {
                  try{
                    await userRef
                        .set({'exercise': 'flexao', 'repetitions': '20', 'interval': '60'});
                    print("Exercicio diario escrito!");
                  } catch (error){
                    print("Deu o seguinte erro: $error");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
