# Gasloka

Spesifikasi awal aplikasi manajemen pengantaran tabung gas untuk Android.

## Rancangan teknis yang disarankan

- **Aplikasi Android:** Flutter, agar antarmuka dan alur aplikasi dibuat khusus untuk ponsel Android.
- **Akun dan data langsung:** Firebase Authentication dan Cloud Firestore.
- **Foto bukti pembayaran dan foto Driver:** Firebase Storage.
- **Notifikasi:** Firebase Cloud Messaging, dengan notifikasi saat ada permintaan atau penugasan Driver.
- **Pemeriksaan hak akses:** Firebase Security Rules dan Cloud Functions. Hak akses harus diperiksa di server, bukan hanya dengan menyembunyikan tombol di aplikasi.
- **GitHub:** tempat menyimpan kode, riwayat perubahan, dan konfigurasi build. GitHub Actions dapat dipakai untuk membuat APK/AAB. Firebase menjadi layanan backend untuk akun, data, notifikasi, dan foto.

GitHub Pages saja tidak cukup untuk kebutuhan ini: aplikasi memerlukan autentikasi, data bersama yang berubah langsung, penyimpanan foto privat, serta pemeriksaan izin. APK dapat dibagikan lewat GitHub Releases untuk uji coba; untuk distribusi umum, pertimbangkan Google Play.

## Tipe user dan izin

| Tipe | Jumlah | Izin |
|---|---:|---|
| Admin | 2 akun awal | Melihat semua data; menambah/menghapus user; mengubah password dan tipe user; menetapkan/mengubah harga per tabung; mengelola data Pangkalan dan Driver; mengelola foto Driver. |
| Pengawas | Tidak terbatas | Melihat data saja. |
| Agen | Tidak terbatas | Melihat semua data; menerima permintaan Pangkalan dan memilih Driver yang tersedia. |
| Driver | Tidak terbatas | Melihat semua data; menerima penugasan yang dikirim kepadanya. Tidak dapat mengubah data pengiriman. |
| Pangkalan | Tidak terbatas | Melihat semua data; membuat permintaan; mengisi jumlah yang diterima dan mengunggah bukti transfer untuk pengiriman terkait. |

Semua akun dapat melihat seluruh data sesuai ketentuan awal. Perubahan data dibatasi sesuai role pada tabel. Semua akun memiliki username unik. Setiap dashboard menampilkan tipe user beserta ikon yang sesuai. Foto Driver ditampilkan jika tersedia; jika belum, tampilkan ilustrasi karikatur bawaan aplikasi.

## Alur pengiriman

1. Pangkalan membuat permintaan dengan jumlah tabung dan waktu permintaan.
2. Agen menerima permintaan, menetapkan jumlah yang akan dikirim jika berbeda, lalu memilih Driver.
3. Driver menerima penugasan. Saat Driver menerima, sistem mencatat waktu mulai perjalanan dan status menjadi **Dalam perjalanan**.
4. Pangkalan mencatat jumlah yang diterima dan mengunggah bukti transfer. Sistem menyimpan waktu penerimaan.
5. Jika jumlah diterima sama dengan jumlah yang dikirim, status menjadi **Terkirim**.
6. Jika jumlah diterima lebih sedikit, status menjadi **Kurang**, tampil merah, dan sistem mencatat selisih serta nilai rupiahnya.

Status awal yang disarankan: **Permintaan baru**, **Disetujui**, **Menunggu Driver**, **Dalam perjalanan**, **Terkirim**, **Kurang**, dan **Dibatalkan**. Riwayat perubahan status sebaiknya disimpan agar waktu dan pelakunya dapat ditelusuri.

## Data pengiriman

Setiap pengiriman setidaknya menyimpan:

- ID pengiriman, Pangkalan, alamat tujuan, dan pembuat permintaan.
- Waktu permintaan, jumlah yang diminta, jumlah yang disetujui/dikirim dari Agen.
- Driver yang ditugaskan, nama dan foto Driver, serta waktu Driver menerima/mulai mengantar.
- Waktu Pangkalan mengonfirmasi penerimaan, jumlah tabung diterima, dan jumlah selisih.
- Foto bukti transfer, pengunggah, dan waktu unggah.
- Status, catatan perubahan status, harga per tabung yang berlaku, serta nilai selisih.

Rumus awal: `selisih = max(jumlah_dikirim - jumlah_diterima, 0)` dan `nilai_selisih = selisih × harga_per_tabung`. Admin menetapkan dan dapat mengubah harga per tabung. Simpan harga yang berlaku pada catatan pengiriman agar perubahan harga di masa depan tidak mengubah laporan lama.
Harga standar awal yang dikonfirmasi: **Rp 20.000 per tabung**.

## Koleksi data awal

- `users`: UID autentikasi, username, nama tampilan, role, status aktif, dan waktu pembuatan. Jangan simpan password di Firestore.
- `bases`: nama dan alamat Pangkalan serta akun yang terkait.
- `drivers`: akun Driver, nama, URL foto, dan status ketersediaan.
- `deliveries`: jumlah, tujuan, Driver, status, waktu, bukti pembayaran, selisih, dan harga.
- `delivery_events`: riwayat perubahan status dan pelaku perubahan.

## Keamanan akun

Kredensial Admin awal **jangan dimasukkan ke kode, README, GitHub, atau aplikasi Android**. Buat dua akun Admin lewat Firebase Authentication atau proses penyiapan backend yang aman, lalu izinkan Admin mengganti password dari aplikasi. Perubahan role dan penghapusan user dilakukan melalui fungsi backend berizin Admin. Terapkan aturan Firestore/Storage agar Driver dan Pangkalan hanya dapat mengirim perubahan yang memang menjadi haknya.

## Keputusan yang perlu dikonfirmasi

1. Apakah jumlah tabung yang dikirim selalu sama dengan jumlah pesanan, atau Agen dapat menetapkan jumlah kirim yang berbeda?
2. Apakah foto bukti transfer diunggah Pangkalan (sesuai uraian alur), lalu diperiksa Agen/Admin?

## Tahapan implementasi

1. Buat aplikasi Flutter dan repository GitHub.
2. Siapkan proyek Firebase, autentikasi, basis data, dan penyimpanan foto.
3. Buat login username/password dan dashboard sesuai role.
4. Buat pengelolaan user, Pangkalan, Driver, foto, dan ketersediaan.
5. Buat alur permintaan, persetujuan, penugasan, perjalanan, penerimaan, dan bukti pembayaran.
6. Tambahkan notifikasi, perhitungan selisih, riwayat, dan laporan.
7. Siapkan build Android melalui GitHub Actions dan distribusi APK/AAB.
