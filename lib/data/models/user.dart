class User {
  const User._(this.name, this.email, this.password);

  const User.view({required String name, required String email})
    : this._(name, email, '');

  const User.signIn({required String email, required String password})
    : this._('', email, password);

  factory User.fromJson(Map<String, dynamic> json) =>
      User.view(name: json['name'], email: json['email']);

  final String name;
  final String email;
  final String password;

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'password': password,
  };
}
