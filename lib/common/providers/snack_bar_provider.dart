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




}