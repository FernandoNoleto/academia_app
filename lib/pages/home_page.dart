import 'package:flutter/material.dart';

import 'detailed_exercise_page.dart';


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
      body: SizedBox(
        child: Center(
          child: ListView(
            children: <Widget>[
              Card(
                elevation: 10,
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: const Text("Titulo exercício"),
                  subtitle: const Text("Repetições: 10"),
                  leading: const FlutterLogo(
                    size: 72.0,
                  ),
                  onTap: () {
                    print("Clicou no card");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DetailedExercisePage()),
                    );
                  },
                ),
              ),
              Card(
                elevation: 10,
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: const Text("Titulo exercício"),
                  subtitle: const Text("Repetições: 10"),
                  leading: const FlutterLogo(
                    size: 72.0,
                  ),
                  onTap: () {
                    print("Clicou no card");
                  },
                ),
              ),
              Card(
                elevation: 10,
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: const Text("Titulo exercício"),
                  subtitle: const Text("Repetições: 10"),
                  leading: const FlutterLogo(
                    size: 72.0,
                  ),
                  onTap: () {
                    print("Clicou no card");
                  },
                ),
              ),
              Card(
                elevation: 10,
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: const Text("Titulo exercício"),
                  subtitle: const Text("Repetições: 10"),
                  leading: const FlutterLogo(
                    size: 72.0,
                  ),
                  onTap: () {
                    print("Clicou no card");
                  },
                ),
              ),
              Card(
                elevation: 10,
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: const Text("Titulo exercício"),
                  subtitle: const Text("Repetições: 10"),
                  leading: const FlutterLogo(
                    size: 72.0,
                  ),
                  onTap: () {
                    print("Clicou no card");
                  },
                ),
              ),
              Card(
                elevation: 10,
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: const Text("Titulo exercício"),
                  subtitle: const Text("Repetições: 10"),
                  leading: const FlutterLogo(
                    size: 72.0,
                  ),
                  onTap: () {
                    print("Clicou no card");
                  },
                ),
              ),
              Card(
                elevation: 10,
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: const Text("Titulo exercício"),
                  subtitle: const Text("Repetições: 10"),
                  leading: const FlutterLogo(
                    size: 72.0,
                  ),
                  onTap: () {
                    print("Clicou no card");
                  },
                ),
              ),
              Card(
                elevation: 10,
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: const Text("Titulo exercício"),
                  subtitle: const Text("Repetições: 10"),
                  leading: const FlutterLogo(
                    size: 72.0,
                  ),
                  onTap: () {
                    print("Clicou no card");
                  },
                ),
              ),
              Card(
                elevation: 10,
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: const Text("Titulo exercício"),
                  subtitle: const Text("Repetições: 10"),
                  leading: const FlutterLogo(
                    size: 72.0,
                  ),
                  onTap: () {
                    print("Clicou no card");
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
