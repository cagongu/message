class RegisterRequest {
  String username;
  String password;
  String name;
  int age;
  String email;

  RegisterRequest(
      {required this.username,
      required this.password,
      required this.name,
      required this.age,
      required this.email});

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'name': name,
        'age': age,
        'email': email
      };

  factory RegisterRequest.fromJson(Map<String, dynamic> json) {
    return RegisterRequest(
      username: json['username'],
      password: json['password'],
      name: json['name'],
      age: json['age'],
      email: json['email'],
    );
  }
}
