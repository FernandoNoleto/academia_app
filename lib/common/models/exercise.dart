class Exercise{
  String name; // nome do exercicios ex: flexao
  String series; // quantidade de series ex: 3 series
  String repetitions; // quantidade de repeticoes: 15 repeticoes
  String interval; // intervalo de descanso em segundos ex: 30 segundos
  String day; // dia do exercicio ex: quarta-feira
  String linkYouTube; // link do youtube



  Exercise({
    required this.name,
    required this.series,
    required this.repetitions,
    required this.interval,
    required this.day,
    required this.linkYouTube,
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