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

  SnackBar showExerciseAddConfirmAlert(exercise){
    SnackBar showExerciseAddConfirmAlert = SnackBar(
      // ignore: unnecessary_string_escapes
      content: Text("Exercício \'" +exercise+ "\' adicionado!"),
      action: SnackBarAction(
        label: "Ok",
        onPressed: () {},
      ),
    );
    return showExerciseAddConfirmAlert;
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
    SnackBar showError = SnackBar(
      // ignore: unnecessary_string_escapes
      content: Text("Erro: "+error),
      action: SnackBarAction(
        label: "Ok",
        onPressed: () {},
      ),
    );
    return showError;
  }

  SnackBar showWrongSignUp(){
    SnackBar showWrongSignUp = SnackBar(
      // ignore: unnecessary_string_escapes
      content: const Text("Erro ao tentar efetuar o cadastro"),
      action: SnackBarAction(
        label: "Ok",
        onPressed: () {},
      ),
    );
    return showWrongSignUp;
  }

  SnackBar showMessage(message){
    SnackBar showMessage = SnackBar(
      // ignore: unnecessary_string_escapes
      content: Text(message),
      action: SnackBarAction(
        label: "Ok",
        onPressed: () {},
      ),
    );
    return showMessage;
  }


}