import 'package:academiaapp/common/models/exercise.dart';

class User {
  final String name;
  final String uid;
  late bool? haveConfiguredExercises;
  late List<Exercise>? exercises;

  User({
    required this.name,
    required this.uid,
    this.haveConfiguredExercises = false,
    this.exercises = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    if (json['exercises'] != null) {
      var exercisesObjJson = json['exercises'] as List;
      List<Exercise> _exercises = exercisesObjJson.map((exerciseJson) => Exercise.fromJson(exerciseJson)).toList();

      print(json['displayName'] as String);

      return User(
        uid: json['localId'],
        name: json['displayName'],
        haveConfiguredExercises: json['haveConfiguredExercises'],
        exercises: _exercises,
      );
    } else {
      return User(
        name: json['displayName'] ?? "",
        uid: json['localId']?? "",
        haveConfiguredExercises: json['haveConfiguredExercises'] ?? false,
        exercises: [],
      );
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['uid'] = uid;
    data['haveConfiguredExercises'] = haveConfiguredExercises;
    data['exercise'] = exercises!.map((v) => v.toJson()).toList();
    return data;
  }

  @override
  toString(){
    return 'Nome: $name, uid: $uid, configExercise: $haveConfiguredExercises}';
  }
}
