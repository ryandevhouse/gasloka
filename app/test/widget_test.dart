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

    expect(find.text('Halo, Nadia Putri'), findsOneWidget);
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

  testWidgets('status Kurang diberi label dan penanda visual', (tester) async {
    await tester.pumpWidget(const GaslokaApp());
    await _signInDemo(tester);

    expect(find.text('Kurang'), findsOneWidget);
    expect(find.byIcon(Icons.warning_amber_rounded), findsWidgets);
  });
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
