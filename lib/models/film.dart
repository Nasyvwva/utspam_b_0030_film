class Film {
  final String judul;
  final String genre;
  final int harga;
  final String poster;
  final List<String> jadwal;

  Film({
    required this.judul,
    required this.genre,
    required this.harga,
    required this.poster,
    required this.jadwal,
  });

  static List<Film> dummyFilms = [
    Film(
      judul: 'Death Poetry Society',
      genre: 'Drama',
      harga: 50000, 
      poster: 'death_poetry_society.png',
      jadwal: ['12:05', '14:00', '16:35', '18:50', '21:05'],
    ),
    Film(
      judul: 'Sampai Titik Terakhirmu',
      genre: 'Romantis',
      harga: 45000,
      poster: 'stterakhir.png',
      jadwal: ['11:00', '13:20', '15:40','18:00', '19:05', '20:20', '21:15'],
    ),
    Film(
      judul: 'Grave Of The Fireflies',
      genre: 'Animasi',
      harga: 40000,
      poster: 'grave_of_the_fireflies.png',
      jadwal: ['12:00', '15:00', '18:00', '21:00'],
    ),
    Film(
      judul: 'Your Letter',
      genre: 'Animasi',
      harga: 55000,
      poster: 'your_letter.png',
      jadwal: ['10:30', '13:30', '16:30', '19:30'],
    ),
  ];
}