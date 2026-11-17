import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:gasloka/main.dart';

void main() {
  testWidgets('login demo membuka dashboard Admin dengan identitas role', (
    tester,
  ) async {
    await tester.pumpWidget(const GaslokaApp());

    expect(find.text('Gasloka'), findsOneWidget);
    expect(find.text('Masuk ke demo'), findsOneWidget);
    expect(find.textContaining('kata sandi tidak diperiksa'), findsOneWidget);

    await _signInDemo(tester, username: 'admin.demo');

    expect(find.text('Halo, Siti'), findsOneWidget);
    expect(find.text('Ringkasan operasional'), findsOneWidget);
    expect(find.text('Kelola pengguna'), findsOneWidget);
  });

  testWidgets('pemilih demo menampilkan dashboard setiap role', (tester) async {
    await tester.pumpWidget(const GaslokaApp());
    await _signInDemo(tester);

    final roleViews = <(String, String)>[
      ('Pengawas', 'Pemantauan pengiriman'),
      ('Agen', 'Permintaan Pangkalan'),
      ('Driver', 'Penugasan saya'),
      ('Pangkalan', 'Pengiriman Pangkalan'),
    ];

    for (final (role, dashboardTitle) in roleViews) {
      await tester.tap(find.byTooltip('Ganti peran contoh'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(role).last);
      await tester.pumpAndSettle();

      expect(find.text(role), findsOneWidget);
      expect(find.text(dashboardTitle), findsOneWidget);
    }

    await tester.tap(find.byTooltip('Ganti peran contoh'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Admin').last);
    await tester.pumpAndSettle();

    expect(find.text('Ringkasan operasional'), findsOneWidget);
  });

  testWidgets(
    'Driver menerima penugasan sendiri dan melihat semua pengiriman',
    (tester) async {
      _useTallViewport(tester);
      await tester.pumpWidget(const GaslokaApp());
      await tester.tap(find.byKey(const ValueKey('login-role')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Driver').last);
      await tester.pumpAndSettle();
      await _signInDemo(tester, username: 'driver.demo');

      expect(find.text('Halo, Budi Santoso'), findsOneWidget);
      expect(
        find.text('Foto belum tersedia · ilustrasi bawaan'),
        findsOneWidget,
      );
      expect(find.text('Pangkalan Sejahtera'), findsOneWidget);
      expect(find.text('Pangkalan Cempaka'), findsOneWidget);
      expect(find.text('Terima penugasan'), findsOneWidget);

      final acceptButton = find.byKey(
        const ValueKey('accept-driver-assignment'),
      );
      await tester.ensureVisible(acceptButton);
      await tester.tap(acceptButton);
      await tester.pumpAndSettle();

      expect(find.text('Terima penugasan'), findsNothing);
      expect(
        find.text('Penugasan sudah diterima. Pengiriman dalam perjalanan.'),
        findsOneWidget,
      );
      expect(
        find.textContaining(
          'Demo: penugasan diterima. Status menjadi Dalam perjalanan',
        ),
        findsOneWidget,
      );
      expect(find.text('Pangkalan Sejahtera'), findsOneWidget);
      expect(find.text('Pangkalan Cempaka'), findsOneWidget);
    },
  );

  testWidgets('status Kurang diberi label dan penanda visual', (tester) async {
    await tester.pumpWidget(const GaslokaApp());
    await _signInDemo(tester);

    expect(find.text('Kurang'), findsOneWidget);
    expect(find.byIcon(Icons.warning_amber_rounded), findsWidgets);
  });

  testWidgets('permintaan Pangkalan membuka form jumlah tabung', (
    tester,
  ) async {
    await tester.pumpWidget(const GaslokaApp());
    await tester.tap(find.byKey(const ValueKey('login-role')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pangkalan').last);
    await tester.pumpAndSettle();
    await _signInDemo(tester);

    await tester.ensureVisible(find.text('Buat permintaan pengiriman'));
    await tester.tap(find.text('Buat permintaan pengiriman'));
    await tester.pumpAndSettle();

    expect(find.text('Form Permintaan Tabung'), findsOneWidget);

    await tester.tap(find.text('Kirim permintaan'));
    await tester.pumpAndSettle();
    expect(find.text('Masukkan jumlah tabung dengan angka.'), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('request-cylinder-count')),
      '0',
    );
    await tester.tap(find.text('Kirim permintaan'));
    await tester.pumpAndSettle();
    expect(find.text('Jumlah tabung minimal 1.'), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('request-cylinder-count')),
      '12',
    );
    await tester.tap(find.text('Kirim permintaan'));
    await tester.pumpAndSettle();

    expect(find.text('Form Permintaan Tabung'), findsNothing);
    expect(
      find.text(
        'Demo: formulir permintaan 12 tabung selesai. Data belum disimpan.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('detail riwayat menghitung harga selisih tabung', (tester) async {
    _useTallViewport(tester);
    await tester.pumpWidget(const GaslokaApp());
    await tester.tap(find.byKey(const ValueKey('login-role')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pangkalan').last);
    await tester.pumpAndSettle();
    await _signInDemo(tester);

    final shortageDelivery = find.text('Pangkalan Cempaka');
    await tester.tap(shortageDelivery);
    await tester.pumpAndSettle();

    expect(find.text('Detail Pengiriman'), findsOneWidget);
    expect(find.text('20 tabung'), findsWidgets);
    expect(find.text('18 tabung'), findsWidgets);
    expect(find.text('2 tabung'), findsOneWidget);
    expect(find.text('Rp 40.000'), findsOneWidget);
    expect(find.text('Rp 20.000'), findsOneWidget);
  });

  testWidgets('detail pengiriman aktif menandai penerimaan belum ada', (
    tester,
  ) async {
    _useTallViewport(tester);
    await tester.pumpWidget(const GaslokaApp());
    await tester.tap(find.byKey(const ValueKey('login-role')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pangkalan').last);
    await tester.pumpAndSettle();
    await _signInDemo(tester);

    final activeDelivery = find.text('Pangkalan Simanjuntak');
    await tester.tap(activeDelivery);
    await tester.pumpAndSettle();

    expect(find.text('Belum diterima'), findsOneWidget);
    expect(find.text('Menunggu penerimaan'), findsOneWidget);
    expect(find.text('Belum dihitung'), findsOneWidget);
  });

  testWidgets('Admin dapat mengubah harga untuk data contoh berikutnya', (
    tester,
  ) async {
    _useTallViewport(tester);
    await tester.pumpWidget(const GaslokaApp());
    await _signInDemo(tester, username: 'admin.demo');

    await tester.tap(find.text('Harga per tabung'));
    await tester.pumpAndSettle();
    expect(find.text('Harga per tabung'), findsNWidgets(2));

    await tester.enterText(
      find.byKey(const ValueKey('admin-cylinder-price')),
      '25000',
    );
    await tester.tap(find.byKey(const ValueKey('save-cylinder-price')));
    await tester.pumpAndSettle();

    expect(find.text('Rp 25.000 · ubah harga berikutnya'), findsOneWidget);
    expect(find.textContaining('Belum disimpan.'), findsOneWidget);
  });

  testWidgets('Admin dapat mengubah role pengguna demo', (tester) async {
    _useTallViewport(tester);
    await tester.pumpWidget(const GaslokaApp());
    await _signInDemo(tester, username: 'admin.demo');

    await tester.tap(find.text('Kelola pengguna'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('edit-user-pengawas.demo')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('admin-user-role')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Driver').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('save-demo-user')));
    await tester.pumpAndSettle();

    expect(find.text('@pengawas.demo · Driver'), findsOneWidget);
    await tester.tap(
      find.byKey(const ValueKey('reset-password-pengawas.demo')),
    );
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Kata sandi tidak disimpan di aplikasi demo.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Mengerti'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Simpan data contoh'));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Data pengguna contoh diperbarui.'),
      findsOneWidget,
    );
  });

  testWidgets('Admin dapat mengubah alamat Pangkalan demo', (tester) async {
    _useTallViewport(tester);
    await tester.pumpWidget(const GaslokaApp());
    await _signInDemo(tester, username: 'admin.demo');

    await tester.tap(find.text('Kelola Pangkalan'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('edit-base-Pangkalan Simanjuntak')),
    );
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('admin-base-address')),
      'Jl. Baru No. 1, Bandung',
    );
    await tester.tap(find.byKey(const ValueKey('save-demo-base')));
    await tester.pumpAndSettle();

    expect(find.text('Jl. Baru No. 1, Bandung'), findsOneWidget);
    await tester.tap(find.text('Simpan data contoh'));
    await tester.pumpAndSettle();
    expect(find.text('3 Pangkalan contoh · nama dan alamat'), findsOneWidget);
  });

  testWidgets('Admin dapat mengatur Driver dan URL foto contoh', (
    tester,
  ) async {
    _useTallViewport(tester);
    await tester.pumpWidget(const GaslokaApp());
    await _signInDemo(tester, username: 'admin.demo');

    await tester.tap(find.text('Kelola Driver'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('edit-driver-driver.andi.demo')),
    );
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('admin-driver-photo')),
      'https://example.com/driver.jpg',
    );
    await tester.tap(find.byKey(const ValueKey('admin-driver-availability')));
    await tester.tap(find.byKey(const ValueKey('save-demo-driver')));
    await tester.pumpAndSettle();

    expect(find.text('@driver.andi.demo · Tersedia'), findsOneWidget);
    await tester.tap(find.text('Simpan data contoh'));
    await tester.pumpAndSettle();
    expect(
      find.text('2 Driver contoh · foto dan ketersediaan'),
      findsOneWidget,
    );
  });

  testWidgets('Agen meninjau permintaan dan menugaskan Driver tersedia', (
    tester,
  ) async {
    _useTallViewport(tester);
    await tester.pumpWidget(const GaslokaApp());
    await tester.tap(find.byKey(const ValueKey('login-role')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Agen').last);
    await tester.pumpAndSettle();
    await _signInDemo(tester, username: 'agen.demo');

    await tester.tap(find.text('Tinjau permintaan').first);
    await tester.pumpAndSettle();

    expect(find.text('Tinjau Permintaan'), findsOneWidget);
    expect(find.text('24 tabung diminta'), findsNWidgets(2));
    expect(
      find.text('Jumlah yang dikirim mengikuti jumlah permintaan.'),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const ValueKey('request-driver-selection')));
    await tester.pumpAndSettle();
    expect(find.text('Budi Santoso'), findsNWidgets(2));
    expect(find.text('Andi Wijaya'), findsNothing);
    await tester.tap(find.text('Budi Santoso').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('accept-request-assignment')));
    await tester.pumpAndSettle();

    expect(find.text('Menunggu Driver'), findsOneWidget);
    expect(
      find.text('Demo: Pangkalan Simanjuntak ditugaskan kepada Budi Santoso.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Lihat penugasan').first);
    await tester.pumpAndSettle();
    expect(find.text('Detail Penugasan'), findsOneWidget);
    expect(find.text('Driver: Budi Santoso'), findsOneWidget);
    await tester.tap(find.text('Tutup'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Ganti peran contoh'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Driver').last);
    await tester.pumpAndSettle();

    expect(find.text('Pangkalan Simanjuntak'), findsNWidgets(4));
    expect(find.text('Terima penugasan'), findsNWidgets(2));
  });
}

void _useTallViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 1200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Future<void> _signInDemo(
  WidgetTester tester, {
  String username = 'contoh',
}) async {
  await tester.enterText(
    find.byKey(const ValueKey('login-username')),
    username,
  );
  await tester.enterText(
    find.byKey(const ValueKey('login-password')),
    'contoh',
  );
  final signInButton = find.text('Masuk ke demo');
  await tester.ensureVisible(signInButton);
  await tester.tap(signInButton);
  await tester.pumpAndSettle();
}
