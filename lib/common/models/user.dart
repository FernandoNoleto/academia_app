class User{
  final String uid;
  final String name;

  User({required this.name, required this.uid});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        uid: json['localId'],
        name: json['displayName'],
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'name': name,
    'uid': uid,
  };


  @override
  String toString() {
    return 'id:${this.uid}, nome:${this.name}';
  }


  /*HOW TO PARSE TO JSON*/
  //print(jsonEncode(user.toJson()));
}