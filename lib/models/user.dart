class User {
  final String nama;
  final String email;
  final String alamat;
  final String noTelepon;
  final String username;
  final String password;

  User({
    required this.nama,
    required this.email,
    required this.alamat,
    required this.noTelepon,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'email': email,
      'alamat': alamat,
      'noTelepon': noTelepon,
      'username': username,
      'password': password,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      nama: json['nama'],
      email: json['email'],
      alamat: json['alamat'],
      noTelepon: json['noTelepon'],
      username: json['username'],
      password: json['password'],
    );
  }
}