# H1D023039 Tugas 8 (Pertemuan 10): TokoKita App

Proyek ini adalah aplikasi mobile yang dibangun menggunakan Flutter sebagai bagian dari praktikum Pemrograman Mobile (Pertemuan 10). Aplikasi "TokoKita" dirancang untuk mengelola data produk (CRUD - Create, Read, Update, Delete) dan menyimulasikan interaksi dengan REST API yang dibangun menggunakan CodeIgniter 4. Aplikasi ini mencakup fitur otentikasi pengguna (Login & Registrasi) serta manajemen produk yang lengkap.

## Data Diri

* **Nama:** Alfan Fauzan Ridlo
* **NIM:** H1D023039
* **Shift:** B
* **Shift KRS:** C

## Fitur Utama Aplikasi

1.  **Sistem Otentikasi:** Menyediakan formulir **Login** dan **Registrasi** dengan validasi input yang ketat (Format Email, Panjang Password, dll).
2.  **List Produk:** Menampilkan daftar produk dalam tampilan list yang rapi.
3.  **Detail Produk:** Melihat rincian informasi produk tertentu.
4.  **Tambah & Ubah Produk:** Menggunakan satu formulir dinamis (`reusable form`) yang dapat mendeteksi apakah pengguna sedang menambah data baru atau mengedit data lama.
5.  **Hapus Produk:** Fitur konfirmasi dialog sebelum menghapus data produk untuk mencegah ketidaksengajaan.
6.  **Personalisasi UI:** Menampilkan nama pengguna ("Alfan") pada setiap *AppBar* halaman sebagai identitas pembuat.

---

## Penjelasan Kode & Poin Kreatif

Berikut adalah rincian struktur kode utama dan modifikasi kreatif yang diterapkan dalam aplikasi ini:

### 1. Folder `lib/model`

Bagian ini berfungsi sebagai representasi data (Object Modeling) untuk memetakan format JSON dari API ke objek Dart.

| File | Fungsi Utama |
| :--- | :--- |
| `login.dart` | Memodelkan respons login, termasuk token akses dan ID pengguna. |
| `registrasi.dart` | Memodelkan respons status registrasi. |
| `produk.dart` | Menyimpan atribut produk seperti `kodeProduk`, `namaProduk`, dan `harga`. Memiliki method `fromJson` untuk parsing data. |

### 2. `lib/ui/login_page.dart` & `registrasi_page.dart`

#### Tangkapan Layar (Screenshot)
<img width="495" height="867" alt="Screenshot 2025-11-22 184215" src="https://github.com/user-attachments/assets/0466b04c-25f4-4ccf-8df0-66dd7b1912aa" />
<img width="495" height="867" alt="Screenshot 2025-11-22 184226" src="https://github.com/user-attachments/assets/3a374618-ace8-4056-b674-e17871a42deb" />


Halaman antarmuka untuk akses pengguna.

| Bagian Kode | Penjelasan Fungsi | Poin Kreatif & Perbaikan |
| :--- | :--- | :--- |
| **Validasi Regex** | Memvalidasi format email menggunakan *Regular Expression* (Regex) standar internasional. | Mengganti pola validasi sederhana di modul dengan Regex yang lebih akurat untuk mencegah input email palsu. |
| **Loading State** | Variabel `_isLoading` mengontrol tampilan tombol. | Mengubah tombol menjadi `CircularProgressIndicator` saat proses berjalan, memberikan *feedback* visual yang baik ke pengguna. |
| **Navigasi Aman** | Cek `if (!mounted) return;` setelah proses *async*. | Mencegah *error* umum "Use of BuildContext across async gaps" yang sering terjadi jika user menutup aplikasi saat loading. |

### 3. `lib/ui/produk_page.dart`

#### Tangkapan Layar (Screenshot)
<img width="488" height="863" alt="Screenshot 2025-11-22 184304" src="https://github.com/user-attachments/assets/5892618f-febf-4786-a4b0-99b7895c1430" />

Halaman utama yang menampilkan daftar produk.

| Bagian Kode | Penjelasan Fungsi | Poin Kreatif |
| :--- | :--- | :--- |
| **ListView** | Menampilkan widget `ItemProduk` secara berurutan. | UI disusun rapi menggunakan `Card` dan `ListTile` agar mudah dibaca. |
| **Navigation** | Navigasi ke halaman `ProdukDetail` saat item diklik, dan ke `ProdukForm` saat tombol tambah (+) diklik. | Navigasi intuitif dengan ikon yang jelas di AppBar. |
| **Logout** | Menu Logout di dalam Drawer samping. | Menyediakan akses mudah untuk keluar aplikasi dan kembali ke halaman Login. |

### 4. `lib/ui/produk_form.dart` (Formulir Dinamis)

#### Tangkapan Layar (Screenshot)

<img width="498" height="631" alt="Screenshot 2025-11-22 184324" src="https://github.com/user-attachments/assets/16d7a3e5-4f78-4fc5-a5ab-161fa97f2355" />

Salah satu fitur paling efisien dalam kode ini adalah penggunaan satu halaman untuk dua fungsi.

| Bagian Kode | Penjelasan Fungsi | Poin Kreatif |
| :--- | :--- | :--- |
| **Logika `isUpdate()`** | Mengecek apakah parameter `widget.produk` kosong atau tidak. | **Reusability Code:** Jika data ada, form berubah mode menjadi **"UBAH PRODUK"** dan mengisi kolom otomatis. Jika kosong, mode menjadi **"TAMBAH PRODUK"**. |
| **Dynamic AppBar** | Judul AppBar berubah sesuai mode (`Tambah` vs `Ubah`) + Nama "Alfan". | Memberikan konteks yang jelas kepada pengguna tentang aksi yang sedang mereka lakukan. |

### 5. `lib/ui/produk_detail.dart`

#### Tangkapan Layar (Screenshot)

<img width="494" height="603" alt="Screenshot 2025-11-22 184316" src="https://github.com/user-attachments/assets/fffd93ab-3cbc-452d-a8e7-86a99f04dff5" />
<img width="492" height="648" alt="Screenshot 2025-11-22 184332" src="https://github.com/user-attachments/assets/feddf2ea-0e53-4a46-93be-aeb77e855ee4" />

Halaman untuk melihat rincian dan menghapus produk.

| Bagian Kode | Penjelasan Fungsi | Poin Kreatif |
| :--- | :--- | :--- |
| **Konfirmasi Hapus** | `AlertDialog` muncul saat tombol DELETE ditekan. | **User Experience (UX):** Mencegah penghapusan data yang tidak disengaja dengan meminta konfirmasi ulang "Yakin ingin menghapus data ini?". |
| **Navigasi Edit** | Tombol EDIT mengarahkan ke `ProdukForm` dengan membawa data produk saat ini. | Memastikan data yang akan diedit langsung muncul di form tanpa perlu diketik ulang. |

---
