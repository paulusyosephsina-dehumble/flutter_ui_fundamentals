
# Proyek Pemrograman Mobile

**Developer:** Paulus Yoseph Sina
**NIM:** 2415051077
**Status:** Proyek awal perkuliahan

## Getting Started

Proyek ini merupakan aplikasi Flutter yang dikembangkan untuk memenuhi tugas mata kuliah Pemrograman Berbasis Mobile.

Dokumentasi resmi Flutter:
- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

## Tahap 1 — Membaca REST Endpoint dan JSON

### Informasi Endpoint

- **Nama API:** JSONPlaceholder
- **Resource:** Posts
- **Endpoint:** https://jsonplaceholder.typicode.com/posts
- **HTTP Method:** GET
- **Status Code:** 200 OK
- **Format respons:** JSON berupa daftar objek post
- **Alat pengujian:** PowerShell

### Struktur JSON

Objek respons memiliki empat field utama:

1. `userId`: ID pengguna pemilik post.
2. `id`: ID post.
3. `title`: Judul post.
4. `body`: Isi post.

### Catatan Pengujian

Endpoint diuji menggunakan HTTP GET melalui PowerShell. Hasil pengujian menunjukkan status code 200 OK, yang menandakan bahwa permintaan berhasil diproses. Respons server berisi data dalam format JSON berupa daftar objek post dengan field `userId`, `id`, `title`, dan `body`.

JSONPlaceholder digunakan sebagai API latihan. Operasi tulis pada layanan ini bersifat simulasi sehingga perubahan data tidak disimpan secara permanen. Oleh karena itu, layanan ini digunakan untuk mempelajari struktur respons REST API, bukan sebagai database permanen aplikasi Course Data Manager.
