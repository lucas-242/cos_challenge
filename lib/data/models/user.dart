class User {
  const User._(this.email, this.password);

  const User.view({required String email}) : this._(email, '');

  const User.signIn({required String email, required String password})
    : this._(email, password);

  factory User.fromJson(Map<String, dynamic> json) =>
      User.view(email: json['email']);

  final String email;
  final String password;

  Map<String, dynamic> toJson() => {'email': email, 'password': password};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User && runtimeType == other.runtimeType && email == other.email;

  @override
  int get hashCode => email.hashCode ^ password.hashCode;
}
