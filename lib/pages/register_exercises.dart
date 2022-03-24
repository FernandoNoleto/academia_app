
/*Models*/
import 'package:academiaapp/common/models/exercise.dart';

/*Providers*/
import 'package:academiaapp/common/providers/snack_bar_provider.dart';
import 'package:academiaapp/common/providers/container_provider.dart';

/*Plugins*/
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:media_gallery/media_gallery.dart';
// import 'package:media_gallery_example/picker/picker.dart';
// import 'package:media_gallery_example/picker/selection.dart';



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
            children: <Widget>[
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
                      validator: (String? name) {
                        if (name == null || name.isEmpty) {
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
                          borderSide: BorderSide(color: Colors.blue),
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
                      validator: (String? name) {
                        if (name == null || name.isEmpty) {
                          return 'Por favor, insira o nome corretamente';
                        }
                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: FractionallySizedBox(
                        widthFactor: 1,
                        child: ElevatedButton(
                          child: const Text("Registrar"),
                          onPressed: () {
                            if (_formKey.currentState!.validate()){
                              Exercise exercise = Exercise(
                                name: _nameInputController.text,
                                linkYouTube: _linkInputController.text,
                              );
                              _writeExerciseOnDatabse(exercise);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBarProvider().showExerciseConfirmAlert(_nameInputController.text));
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const <Widget>[
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            indent: 10,
                            endIndent: 10,
                          ),
                        ),
                        Text("Ou"),
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            indent: 10,
                            endIndent: 10,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: FractionallySizedBox(
                        widthFactor: 1,
                        child: ElevatedButton(
                          child: const Text("Escolher video da galeria"),
                          onPressed: () {
                            //TODO: Implementar função de pergar video da galeria
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
