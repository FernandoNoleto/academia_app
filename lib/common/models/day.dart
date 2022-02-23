import 'package:academiaapp/common/models/exercise.dart';

class Day{
  final String name;
  late List<Exercise>? exercises;

  Day({
    required this.name,
    this.exercises = const [],
  });


  factory Day.fromJson(Map<String,dynamic> json){
    if (json['exercises'] != null) {
      var exercisesObjJson = json['exercises'] as List;
      List<Exercise> _exercises = exercisesObjJson.map((exerciseJson) => Exercise.fromJson(exerciseJson)).toList();

      return Day(
        name: json['name'],
        exercises: _exercises,
      );

    } else {
      return Day(
        name: json['name'] ?? "",
        exercises: [],
      );
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['exercise'] = exercises!.map((v) => v.toJson()).toList();
    return data;
  }

  @override
  toString(){
    return 'Nome: $name';
  }
}


