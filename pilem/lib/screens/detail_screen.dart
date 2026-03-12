// Digunakan untuk mengubah object menjadi JSON atau sebaliknya
import 'dart:convert';

// Library utama Flutter untuk membuat tampilan UI
import 'package:flutter/material.dart';

// Mengimport model Movie untuk menyimpan data film
import 'package:pilem/models/movie.dart';

// Package untuk menyimpan data sederhana di local storage (seperti favorit)
import 'package:shared_preferences/shared_preferences.dart';

// Halaman DetailScreen dibuat sebagai StatefulWidget
// Karena state (isFavorite) bisa berubah saat tombol favorite ditekan
class DetailScreen extends StatefulWidget {

  // Variabel movie untuk menerima data film dari halaman sebelumnya
  final Movie movie;

  // Constructor yang wajib menerima parameter movie
  const DetailScreen({super.key, required this.movie});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

// Class state untuk DetailScreen
class _DetailScreenState extends State<DetailScreen> {

  // Variabel untuk mengecek apakah film sudah menjadi favorite atau belum
  bool isFavorite = false;

  // Function untuk mengecek apakah film sudah tersimpan di SharedPreferences
  Future<void> _checkIsFavorite() async {

    // Mengambil instance SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Mengupdate state berdasarkan apakah key film ada atau tidak
    setState(() {

      // Mengecek apakah ada data dengan key movie_id
      isFavorite = prefs.containsKey('movie_${widget.movie.id}');
    });
  }

  // Function untuk menambah atau menghapus film dari favorite
  Future<void> _toggleFavorite() async {

    // Mengambil SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Mengubah status favorite (true ↔ false)
    setState(() {
      isFavorite = !isFavorite;
    });

    // Jika film menjadi favorite
    if (isFavorite) {

      // Mengubah object movie menjadi JSON String
      final String movieJson = jsonEncode(widget.movie.toJson());

      // Menyimpan movie JSON ke SharedPreferences
      prefs.setString('movie_${widget.movie.id}', movieJson);

      // Mengambil list id movie favorite yang sudah ada
      List<String> favoriteMovieIds =
          prefs.getStringList('favoriteMovies') ?? [];

      // Menambahkan id movie ke list favorite
      favoriteMovieIds.add(widget.movie.id.toString());

      // Menyimpan kembali list favorite ke SharedPreferences
      prefs.setStringList('favoriteMovies', favoriteMovieIds);

    } else {

      // Jika dihapus dari favorite

      // Menghapus data movie berdasarkan key
      prefs.remove('movie_${widget.movie.id}');

      // Mengambil list favorite yang ada
      List<String> favoriteMovieIds =
          prefs.getStringList('favoriteMovies') ?? [];

      // Menghapus id movie dari list favorite
      favoriteMovieIds.remove(widget.movie.id.toString());

      // Menyimpan kembali list favorite yang sudah diperbarui
      prefs.setStringList('favoriteMovies', favoriteMovieIds);
    }
  }

  // initState dijalankan pertama kali saat halaman dibuka
  @override
  void initState() {
    super.initState();

    // Mengecek apakah movie sudah menjadi favorite
    _checkIsFavorite();
  }

  @override
  Widget build(BuildContext context) {

    // Scaffold digunakan sebagai struktur dasar halaman
    return Scaffold(

      // AppBar di bagian atas layar
      appBar: AppBar(

        // Menampilkan judul film di AppBar
        title: Text(widget.movie.title),
      ),

      // Memberikan padding pada seluruh isi halaman
      body: Padding(
        padding: const EdgeInsets.all(8.0),

        // Membuat halaman bisa discroll jika konten panjang
        child: SingleChildScrollView(

          child: Column(

            // Mengatur posisi widget rata kiri
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              // Stack digunakan untuk menumpuk widget (gambar + tombol favorite)
              Stack(
                children: [

                  // Menampilkan gambar backdrop film dari TMDB
                  Image.network(
                    'https://image.tmdb.org/t/p/w500${widget.movie.backdropPath}',
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),

                  // Positioned digunakan untuk menempatkan widget di posisi tertentu
                  Positioned(
                    bottom: 8,
                    right: 8,

                    child: CircleAvatar(

                      // Warna background tombol
                      backgroundColor: Colors.white,

                      child: IconButton(

                        // Ketika tombol ditekan akan menjalankan toggle favorite
                        onPressed: _toggleFavorite,

                        // Jika favorite tampil icon hati penuh
                        // jika tidak favorite tampil icon hati kosong
                        icon: Icon(
                          isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border
                        ),

                        // Warna icon
                        color: Colors.red,
                      ),
                    ),
                  )
                ],
              ),

              // Memberi jarak
              const SizedBox(height: 20),

              // Judul bagian Overview
              const Text(
                'Overview:',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),

              const SizedBox(height: 10),

              // Menampilkan deskripsi film
              Text(widget.movie.overview),

              const SizedBox(height: 20),

              // Row untuk menampilkan release date
              Row(
                children: [

                  // Icon kalender
                  const Icon(
                    Icons.calendar_month,
                    color: Colors.blue,
                  ),

                  const SizedBox(width: 10),

                  // Label Release Date
                  const Text(
                    'Release Date:',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Menampilkan tanggal rilis film
                  Text(widget.movie.releaseDate),
                ],
              ),

              const SizedBox(height: 20),

              // Row untuk menampilkan rating film
              Row(
                children: [

                  // Icon bintang
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),

                  const SizedBox(width: 10),

                  // Label rating
                  const Text(
                    'Rating:',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Menampilkan rating film
                  Text(widget.movie.voteAverage.toString()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}