import 'dart:convert';

import 'package:academiaapp/common/models/exercise.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class FirebaseStorageProvider{

  List<String> getExercises(){

    List<String> exercises = [];
    late Exercise exercise;
    FirebaseDatabase.instance.ref().child("Exercises").onValue.listen((event) {
      final description = event.snapshot.children;
      for (var element in description) {
        exercise = Exercise.fromJson(jsonDecode(jsonEncode(Map<String, dynamic>.from(element.value as Map<dynamic, dynamic>))));
        print(exercise.name);
        exercises.add(exercise.name);
      }
    });

    return exercises;
  }

}