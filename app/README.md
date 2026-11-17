# Gasloka

Pratinjau web Flutter berbahasa Indonesia untuk aplikasi pengantaran tabung gas.
Build ini hanya memakai data contoh lokal dan tidak terhubung ke Firebase.

## Menjalankan aplikasi

```sh
flutter run
```

Untuk menjalankan di browser desktop:

```sh
flutter run -d chrome
```

Untuk build web lokal:

```sh
flutter build web --release
```

## Deploy gratis ke GitHub Pages

GitHub Pages hanya meng-host frontend statis; tidak ada autentikasi atau backend
dalam pratinjau ini. Karena situs Pages dapat diakses publik, jangan menaruh
data nyata atau rahasia di aplikasi. Aksi pengguna dan data contoh bukan sistem
transaksi.

1. Gunakan repository GitHub publik dan branch default bernama `main`.
2. Pada **Settings → Pages**, pilih **GitHub Actions** sebagai sumber deploy.
3. Push perubahan ke `main`. Workflow
   [deploy-pages.yml](../.github/workflows/deploy-pages.yml) membangun Flutter
   web dan menerbitkan `app/build/web`.

Workflow menyesuaikan `base-href` dengan nama repository untuk URL project
GitHub Pages. Hosting GitHub Pages tersedia tanpa biaya untuk repository publik;
custom domain (jika dipilih) dapat memerlukan biaya dari registrar domain.

## Pratinjau antarmuka

- Layar login dan dashboard menggunakan data contoh lokal.
- Dashboard Admin dapat menambah, mengedit, dan menghapus data contoh pengguna,
  Pangkalan, dan Driver, termasuk role, alamat, ketersediaan, dan URL foto
  Driver. Harga per tabung juga dapat diubah pada sesi demo.
- Perubahan tersebut hanya tersimpan sementara di tampilan demo dan hilang saat
  sesi dimulai ulang. Belum ada database atau autentikasi; pengaturan password
  hanya menampilkan informasi dan tidak meminta atau menyimpan password.
- Detail riwayat menampilkan jumlah dikirim/diterima, selisih, dan nilai
  selisih dengan harga contoh Rp 20.000 per tabung. Harga ini hanya untuk demo.
- Pilih salah satu dari lima role pada layar login. Dari dashboard, gunakan
  tombol ganti peran untuk melihat tampilan Admin, Pengawas, Agen, Driver, dan
  Pangkalan.
- Kata sandi pada layar login hanya untuk simulasi: tidak diverifikasi,
  dikirim, atau disimpan. Jangan masukkan kredensial sungguhan.
- Tombol aksi menampilkan pemberitahuan pratinjau; autentikasi dan Firebase
  belum dihubungkan.

Antarmuka menggunakan `material_ui`, dependency yang sudah ada pada proyek untuk
API Material di versi Flutter yang digunakan. Tidak ada dependency baru yang
ditambahkan. Build web statis tidak memakai Firebase atau layanan backend
berbayar.
