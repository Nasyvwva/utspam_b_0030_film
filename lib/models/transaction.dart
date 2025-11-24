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

  Map<String, dynamic> toMap() {
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

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as String,
      judulFilm: map['judulFilm'] as String,
      posterFilm: map['posterFilm'] as String,
      jadwalFilm: map['jadwalFilm'] as String,
      namaPembeli: map['namaPembeli'] as String,
      jumlahTiket: map['jumlahTiket'] as int,
      tanggalBeli: map['tanggalBeli'] as String,
      totalBiaya: map['totalBiaya'] as int,
      metodePembayaran: map['metodePembayaran'] as String,
      nomorKartu: map['nomorKartu'] as String?,
      status: map['status'] as String,
    );
  }
}