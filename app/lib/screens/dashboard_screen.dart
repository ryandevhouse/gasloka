import 'package:material_ui/material_ui.dart';

import '../data/demo_data.dart';
import '../models/app_user.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    required this.user,
    required this.onSignOut,
    required this.onRoleSelected,
    super.key,
  });

  final AppUser user;
  final VoidCallback onSignOut;
  final ValueChanged<UserRole> onRoleSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gasloka',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          PopupMenuButton<UserRole>(
            tooltip: 'Ganti peran contoh',
            icon: const Icon(Icons.swap_horiz),
            onSelected: onRoleSelected,
            itemBuilder: (context) => UserRole.values
                .map(
                  (role) => PopupMenuItem(
                    key: ValueKey('role-option-${role.name}'),
                    value: role,
                    child: Row(
                      children: [
                        Icon(role.icon, size: 20),
                        const SizedBox(width: 10),
                        Text(role.label),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
          IconButton(
            tooltip: 'Keluar dari demo',
            onPressed: onSignOut,
            icon: const Icon(Icons.logout),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          _UserWelcome(user: user),
          const SizedBox(height: 18),
          const _DemoBanner(),
          const SizedBox(height: 24),
          _RoleDashboard(role: user.role),
        ],
      ),
    );
  }
}

class _UserWelcome extends StatelessWidget {
  const _UserWelcome({required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: theme.colorScheme.primaryContainer,
          foregroundColor: theme.colorScheme.onPrimaryContainer,
          child: Icon(user.role.icon, size: 28),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Halo, ${user.name}',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    user.role.icon,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    user.role.label,
                    key: ValueKey('current-role-${user.role.name}'),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DemoBanner extends StatelessWidget {
  const _DemoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3D9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          Icon(Icons.science_outlined, color: Color(0xFF805900)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Pratinjau dengan data contoh · belum terhubung ke Firebase',
              style: TextStyle(
                color: Color(0xFF624600),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleDashboard extends StatelessWidget {
  const _RoleDashboard({required this.role});

  final UserRole role;

  @override
  Widget build(BuildContext context) {
    return switch (role) {
      UserRole.admin => const _AdminDashboard(),
      UserRole.pengawas => const _PengawasDashboard(),
      UserRole.agen => const _AgenDashboard(),
      UserRole.driver => const _DriverDashboard(),
      UserRole.pangkalan => const _PangkalanDashboard(),
    };
  }
}

class _AdminDashboard extends StatelessWidget {
  const _AdminDashboard();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeading(
          title: 'Ringkasan operasional',
          subtitle: 'Pantau aktivitas Gasloka hari ini.',
        ),
        const SizedBox(height: 14),
        const _StatGrid(
          items: [
            _StatItem(
              'Pengiriman hari ini',
              '24',
              Icons.local_shipping_outlined,
            ),
            _StatItem('Permintaan baru', '6', Icons.inbox_outlined),
            _StatItem('Driver tersedia', '8', Icons.person_pin_circle_outlined),
            _StatItem('Perlu perhatian', '2', Icons.warning_amber_rounded),
          ],
        ),
        const SizedBox(height: 24),
        const _SectionHeading(title: 'Kelola data'),
        const SizedBox(height: 12),
        _ActionCard(
          icon: Icons.manage_accounts_outlined,
          title: 'Kelola pengguna',
          subtitle: 'Admin, Pengawas, Agen, Driver, dan Pangkalan',
          onTap: () => _showPreviewMessage(context),
        ),
        const SizedBox(height: 10),
        _ActionCard(
          icon: Icons.price_change_outlined,
          title: 'Harga per tabung',
          subtitle: 'Pengaturan contoh hanya untuk Admin',
          onTap: () => _showPreviewMessage(context),
        ),
        const SizedBox(height: 24),
        const _SectionHeading(title: 'Pengiriman terbaru'),
        const SizedBox(height: 12),
        for (final delivery in DemoData.deliveries)
          _DeliveryCard(delivery: delivery),
      ],
    );
  }
}

class _PengawasDashboard extends StatelessWidget {
  const _PengawasDashboard();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeading(
          title: 'Pemantauan pengiriman',
          subtitle: 'Ringkasan status seluruh pengiriman.',
        ),
        const SizedBox(height: 14),
        const _StatGrid(
          items: [
            _StatItem('Dalam perjalanan', '8', Icons.local_shipping_outlined),
            _StatItem('Terkirim', '12', Icons.check_circle_outline),
            _StatItem('Permintaan baru', '6', Icons.inbox_outlined),
            _StatItem('Kurang', '2', Icons.warning_amber_rounded),
          ],
        ),
        const SizedBox(height: 24),
        const _SectionHeading(title: 'Status terkini'),
        const SizedBox(height: 12),
        for (final delivery in DemoData.deliveries)
          _DeliveryCard(delivery: delivery),
      ],
    );
  }
}

