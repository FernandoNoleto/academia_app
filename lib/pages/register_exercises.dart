import 'package:flutter/material.dart';

/*Models*/
import 'package:academiaapp/common/models/exercise.dart';

/*Providers*/
import 'package:academiaapp/common/providers/container_provider.dart';

/*Plugins*/
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;



class RegisterExercisesPage extends StatefulWidget {
  const RegisterExercisesPage({Key? key}) : super(key: key);

  @override
  _RegisterExercisesPageState createState() => _RegisterExercisesPageState();
}

class _RegisterExercisesPageState extends State<RegisterExercisesPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameInputController = TextEditingController();
  final TextEditingController _linkInputController = TextEditingController();
  final database = FirebaseDatabase.instance.ref();

  _writeExerciseOnDatabse(Exercise exercise) async {
    final userRef = database.child('/Exercises/${exercise.name}');
    try{
      await userRef.update(exercise.toJson());
      print("Exercicio cadastrado no bd de exercicios!");
    } catch (error){
      print("Deu o seguinte erro: $error");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastrar exercícios"),
      ),
      body: ContainerProvider(
        horizontal: 10,
        vertical: 30,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Image(
                      image: AssetImage('assets/images/gym-icon.png'),
                      // width: 550,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _nameInputController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Nome do exercício',
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.blue)
                        ),
                        filled: true,
                        contentPadding:
                        EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                        labelText: "Nome",
                        prefixIcon: Icon(
                          Icons.text_fields,
                          color: Colors.blue,
                        ),
                      ),
                      validator: (String? email) {
                        if (email == null || email.isEmpty) {
                          return 'Por favor, insira o nome corretamente';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _linkInputController,
                      decoration: const InputDecoration(
                        hintText: 'Link para a aula no YouTube',
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.blue)
                        ),
                        filled: true,
                        contentPadding:
                        EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                        labelText: "Link",
                        prefixIcon: Icon(
                          Icons.insert_link,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: FractionallySizedBox(
                        widthFactor: 1, // means 100%, you can change this to 0.8 (80%)
                        child: ElevatedButton(
                          child: const Text("Registrar"),
                          onPressed: () {
                            if (_formKey.currentState!.validate()){
                              Exercise exercise = Exercise(
                                name: _nameInputController.text,
                                linkYouTube: _linkInputController.text,
                              );
                              // print("nome: ${_nameInputController.text}");
                              // print("link: ${_linkInputController.text}");
                              _writeExerciseOnDatabse(exercise);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
