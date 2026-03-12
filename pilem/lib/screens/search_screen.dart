// Mengimport library utama Flutter untuk membuat UI
import 'package:flutter/material.dart';

// Mengimport model Movie untuk menyimpan data film dari API
import 'package:pilem/models/movie.dart';

// Mengimport halaman detail film
import 'package:pilem/screens/detail_screen.dart';

// Mengimport service API yang berisi fungsi mengambil data film dari API
import 'package:pilem/services/api_services.dart';

// Membuat halaman SearchScreen menggunakan StatefulWidget
// StatefulWidget digunakan karena data hasil pencarian akan berubah
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

// Class state dari SearchScreen
class _SearchScreenState extends State<SearchScreen> {

  // Membuat object ApiService untuk memanggil API
  final ApiService _apiService = ApiService();

  // Controller untuk mengontrol input pada TextField
  final TextEditingController _searchController = TextEditingController();

  // List untuk menyimpan hasil pencarian film
  List<Movie> _searchResults = [];

  // initState dijalankan pertama kali ketika halaman dibuka
  @override
  void initState(){
    super.initState();

    // Menambahkan listener pada TextField
    // Setiap teks berubah maka function _searchMovies akan dijalankan
    _searchController.addListener(_searchMovies);
  }

  // dispose digunakan untuk membersihkan controller
  // supaya tidak terjadi memory leak
  @override
  void dispose() {

    // Menghapus controller ketika widget dihancurkan
    _searchController.dispose();

    super.dispose();
  }

  // Function untuk mencari film dari API
  void _searchMovies() async {

    // Jika text pencarian kosong
    if(_searchController.text.isEmpty){

      // Menghapus hasil pencarian
      setState(() {
        _searchResults.clear();
      });

      return;
    }

    // Memanggil API untuk mencari film berdasarkan keyword
    final List<Map<String, dynamic>> searchData = 
      await _apiService.searchMovies(_searchController.text);

    // Mengubah data JSON menjadi object Movie
    setState(() {
      _searchResults = searchData.map((e) => Movie.fromJson(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {

    // Scaffold adalah struktur dasar halaman Flutter
    return Scaffold(

      // AppBar di bagian atas halaman
      appBar: AppBar(
        title: const Text('Search'),
      ),

      // Memberikan padding pada seluruh isi halaman
      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(

          children: [

            // Container untuk membuat kotak search
            Container(

              padding: const EdgeInsets.all(8.0),

              // Dekorasi kotak search
              decoration: BoxDecoration(

                // Membuat border
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0
                ),

                // Membuat sudut kotak melengkung
                borderRadius: BorderRadius.circular(5.0),
              ),

              // Row digunakan untuk menaruh TextField dan tombol clear
              child: Row(
                children: [

                  // Expanded agar TextField memenuhi sisa ruang
                  Expanded(

                    child: TextField(

                      // Menghubungkan TextField dengan controller
                      controller: _searchController,

                      // Dekorasi TextField
                      decoration: const InputDecoration(

                        // Text placeholder
                        hintText: 'Search movies...',

                        // Menghilangkan border bawaan TextField
                        border: InputBorder.none
                      ),
                    ),
                  ),

                  // Visibility digunakan untuk menampilkan tombol clear
                  // hanya jika ada teks di TextField
                  Visibility(

                    // Tombol clear hanya muncul jika text tidak kosong
                    visible: _searchController.text.isNotEmpty,

                    child: IconButton(

                      // Icon tombol clear
                      icon: const Icon(Icons.clear),

                      // Ketika tombol ditekan
                      onPressed: (){

                        // Menghapus text pada TextField
                        _searchController.clear();

                        // Menghapus hasil pencarian
                        setState(() {
                          _searchResults.clear();
                        });
                      },
                    ),
                  )
                ],
              ),
            ),

            // Memberi jarak
            const SizedBox(height: 16),

            // Expanded agar ListView memenuhi sisa layar
            Expanded(

              // ListView untuk menampilkan hasil pencarian
              child: ListView.builder(

                // Jumlah data hasil pencarian
                itemCount: _searchResults.length,

                itemBuilder: (context, index){

                  // Mengambil data film berdasarkan index
                  final Movie movie = _searchResults[index];

                  return Padding(

                    padding: const EdgeInsets.symmetric(vertical: 4),

                    // ListTile untuk menampilkan item film
                    child: ListTile(

                      // Menampilkan poster film
                      leading: Image.network(

                        // URL poster dari TMDB API
                        'https://image.tmdb.org/t/p/w500${movie.posterPath}',

                        height: 50,
                        width: 50,

                        // Mengatur ukuran gambar
                        fit: BoxFit.cover,
                      ),

                      // Menampilkan judul film
                      title: Text(movie.title),

                      // Ketika item diklik
                      onTap: (){

                        // Pindah ke halaman DetailScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(

                            // Mengirim data movie ke DetailScreen
                            builder: (context) => DetailScreen(movie: movie)
                          )
                        );
                      },
                    ), 
                  );
                },
              )
            )
          ],
        ),
      ),
    );
  }
}