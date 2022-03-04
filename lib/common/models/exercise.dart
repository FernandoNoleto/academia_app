import 'package:firebase_database/firebase_database.dart';

class Exercise{
  final String name; // nome do exercicios ex: flexao
  final String? series; // quantidade de series ex: 3 series
  final String? repetitions; // quantidade de repeticoes: 15 repeticoes
  final String? interval; // intervalo de descanso em segundos ex: 30 segundos
  final String? day; // dia do exercicio ex: quarta-feira
  final String linkYouTube; // link do youtube



  Exercise({
    required this.name,
    this.series = "",
    this.repetitions = "",
    this.interval = "",
    this.day = "",
    this.linkYouTube = "",
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'] ?? "",
      series: json['series'] ?? "",
      repetitions: json['repetitions'] ?? "",
      interval: json['interval'] ?? "",
      day: json['day'] ?? "",
      linkYouTube: json['linkYouTube'] ?? "",
    );
  }


  // Exercise.fromSnapshot(DataSnapshot snapshot) :
  //       name = snapshot.value!["name"],
  //       series = snapshot.value!["series"],
  //       repetitions = snapshot.value!["repetitions"],
  //       interval = snapshot.value!["interval"],
  //       day = snapshot.value!["day"],
  //       linkYouTube = snapshot.value!["linkYouTube"];




  Map<String, dynamic> toJson() => <String, dynamic>{
    'name': name,
    'series': series,
    'repetitions': repetitions,
    'interval': interval,
    'day': day,
    'linkYouTube': linkYouTube,
  };

  @override
  toString(){
    return
        'name: $name,'
        'series: $series,'
        'repetitions: $repetitions,'
        'interval: $interval,'
        'day: $day,'
        'link: $linkYouTube';
  }

}