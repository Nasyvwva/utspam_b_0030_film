class User {
  final int? id;
  final String nama;
  final String email;
  final String alamat;
  final String noTelepon;
  final String username;
  final String password;

  User({
    this.id,
    required this.nama,
    required this.email,
    required this.alamat,
    required this.noTelepon,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'alamat': alamat,
      'noTelepon': noTelepon,
      'username': username,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      nama: map['nama'] as String,
      email: map['email'] as String,
      alamat: map['alamat'] as String,
      noTelepon: map['noTelepon'] as String,
      username: map['username'] as String,
      password: map['password'] as String,
    );
  }
}