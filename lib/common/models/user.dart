import 'package:academiaapp/common/models/day.dart';

class User {
  final String displayName;
  final String localId;
  late bool? haveConfiguredExercises;
  late List<Day>? days;

  User({
    required this.displayName,
    required this.localId,
    this.haveConfiguredExercises = false,
    this.days = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    if (json['days'] != null) {
      var daysObjJson = json['exercises'] as List;
      List<Day> _days = daysObjJson.map((dayJson) => Day.fromJson(dayJson)).toList();

      // print(json['displayName'] as String);
      print("entrou no if");

      return User(
        localId: json['localId'],
        displayName: json['displayName'],
        haveConfiguredExercises: json['haveConfiguredExercises'],
        days: _days,
      );
    } else {
      print("entrou no else");
      return User(
        displayName: json['displayName'] ?? "",
        localId: json['localId']?? "",
        haveConfiguredExercises: json['haveConfiguredExercises'] ?? false,
        days: const [],
      );
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['displayName'] = displayName;
    data['localId'] = localId;
    data['haveConfiguredExercises'] = haveConfiguredExercises;
    data['days'] = days!.map((v) => v.toJson()).toList();
    return data;
  }

  @override
  toString(){
    return 'Nome: $displayName, uid: $localId, configExercise: $haveConfiguredExercises';
  }
}
