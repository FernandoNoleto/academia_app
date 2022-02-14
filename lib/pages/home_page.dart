import 'package:flutter/material.dart';

import 'detailed_exercise_page.dart';

import 'package:academia_app/common/providers/card_provider.dart';
import 'package:academia_app/common/providers/container_provider.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bem vindo de volta 'user'"),
      ),
      body: ContainerProvider(
        horizontal: 10,
        vertical: 10,
        child: Center(
          child: ListView(
            children: <Widget>[
              CardProvider(
                title: const Text("Nome exercício"),
                subtitle: const Text("Repetições: 10"),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return const DetailedExercisePage();
                    }),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