class _AgenDashboard extends StatelessWidget {
  const _AgenDashboard();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeading(
          title: 'Permintaan Pangkalan',
          subtitle: 'Tinjau permintaan dan siapkan penugasan Driver.',
        ),
        const SizedBox(height: 14),
        const _StatGrid(
          items: [
            _StatItem('Perlu ditinjau', '6', Icons.inbox_outlined),
            _StatItem('Menunggu Driver', '3', Icons.person_search_outlined),
          ],
        ),
        const SizedBox(height: 24),
        const _SectionHeading(title: 'Permintaan terbaru'),
        const SizedBox(height: 12),
        for (final delivery in DemoData.requests)
          _RequestCard(delivery: delivery),
      ],
    );
  }
}

class _DriverDashboard extends StatelessWidget {
  const _DriverDashboard();

  @override
  Widget build(BuildContext context) {
    final assignment = DemoData.deliveries.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeading(
          title: 'Penugasan saya',
          subtitle: 'Informasi pengiriman untuk Driver.',
        ),
        const SizedBox(height: 14),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Pengiriman aktif',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    _StatusPill(status: assignment.status),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  assignment.baseName,
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                _IconText(
                  icon: Icons.location_on_outlined,
                  text: assignment.address,
                ),
                const SizedBox(height: 12),
                _IconText(
                  icon: Icons.propane_tank_outlined,
                  text: '${assignment.cylinderCount} tabung',
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _showPreviewMessage(context),
                    icon: const Icon(Icons.assignment_turned_in_outlined),
                    label: const Text('Lihat detail penugasan'),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        const _InfoCard(
          icon: Icons.photo_camera_front_outlined,
          title: 'Foto profil Driver',
          message: 'Foto belum tersedia. Ilustrasi ikon bawaan ditampilkan sementara.',
        ),
      ],
    );
  }
}

class _PangkalanDashboard extends StatelessWidget {
  const _PangkalanDashboard();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeading(
          title: 'Pengiriman Pangkalan',
          subtitle: 'Buat permintaan dan pantau penerimaan tabung.',
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => _showRequestDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Buat permintaan pengiriman'),
          ),
        ),
        const SizedBox(height: 24),
        const _SectionHeading(title: 'Riwayat pengiriman'),
        const SizedBox(height: 12),
        for (final delivery in DemoData.deliveries)
          _DeliveryCard(delivery: delivery),
      ],
    );
  }
}

Future<void> _showRequestDialog(BuildContext context) async {
  final cylinderCount = await showDialog<int>(
    context: context,
    builder: (context) => const _RequestDeliveryDialog(),
  );
  if (cylinderCount == null || !context.mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        'Demo: formulir permintaan $cylinderCount tabung selesai. '
        'Data belum disimpan.',
      ),
    ),
  );
}

class _RequestDeliveryDialog extends StatefulWidget {
  const _RequestDeliveryDialog();

  @override
  State<_RequestDeliveryDialog> createState() => _RequestDeliveryDialogState();
}

class _RequestDeliveryDialogState extends State<_RequestDeliveryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _cylinderCountController = TextEditingController();

  @override
  void dispose() {
    _cylinderCountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.of(context).pop(int.parse(_cylinderCountController.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('Form Permintaan Tabung'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Masukkan jumlah tabung yang dibutuhkan.'),
              const SizedBox(height: 16),
              TextFormField(
                key: const ValueKey('request-cylinder-count'),
                controller: _cylinderCountController,
                autofocus: true,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
                decoration: const InputDecoration(
                  labelText: 'Jumlah tabung',
                  hintText: 'Contoh: 12',
                  prefixIcon: Icon(Icons.propane_tank_outlined),
                ),
                validator: (value) {
                  final count = int.tryParse(value?.trim() ?? '');
                  if (count == null) {
                    return 'Masukkan jumlah tabung dengan angka.';
                  }
                  if (count < 1) return 'Jumlah tabung minimal 1.';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Text(
                'Mode demo: permintaan ini belum disimpan.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Kirim permintaan')),
      ],
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.w800),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: const Color(0xFF65736F)),
          ),
        ],
      ],
    );
  }
}

class _StatItem {
  const _StatItem(this.label, this.value, this.icon);

  final String label;
  final String value;
  final IconData icon;
}

class _StatGrid extends StatelessWidget {
  const _StatGrid({required this.items});

