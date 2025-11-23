class Transaction {
  final String id;
  final String judulFilm;
  final String posterFilm;
  final String jadwalFilm;
  final String namaPembeli;
  int jumlahTiket;
  final String tanggalBeli;
  int totalBiaya;
  String metodePembayaran;
  String? nomorKartu;
  String status;

  Transaction({
    required this.id,
    required this.judulFilm,
    required this.posterFilm,
    required this.jadwalFilm,
    required this.namaPembeli,
    required this.jumlahTiket,
    required this.tanggalBeli,
    required this.totalBiaya,
    required this.metodePembayaran,
    this.nomorKartu,
    this.status = 'selesai',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judulFilm': judulFilm,
      'posterFilm': posterFilm,
      'jadwalFilm': jadwalFilm,
      'namaPembeli': namaPembeli,
      'jumlahTiket': jumlahTiket,
      'tanggalBeli': tanggalBeli,
      'totalBiaya': totalBiaya,
      'metodePembayaran': metodePembayaran,
      'nomorKartu': nomorKartu,
      'status': status,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      judulFilm: json['judulFilm'],
      posterFilm: json['posterFilm'],
      jadwalFilm: json['jadwalFilm'],
      namaPembeli: json['namaPembeli'],
      jumlahTiket: json['jumlahTiket'],
      tanggalBeli: json['tanggalBeli'],
      totalBiaya: json['totalBiaya'],
      metodePembayaran: json['metodePembayaran'],
      nomorKartu: json['nomorKartu'],
      status: json['status'] ?? 'selesai',
    );
  }
}
