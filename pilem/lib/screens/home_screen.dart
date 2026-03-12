// Mengimport library Flutter untuk membuat UI
import 'package:flutter/material.dart';

// Mengimport model Movie yang digunakan untuk menyimpan data film dari API
import 'package:pilem/models/movie.dart';

// Mengimport halaman detail untuk menampilkan detail film ketika diklik
import 'package:pilem/screens/detail_screen.dart';

// Mengimport service API yang berisi fungsi untuk mengambil data film dari API
import 'package:pilem/services/api_services.dart';

// Membuat class HomeScreen menggunakan StatefulWidget
// StatefulWidget dipakai karena data film akan berubah setelah diambil dari API
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// Class state dari HomeScreen
class _HomeScreenState extends State<HomeScreen> {

  // Membuat object ApiService untuk memanggil API
  final ApiService _apiService = ApiService();

  // List untuk menyimpan berbagai kategori film
  List<Movie> _allMovies = [];       // semua film
  List<Movie> _trendingMovies = [];  // film trending
  List<Movie> _popularMovies = [];   // film populer

  // Function untuk mengambil data film dari API
  Future<void> _loadMovies() async {

    // Mengambil data semua film dari API
    final List<Map<String, dynamic>> allMoviesData =
        await _apiService.getAllMovies();

    // Mengambil data film trending dari API
    final List<Map<String, dynamic>> trendingMoviesData =
        await _apiService.getTrendingMovies();

    // Mengambil data film populer dari API
    final List<Map<String, dynamic>> popularMoviesData =
        await _apiService.getPopularMovies();

    // Mengupdate state setelah data didapatkan
    setState(() {

      // Mengubah data JSON menjadi object Movie
      _allMovies = allMoviesData.map((e) => Movie.fromJson(e)).toList();

      _trendingMovies =
          trendingMoviesData.map((e) => Movie.fromJson(e)).toList();

      _popularMovies =
          popularMoviesData.map((e) => Movie.fromJson(e)).toList();
    });
  }

  // initState dijalankan pertama kali ketika halaman dibuka
  @override
  void initState() {
    super.initState();

    // Memanggil function untuk mengambil data film
    _loadMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // AppBar di bagian atas aplikasi
      appBar: AppBar(title: Text("Pilem")),

      // SingleChildScrollView supaya halaman bisa discroll vertikal
      body: SingleChildScrollView(
        child: Column(

          // Mengatur posisi widget agar rata kiri
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            // Menampilkan list semua film
            _buildMovieList("All Movies", _allMovies),

            // Menampilkan list film trending
            _buildMovieList("Trending Movies", _trendingMovies),

            // Menampilkan list film populer
            _buildMovieList("Popular Movies", _popularMovies),
          ],
        ),
      ),
    );
  }

  // Function untuk membuat tampilan list film
  Widget _buildMovieList(String title, List<Movie> movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // Menampilkan judul kategori film
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
          ),
        ),

        // Container dengan tinggi tetap untuk menampilkan film secara horizontal
        SizedBox(
          height: 200,

          // ListView.builder digunakan untuk membuat list film secara dinamis
          child: ListView.builder(

            // Mengatur arah scroll menjadi horizontal
            scrollDirection: Axis.horizontal,

            // Jumlah film yang ditampilkan
            itemCount: movies.length,

            itemBuilder: (BuildContext context, int index) {

              // Mengambil data film berdasarkan index
              final Movie movie = movies[index];

              return GestureDetector(

                // Ketika film diklik akan pindah ke halaman DetailScreen
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(movie: movie),
                  )
                ),

                child: Padding(
                  padding: EdgeInsets.all(8.0),

                  child: Column(
                    children: [

                      // Menampilkan poster film dari API TMDB
                      Image.network(
                        'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                        height: 150,
                        width: 100,
                        fit: BoxFit.cover,
                      ),

                      // Memberi jarak antara gambar dan judul
                      SizedBox(height: 5),

                      // Menampilkan judul film
                      Text(

                        // Jika judul terlalu panjang maka dipotong
                        movie.title.length > 14
                          ? '${movie.title.substring(0,10)}...'
                          : movie.title,

                        style: const TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}