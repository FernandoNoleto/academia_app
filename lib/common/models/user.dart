import 'package:academiaapp/common/models/exercise.dart';

class User {
  final String displayName;
  final String localId;
  late bool? haveConfiguredExercises;
  late List<Exercise>? exercises;

  User({
    required this.displayName,
    required this.localId,
    this.haveConfiguredExercises = false,
    this.exercises = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    if (json['exercises'] != null) {
      var exercisesObjJson = json['exercises'] as List;
      List<Exercise> _exercises = exercisesObjJson.map((exerciseJson) => Exercise.fromJson(exerciseJson)).toList();

      print(json['displayName'] as String);

      return User(
        localId: json['localId'],
        displayName: json['displayName'],
        haveConfiguredExercises: json['haveConfiguredExercises'],
        exercises: _exercises,
      );
    } else {
      return User(
        displayName: json['displayName'] ?? "",
        localId: json['localId']?? "",
        haveConfiguredExercises: json['haveConfiguredExercises'] ?? false,
        exercises: [],
      );
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['displayName'] = displayName;
    data['localId'] = localId;
    data['haveConfiguredExercises'] = haveConfiguredExercises;
    data['exercise'] = exercises!.map((v) => v.toJson()).toList();
    return data;
  }

  @override
  toString(){
    return 'Nome: $displayName, uid: $localId, configExercise: $haveConfiguredExercises';
  }
}
