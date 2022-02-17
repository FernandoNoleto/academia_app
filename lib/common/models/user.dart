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

  @override
  String toString() {
    return 'id:${this.uid}, nome:${this.name}';
  }

}