  final List<_StatItem> items;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.65,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(item.icon, color: Theme.of(context).colorScheme.primary),
                Text(
                  item.value,
                  style: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                Text(
                  item.label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DeliveryCard extends StatelessWidget {
  const _DeliveryCard({required this.delivery});

  final DemoDelivery delivery;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => showDialog<void>(
          context: context,
          builder: (context) => _DeliveryDetailsDialog(delivery: delivery),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      delivery.baseName,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  _StatusPill(status: delivery.status),
                ],
              ),
              const SizedBox(height: 8),
              _IconText(
                icon: Icons.location_on_outlined,
                text: delivery.address,
              ),
              const SizedBox(height: 6),
              _IconText(
                icon: Icons.propane_tank_outlined,
                text: '${delivery.cylinderCount} tabung',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeliveryDetailsDialog extends StatelessWidget {
  const _DeliveryDetailsDialog({required this.delivery});

  final DemoDelivery delivery;

  @override
  Widget build(BuildContext context) {
    final received = delivery.receivedCylinderCount;
    final isPending = received == null;
    final isShort = delivery.shortageCylinderCount > 0;
    final shortfallValue =
        delivery.shortageCylinderCount * DemoData.standardCylinderPrice;
    final shortfallColor = isShort
        ? const Color(0xFF9B1C16)
        : Theme.of(context).colorScheme.onSurface;

    return AlertDialog(
      scrollable: true,
      title: const Text('Detail Pengiriman'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              delivery.baseName,
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              delivery.address,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: const Color(0xFF65736F)),
            ),
            const SizedBox(height: 12),
            _StatusPill(status: delivery.status),
            const Divider(height: 24),
            _DeliveryDetailRow(
              label: 'Jumlah tabung dikirim',
              value: '${delivery.cylinderCount} tabung',
            ),
            const SizedBox(height: 12),
            _DeliveryDetailRow(
              label: 'Jumlah tabung diterima',
              value: received == null ? 'Belum diterima' : '$received tabung',
            ),
            const SizedBox(height: 12),
            _DeliveryDetailRow(
              label: 'Selisih jumlah tabung',
              value: isPending
                  ? 'Menunggu penerimaan'
                  : '${delivery.shortageCylinderCount} tabung',
              valueColor: shortfallColor,
            ),
            const Divider(height: 24),
            _DeliveryDetailRow(
              label: 'Total harga selisih',
              value: isPending
                  ? 'Belum dihitung'
                  : _formatRupiah(shortfallValue),
              valueColor: shortfallColor,
            ),
            const SizedBox(height: 12),
            _DeliveryDetailRow(
              label: 'Harga per tabung',
              value: _formatRupiah(DemoData.standardCylinderPrice),
            ),
            const SizedBox(height: 16),
            Text(
              'Harga contoh Rp 20.000 per tabung. Data demo tidak disimpan.',
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: const Color(0xFF65736F)),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Tutup'),
        ),
      ],
    );
  }
}

class _DeliveryDetailRow extends StatelessWidget {
  const _DeliveryDetailRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Text(label)),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(color: valueColor, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({required this.delivery});

  final DemoDelivery delivery;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    delivery.baseName,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                _StatusPill(status: delivery.status),
              ],
            ),
            const SizedBox(height: 8),
            _IconText(icon: Icons.location_on_outlined, text: delivery.address),
            const SizedBox(height: 6),
            _IconText(
              icon: Icons.propane_tank_outlined,
              text: '${delivery.cylinderCount} tabung diminta',
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => _showPreviewMessage(context),
                child: const Text('Tinjau permintaan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final DeliveryStatus status;

  @override
  Widget build(BuildContext context) {
    final isShort = status == DeliveryStatus.kurang;
    final background = isShort
        ? const Color(0xFFFFE6E4)
        : const Color(0xFFE9F4F1);
    final foreground = isShort
        ? const Color(0xFF9B1C16)
        : const Color(0xFF176B61);

    return Semantics(
      label: 'Status: ${status.label}',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(status.icon, size: 15, color: foreground),
            const SizedBox(width: 5),
            Text(
              status.label,
              style: TextStyle(
                color: foreground,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(message),
      ),
    );
  }
}

class _IconText extends StatelessWidget {
  const _IconText({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF65736F)),
        const SizedBox(width: 7),
        Expanded(child: Text(text)),
      ],
    );
  }
}

void _showPreviewMessage(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Fitur ini masih berupa pratinjau.')),
  );
}

String _formatRupiah(int value) {
  final groupedValue = value.toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => '.',
  );
  return 'Rp $groupedValue';
}
