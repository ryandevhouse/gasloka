# Petunjuk GitHub Copilot untuk Gasloka

- Gasloka adalah aplikasi Android berbahasa Indonesia untuk mencatat dan memantau pengantaran tabung gas. Ikuti spesifikasi di `README.md`.
- Gunakan Flutter/Dart untuk aplikasi Android dan Firebase untuk autentikasi, Cloud Firestore, foto, dan notifikasi. GitHub menyimpan kode dan dapat membangun APK/AAB; jangan anggap GitHub Pages sebagai backend.
- Ada lima role: `admin`, `pengawas`, `agen`, `driver`, `pangkalan`. Admin berjumlah dua akun awal; jumlah role lain tidak dibatasi.
- Semua role dapat membaca seluruh data pengiriman. Tulis dan perubahan harus dibatasi: hanya Admin mengelola akun/role/data referensi; Agen menerima permintaan dan menetapkan Driver; Driver hanya menerima penugasan yang dikirim kepadanya; Pangkalan membuat permintaan dan mengisi penerimaan/bukti pembayaran untuk transaksinya.
- Tegakkan izin di Firebase Security Rules dan/atau fungsi backend. Menyembunyikan tombol di UI saja tidak cukup. Tolak perubahan field yang tidak boleh diedit role tersebut.
- Jangan hardcode, mencetak, atau menyimpan password di Firestore, kode aplikasi, log, contoh, atau repository, termasuk password awal yang diberikan pemilik. Buat dua akun Admin saat provisioning aman di Firebase Authentication/backend; sediakan alur agar Admin dapat mengganti password setelah login. Gunakan Firebase Authentication atau backend tepercaya untuk autentikasi dan operasi Admin. Username perlu dipetakan ke mekanisme autentikasi secara aman; jangan mengirim daftar pemetaan username/email ke semua klien.
- Hanya Admin yang dapat menetapkan atau mengubah harga per tabung. Simpan harga yang berlaku pada setiap pengiriman agar nilai selisih historis tetap konsisten saat harga diperbarui.
- Catat waktu sebagai timestamp server dan simpan riwayat status/perubahan yang relevan. Status dan perhitungan selisih harus bersumber dari data transaksi, bukan nilai yang diketik bebas oleh UI.
- Tampilkan foto Driver bila tersedia dan ilustrasi bawaan Gasloka bila kosong. Status `Kurang` selalu memakai tampilan merah yang juga terbaca oleh pengguna buta warna (sertakan label/ikon, jangan hanya warna).
- Pisahkan antarmuka, model data, validasi, dan akses Firebase. Jaga struktur sederhana dan tangani loading/error/empty state dengan jelas.
- Jika keputusan bisnis belum dijawab di `README.md`, jangan menyembunyikan asumsi di kode. Gunakan asumsi yang dicatat di README dan minta keputusan ketika implementasi akan mengunci perilaku tersebut.
