import 'package:academiaapp/common/models/exercise.dart';

class User{
  final String uid;
  final String name;
  final Exercise exercise;

  User({required this.name, required this.uid, required this.exercise});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['localId'],
      name: json['displayName'],
      exercise: Exercise.fromJson(json['exercise']),

    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'name': name,
    'uid': uid,
    'exercise': exercise.toJson(),
  };


  @override
  String toString() {
    return 'id:${this.uid}, nome:${this.name}';
  }


/*HOW TO PARSE TO JSON*/
//print(jsonEncode(user.toJson()));
}