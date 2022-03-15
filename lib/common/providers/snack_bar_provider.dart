import 'package:flutter/material.dart';

class SnackBarProvider{

  SnackBar showExerciseConfirmAlert(message){
    SnackBar showExerciseConfirmAlert = SnackBar(
      // ignore: unnecessary_string_escapes
      content: Text("Exercício \'" +message+ "\' cadastrado!"),
      action: SnackBarAction(
        label: "Ok",
        onPressed: () {},
      ),
    );
    return showExerciseConfirmAlert;
  }

  SnackBar showWrongLogIn(){
    SnackBar showWrongLogIn = SnackBar(
      // ignore: unnecessary_string_escapes
      content: const Text("Email ou senha inválido"),
      action: SnackBarAction(
        label: "Ok",
        onPressed: () {},
      ),
    );
    return showWrongLogIn;
  }

  SnackBar showError(String error){
    SnackBar showExerciseConfirmAlert = SnackBar(
      // ignore: unnecessary_string_escapes
      content: Text("Erro: "+error),
      action: SnackBarAction(
        label: "Ok",
        onPressed: () {},
      ),
    );
    return showExerciseConfirmAlert;
  }

  SnackBar showWrongSignUp(){
    SnackBar showExerciseConfirmAlert = SnackBar(
      // ignore: unnecessary_string_escapes
      content: const Text("Erro ao tentar efetuar o cadastro"),
      action: SnackBarAction(
        label: "Ok",
        onPressed: () {},
      ),
    );
    return showExerciseConfirmAlert;
  }



}