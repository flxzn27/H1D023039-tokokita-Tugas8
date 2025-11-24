# H1D023039 - Tugas 9 (Pertemuan 11)
# TokoKita App (Full CRUD + REST API)

Aplikasi Flutter yang terhubung penuh dengan REST API (CodeIgniter 4) menggunakan:
- State Management: BLoC
- HTTP Request: GET, POST, PUT, DELETE
- Session Management: shared_preferences
- Arsitektur UI terpisah dari logika bisnis

# DATA DIRI

Nama   : Alfan Fauzan Ridlo

NIM    : H1D023039

Shift  : B

Shift KRS : C

# FITUR UTAMA

1. REST API Integration (GET, POST, PUT, DELETE)
2. State Management berbasis BLoC
3. Login persistent dengan shared_preferences
4. Error handling (200, 400, 401, 500)
5. UI dinamis + loading indicator

# ALUR APLIKASI & PENJELASAN KODE

# 1. REGISTRASI (SIGN UP)
<img width="494" height="865" alt="Screenshot 2025-11-24 183127" src="https://github.com/user-attachments/assets/3fc19f0d-7ce5-46c8-918e-c25777d70311" />

- User mengisi: Nama, Email, Password  
- Validasi: email valid, password ≥ 6 karakter  
- Data dikirim ke API melalui RegistrasiBloc  

## Kode (UI):

```dart
RegistrasiBloc.registrasi(
    nama: _namaTextboxController.text,
    email: _emailTextboxController.text,
    password: _passwordTextboxController.text)
.then((value) {
    showDialog(
        context: context,
        builder: (context) => SuccessDialog(
            description: "Registrasi berhasil, silahkan login",
        ));
}, onError: (error) {
    showDialog(
        context: context,
        builder: (context) => const WarningDialog(
            description: "Registrasi gagal, silahkan coba lagi",
        ));
});
```

# 2. LOGIN (AUTHENTICATION)
<img width="490" height="864" alt="Screenshot 2025-11-24 183148" src="https://github.com/user-attachments/assets/c51c6031-2382-4720-b746-d19a83d45cbf" />

- User memasukkan Email + Password
- Sistem mengirim request POST ke API login
- Jika code == 200 → token & userID disimpan via shared_preferences
- User langsung diarahkan ke halaman Produk

## BLoC: login_bloc.dart
```dart
static Future<Login> login({String? email, String? password}) async {
    String apiUrl = ApiUrl.login;
    var body = {"email": email, "password": password};
    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    return Login.fromJson(jsonObj);
}
```
## UI: login_page.dart

```dart
if (value.code == 200) {
    await UserInfo().setToken(value.token.toString());
    await UserInfo().setUserID(int.parse(value.userID.toString()));
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const ProdukPage()));
}
```

# 3. LIST PRODUK (READ)
<img width="496" height="863" alt="Screenshot 2025-11-24 183408" src="https://github.com/user-attachments/assets/5512bd43-9751-4ecf-99de-e4d45e665f19" />

<img width="493" height="853" alt="Screenshot 2025-11-24 183427" src="https://github.com/user-attachments/assets/245a1c1f-89e1-4828-9c7b-b9b09ca315c1" />

- Halaman menampilkan data dari API menggunakan GET
- FutureBuilder digunakan untuk load async
- Loading spinner ketika menunggu
- Setelah data masuk → tampil dalam ListView

## BLoC: produk_bloc.dart

```dart
static Future<List<Produk>> getProduks() async {
    String apiUrl = ApiUrl.listProduk;
    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body);
    List<dynamic> listProduk = jsonObj['data'];

    List<Produk> produks = [];
    for (int i = 0; i < listProduk.length; i++) {
        produks.add(Produk.fromJson(listProduk[i]));
    }
    return produks;
}
```

# 4. TAMBAH PRODUK (CREATE)

<img width="496" height="860" alt="Screenshot 2025-11-24 183313" src="https://github.com/user-attachments/assets/61b61ade-3a51-493c-ad5f-ba9b8f43bc46" />

- User mengisi form: Kode Produk, Nama Produk, Harga, dll
- Data dikirim ke API menggunakan POST
- Jika sukses → kembali ke halaman List Produk

## UI: produk_form.dart (Create Mode)

```dart
void simpan() {
    Produk createProduk = Produk(id: null);
    createProduk.kodeProduk = _kodeProdukTextboxController.text;
    createProduk.namaProduk = _namaProdukTextboxController.text;

    ProdukBloc.addProduk(produk: createProduk).then((value) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const ProdukPage()));
    }, onError: (error) {
        // tampilkan dialog error
    });
}
```

# 5. EDIT / UPDATE PRODUK

<img width="490" height="861" alt="Screenshot 2025-11-24 183439" src="https://github.com/user-attachments/assets/fa12b47b-5af1-49c2-9d7a-cfdbe069d1ca" />

<img width="491" height="852" alt="Screenshot 2025-11-24 183453" src="https://github.com/user-attachments/assets/380325f0-7178-4665-85ac-a37bc82528f2" />


- Data lama otomatis tampil pada form
- Setelah diedit → dikirim ke API menggunakan PUT
- Jika update sukses → kembali ke halaman Produk

## BLoC: produk_bloc.dart
```dart
static Future updateProduk({required Produk produk}) async {
    String apiUrl = ApiUrl.updateProduk(produk.id!);

    var body = {
      "kode_produk": produk.kodeProduk,
      "nama_produk": produk.namaProduk,
      "harga": produk.hargaProduk.toString()
    };

    var response = await Api().put(apiUrl, body);
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
}
```

# 6. HAPUS PRODUK (DELETE)

<img width="499" height="863" alt="Screenshot 2025-11-24 183504" src="https://github.com/user-attachments/assets/ed8af0ec-f755-422c-99d6-8a8c66104cc1" />

- User menekan tombol Hapus pada halaman Detail
- Muncul dialog konfirmasi: “Yakin ingin menghapus?”
- Jika "Ya" → API DELETE dipanggil
- Jika sukses → kembali ke List Produk

## UI: produk_detail.dart
```dart
void confirmHapus() {
    AlertDialog alertDialog = AlertDialog(
      content: const Text("Yakin ingin menghapus data ini?"),
      actions: [
        OutlinedButton(
          child: const Text("Ya"),
          onPressed: () {
            ProdukBloc.deleteProduk(id: widget.produk!.id!).then((value) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ProdukPage()));
            });
          },
        ),
        OutlinedButton(
          child: const Text("Batal"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );

    showDialog(context: context, builder: (context) => alertDialog);
}
```

## BLoC (delete)
```dart
static Future deleteProduk({required int id}) async {
    String apiUrl = ApiUrl.deleteProduk(id);
    var response = await Api().delete(apiUrl);
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
}
```
# 7. LOGOUT

<img width="496" height="862" alt="Screenshot 2025-11-24 183419" src="https://github.com/user-attachments/assets/d76d44c4-9fc4-4b09-abfd-4b56d0f2f5b4" />
