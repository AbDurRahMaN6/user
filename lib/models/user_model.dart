class User {
  final int id;
  final String firstName;
  final String lastName;
  final String avatar;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'avatar': avatar,
    };
  }
}
s