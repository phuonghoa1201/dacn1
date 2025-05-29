class User{
  final String id;
  final String name;

  User({required this.id, required this.name});

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
    );
  }
}