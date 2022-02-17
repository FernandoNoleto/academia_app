class Exercise{
  String name;
  String repetitions;
  String interval;

  Exercise({required this.name, required this.repetitions, required this.interval});

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'],
      repetitions: json['repetitions'],
      interval: json['interval'],
    );
  }


  Map<String, dynamic> toJson() => <String, dynamic>{
    'name': name,
    'repetitions': repetitions,
    'interval': interval,

  };

}