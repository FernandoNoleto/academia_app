import 'package:academiaapp/common/models/exercise.dart';

class User {
  String name;
  String uid;
  bool haveConfiguredExercises;
  List<Exercise> exercises;

  User({
    required this.name,
    required this.uid,
    required this.haveConfiguredExercises,
    required this.exercises,
  });

  factory User.fromJson(Map<String, dynamic> json) {

      name: json['name'],
      uid: json['uid'],
      haveConfiguredExercises: json['haveConfiguredExercises'],
      if (json['exercises'] != null) {
        var exercisesObjJson = json['exercises'] as List;
        List<Exercise> _exercises = exercisesObjJson.map(())

      }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['uid'] = uid;
    data['haveConfiguredExercises'] = haveConfiguredExercises;
    if (exercise != null) {
      data['exercise'] = exercise!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
