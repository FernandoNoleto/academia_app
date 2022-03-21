import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;

/*Providers*/
import 'package:academiaapp/common/providers/snack_bar_provider.dart';
import 'package:academiaapp/common/providers/container_provider.dart';
import 'package:academiaapp/common/providers/firebase_auth_provider.dart';

/*Models*/
import 'package:academiaapp/common/models/user.dart';

class NewAccountPage extends StatefulWidget {
  const NewAccountPage({Key? key}) : super(key: key);

  @override
  _NewAccountPageState createState() => _NewAccountPageState();
}

class _NewAccountPageState extends State<NewAccountPage> {
  final TextEditingController _nameInputController = TextEditingController();
  final TextEditingController _emailInputController = TextEditingController();
  final TextEditingController _passwordInputController = TextEditingController();
  final TextEditingController _personalCodeInputController = TextEditingController();
  late bool _obscurePassword = true;
  late bool _obscurePersonalCode = true;
  late bool _isPersonal = false;
  final _formKey = GlobalKey<FormState>();
  final _dataBaseRef = FirebaseDatabase.instance.ref();


  @override
  void initState(){
    super.initState();
    _getPersonalCode();
  }

  Future<void> _doSignUp() async {
    if (_formKey.currentState!.validate()) {
      http.Response response = await SignUpProvider().signUp(
        _emailInputController.text,
        _passwordInputController.text,
        _nameInputController.text,
      );
      if(response.statusCode == 200){
        User user = User.fromJson(jsonDecode(response.body));
        // print(user);
        _writeUserOnDatabase(user);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBarProvider().showWrongSignUp());
    }
  }

  Future<void> _doSignUpAsPersonal() async {
    if (_formKey.currentState!.validate() && _personalCodeInputController.text == _getPersonalCode()) {
      http.Response response = await SignUpProvider().signUp(
        _emailInputController.text,
        _passwordInputController.text,
        _nameInputController.text,
      );
      if(response.statusCode == 200){
        User user = User.fromJson(jsonDecode(response.body));
        user.isPersonal = true;
        // print(user);
        _writeUserOnDatabase(user);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBarProvider().showWrongSignUp());
    }
  }

  _writeUserOnDatabase(User user) async {
    final userRef = _dataBaseRef.child('/Users/${user.localId}');
    try{
      await userRef.update(user.toJson());
      print("usuario escrito no BD!");
    }
    catch(error){
      ScaffoldMessenger.of(context).showSnackBar(SnackBarProvider().showError(error.toString()));
    }
  }

  String? _getPersonalCode(){
    String? personalCode;

    final userRef = _dataBaseRef.child('/Personalcode').onValue.listen((event) {
      personalCode = event.snapshot.value as String?;
    });


    return personalCode;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Criar nova conta"),
      ),
      body: ContainerProvider(
        horizontal: 10,
        vertical: 30,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget> [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Image(
                      image: AssetImage('assets/images/gym-icon.png'),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _nameInputController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Insira seu nome',
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.blue)
                        ),
                        filled: true,
                        contentPadding:
                        EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                        labelText: "Nome",
                        prefixIcon: Icon(
                          Icons.text_fields_sharp,
                          color: Colors.blue,
                        ),
                      ),
                      validator: (String? email) {
                        if (email == null || email.isEmpty) {
                          return 'Por favor, insira seu nome corretamente';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _emailInputController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Insira seu email',
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.blue)
                        ),
                        filled: true,
                        contentPadding:
                        EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                        labelText: "Email",
                        prefixIcon: Icon(
                          Icons.mail_outline,
                          color: Colors.blue,
                        ),
                      ),
                      validator: (String? email) {
                        if (email == null || email.isEmpty) {
                          return 'Por favor, insira seu email corretamente';
                        } else if (!email.contains("@")) {
                          return "E-mail inválido";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      obscureText: _obscurePassword,
                      controller: _passwordInputController,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off: Icons.visibility,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        hintText: 'Insira seu senha',
                        focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.blue)
                        ),
                        filled: true,
                        contentPadding:
                        const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                        labelText: "Senha",
                        prefixIcon: const Icon(
                          Icons.password_outlined,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Visibility(
                      visible: _isPersonal,
                      child: TextFormField(
                        obscureText: _obscurePersonalCode,
                        controller: _personalCodeInputController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePersonalCode ? Icons.visibility_off: Icons.visibility,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePersonalCode = !_obscurePersonalCode;
                              });
                            },
                          ),
                          hintText: 'Insira o código de personal',
                          focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(color: Colors.blue)
                          ),
                          filled: true,
                          contentPadding:
                          const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                          labelText: "Código",
                          prefixIcon: const Icon(
                            Icons.vpn_key_sharp,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    // const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Checkbox(
                          checkColor: Colors.white,
                          value: _isPersonal,
                          onChanged: (bool? value) {
                            setState(() {
                              _isPersonal = value!;
                            });
                          },
                        ),
                        const Text("Cadastrar como Personal"),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: FractionallySizedBox(
                        widthFactor: 1, // means 100%, you can change this to 0.8 (80%)
                        child: ElevatedButton(
                          child: const Text("Criar nova conta"),
                          onPressed: () {
                            _isPersonal ? _doSignUpAsPersonal() : _doSignUp();
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
