class User {
  const User._(this.name, this.email, this.password);

  const User.view({required String name, required String email})
    : this._(name, email, '');

  const User.signIn({required String email, required String password})
    : this._('', email, password);

  final String name;
  final String email;
  final String password;
}
