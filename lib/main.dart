import 'package:flutter/material.dart';
import 'package:tokokita/ui/produk_page.dart'; // Mengarahkan ke List Produk
// import 'package:tokokita/ui/login_page.dart'; // Jika ingin mulai dari login

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // PERBAIKAN: gunakan super.key

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Toko Kita',
      debugShowCheckedModeBanner: false,
      home: ProdukPage(), // Halaman awal yang ditampilkan
    );
  }
}
