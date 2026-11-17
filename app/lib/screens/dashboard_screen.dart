import 'package:material_ui/material_ui.dart';

import '../data/demo_data.dart';
import '../models/app_user.dart';
import '../models/reference_data.dart';
import 'admin_data_dialogs.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    required this.user,
    required this.onSignOut,
    required this.deliveries,
    required this.onDeliveryAdded,
    required this.onDeliveryUpdated,
    super.key,
  });

  final AppUser user;
  final VoidCallback onSignOut;
  final List<DemoDelivery> deliveries;
  final ValueChanged<DemoDelivery> onDeliveryAdded;
  final void Function(DemoDelivery updated, DemoDelivery previous)
  onDeliveryUpdated;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gasloka',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
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
          _RoleDashboard(
            role: user.role,
            user: user,
            deliveries: deliveries,
            onDeliveryAdded: onDeliveryAdded,
            onDeliveryUpdated: onDeliveryUpdated,
          ),
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
  const _RoleDashboard({
    required this.role,
    required this.user,
    required this.deliveries,
    required this.onDeliveryAdded,
    required this.onDeliveryUpdated,
  });

  final UserRole role;
  final AppUser user;
  final List<DemoDelivery> deliveries;
  final ValueChanged<DemoDelivery> onDeliveryAdded;
  final void Function(DemoDelivery updated, DemoDelivery previous)
  onDeliveryUpdated;

  @override
  Widget build(BuildContext context) {
    return switch (role) {
      UserRole.admin => _AdminDashboard(deliveries: deliveries),
      UserRole.pengawas => _PengawasDashboard(deliveries: deliveries),
      UserRole.agen => _AgenDashboard(
        deliveries: deliveries,
        onDeliveryAdded: onDeliveryAdded,
      ),
      UserRole.driver => _DriverDashboard(
        user: user,
        deliveries: deliveries,
        onDeliveryUpdated: onDeliveryUpdated,
      ),
      UserRole.pangkalan => _PangkalanDashboard(deliveries: deliveries),
    };
  }
}

class _AdminDashboard extends StatefulWidget {
  const _AdminDashboard({required this.deliveries});

  final List<DemoDelivery> deliveries;

  @override
  State<_AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<_AdminDashboard> {
  late List<AppUser> _users = List.of(DemoData.adminUsers);
  late List<DemoBase> _bases = List.of(DemoData.bases);
  late List<DemoDriver> _drivers = List.of(DemoData.drivers);
  int _cylinderPrice = DemoData.standardCylinderPrice;

  Future<void> _manageUsers() async {
    final users = await showUserManagementDialog(context, _users);
    if (users == null || !mounted) return;
    setState(() => _users = users);
    _showSavedMessage('Data pengguna contoh diperbarui.');
  }

  Future<void> _manageBases() async {
    final bases = await showBaseManagementDialog(context, _bases);
    if (bases == null || !mounted) return;
    setState(() => _bases = bases);
    _showSavedMessage('Data Pangkalan contoh diperbarui.');
  }

  Future<void> _manageDrivers() async {
    final drivers = await showDriverManagementDialog(context, _drivers);
    if (drivers == null || !mounted) return;
    setState(() => _drivers = drivers);
    _showSavedMessage('Data Driver contoh diperbarui.');
  }

  Future<void> _editCylinderPrice() async {
    final price = await showCylinderPriceDialog(context, _cylinderPrice);
    if (price == null || !mounted) return;
    setState(() => _cylinderPrice = price);
    _showSavedMessage(
      'Harga contoh diperbarui menjadi ${_formatRupiah(price)}.',
    );
  }

  void _showSavedMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Demo: $message Belum disimpan.')));
  }

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
          subtitle: '${_users.length} pengguna contoh · kelola nama dan role',
          onTap: _manageUsers,
        ),
        const SizedBox(height: 10),
        _ActionCard(
          icon: Icons.storefront_outlined,
          title: 'Kelola Pangkalan',
          subtitle: '${_bases.length} Pangkalan contoh · nama dan alamat',
          onTap: _manageBases,
        ),
        const SizedBox(height: 10),
        _ActionCard(
          icon: Icons.local_shipping_outlined,
          title: 'Kelola Driver',
          subtitle: '${_drivers.length} Driver contoh · foto dan ketersediaan',
          onTap: _manageDrivers,
        ),
        const SizedBox(height: 10),
        _ActionCard(
          icon: Icons.price_change_outlined,
          title: 'Harga per tabung',
          subtitle: '${_formatRupiah(_cylinderPrice)} · ubah harga berikutnya',
          onTap: _editCylinderPrice,
        ),
        const SizedBox(height: 24),
        const _SectionHeading(title: 'Pengiriman terbaru'),
        const SizedBox(height: 12),
        for (final delivery in widget.deliveries)
          _DeliveryCard(delivery: delivery),
      ],
    );
  }
}

class _PengawasDashboard extends StatelessWidget {
  const _PengawasDashboard({required this.deliveries});

  final List<DemoDelivery> deliveries;

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
        for (final delivery in deliveries) _DeliveryCard(delivery: delivery),
      ],
    );
  }
}

class _AgenDashboard extends StatefulWidget {
  const _AgenDashboard({
    required this.deliveries,
    required this.onDeliveryAdded,
  });

  final List<DemoDelivery> deliveries;
  final ValueChanged<DemoDelivery> onDeliveryAdded;

  @override
  State<_AgenDashboard> createState() => _AgenDashboardState();
}

class _AgenDashboardState extends State<_AgenDashboard> {
  late final List<DemoDelivery> _requests = List.of(DemoData.requests);
  late final List<DemoDriver> _drivers = List.of(
    DemoData.drivers.where((driver) => driver.available),
  );

  Future<void> _reviewRequest(DemoDelivery delivery) async {
    final driver = await showDialog<DemoDriver>(
      context: context,
      builder: (context) =>
          _RequestReviewDialog(delivery: delivery, availableDrivers: _drivers),
    );
    if (driver == null || !mounted) return;

    final index = _requests.indexOf(delivery);
    if (index < 0) return;
    final assignedDelivery = DemoDelivery(
      baseName: delivery.baseName,
      address: delivery.address,
      cylinderCount: delivery.cylinderCount,
      status: DeliveryStatus.menungguDriver,
      assignedDriverName: driver.name,
    );
    setState(() {
      _requests[index] = assignedDelivery;
    });
    widget.onDeliveryAdded(assignedDelivery);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Demo: ${delivery.baseName} ditugaskan kepada ${driver.name}.',
        ),
      ),
    );
  }

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
        _StatGrid(
          items: [
            const _StatItem('Perlu ditinjau', '2', Icons.inbox_outlined),
            _StatItem(
              'Driver tersedia',
              '${_drivers.length}',
              Icons.person_search_outlined,
            ),
          ],
        ),
        const SizedBox(height: 24),
        const _SectionHeading(title: 'Permintaan terbaru'),
        const SizedBox(height: 12),
        for (final delivery in _requests)
          _RequestCard(
            delivery: delivery,
            onReview: () => _reviewRequest(delivery),
          ),
      ],
    );
  }
}

class _RequestReviewDialog extends StatefulWidget {
  const _RequestReviewDialog({
    required this.delivery,
    required this.availableDrivers,
  });

  final DemoDelivery delivery;
  final List<DemoDriver> availableDrivers;

  @override
  State<_RequestReviewDialog> createState() => _RequestReviewDialogState();
}

class _RequestReviewDialogState extends State<_RequestReviewDialog> {
  String? _selectedDriverUsername;

  bool get _isAssigned =>
      widget.delivery.status == DeliveryStatus.menungguDriver;

  @override
  void initState() {
    super.initState();
    if (widget.availableDrivers.isNotEmpty) {
      _selectedDriverUsername = widget.availableDrivers.first.username;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedDriver = widget.availableDrivers
        .where((driver) => driver.username == _selectedDriverUsername)
        .firstOrNull;

    return AlertDialog(
      scrollable: true,
      title: Text(_isAssigned ? 'Detail Penugasan' : 'Tinjau Permintaan'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.delivery.baseName,
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            _IconText(
              icon: Icons.location_on_outlined,
              text: widget.delivery.address,
            ),
            const SizedBox(height: 8),
            _IconText(
              icon: Icons.propane_tank_outlined,
              text: '${widget.delivery.cylinderCount} tabung diminta',
            ),
            const SizedBox(height: 12),
            const _DemoBanner(),
            const SizedBox(height: 16),
            if (_isAssigned)
              _IconText(
                icon: Icons.local_shipping_outlined,
                text: 'Driver: ${widget.delivery.assignedDriverName}',
              )
            else if (widget.availableDrivers.isEmpty)
              const _InfoCard(
                icon: Icons.person_off_outlined,
                title: 'Belum ada Driver tersedia',
                message:
                    'Data Driver demo belum memiliki Driver yang tersedia.',
              )
            else
              DropdownButtonFormField<String>(
                key: const ValueKey('request-driver-selection'),
                initialValue: _selectedDriverUsername,
                decoration: const InputDecoration(
                  labelText: 'Pilih Driver tersedia',
                  prefixIcon: Icon(Icons.local_shipping_outlined),
                ),
                items: widget.availableDrivers
                    .map(
                      (driver) => DropdownMenuItem(
                        value: driver.username,
                        child: Text(driver.name),
                      ),
                    )
                    .toList(),
                onChanged: (username) {
                  setState(() => _selectedDriverUsername = username);
                },
              ),
            const SizedBox(height: 12),
            const Text(
              'Jumlah yang dikirim mengikuti jumlah permintaan.',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(_isAssigned ? 'Tutup' : 'Batal'),
        ),
        if (!_isAssigned)
          FilledButton(
            key: const ValueKey('accept-request-assignment'),
            onPressed: selectedDriver == null
                ? null
                : () => Navigator.of(context).pop(selectedDriver),
            child: const Text('Terima & tugaskan Driver'),
          ),
      ],
    );
  }
}

class _DriverDashboard extends StatefulWidget {
  const _DriverDashboard({
    required this.user,
    required this.deliveries,
    required this.onDeliveryUpdated,
  });

  final AppUser user;
  final List<DemoDelivery> deliveries;
  final void Function(DemoDelivery updated, DemoDelivery previous)
  onDeliveryUpdated;

  @override
  State<_DriverDashboard> createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<_DriverDashboard> {
  List<DemoDelivery> get _myAssignments => widget.deliveries
      .where((delivery) => delivery.assignedDriverName == widget.user.name)
      .toList();

  void _acceptAssignment(DemoDelivery delivery) {
    if (delivery.assignedDriverName != widget.user.name ||
        delivery.status != DeliveryStatus.menungguDriver) {
      return;
    }

    final updatedDelivery = DemoDelivery(
      baseName: delivery.baseName,
      address: delivery.address,
      cylinderCount: delivery.cylinderCount,
      status: DeliveryStatus.dalamPerjalanan,
      receivedCylinderCount: delivery.receivedCylinderCount,
      pricePerCylinder: delivery.pricePerCylinder,
      assignedDriverName: delivery.assignedDriverName,
    );
    widget.onDeliveryUpdated(updatedDelivery, delivery);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Demo: penugasan diterima. Status menjadi Dalam perjalanan; '
          'perubahan belum disimpan.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final matchingDrivers = DemoData.drivers.where(
      (driver) => driver.username == widget.user.username,
    );
    final driverProfile = matchingDrivers.isEmpty
        ? null
        : matchingDrivers.first;
    final myAssignments = _myAssignments;
    final waitingForAcceptance = myAssignments
        .where((delivery) => delivery.status == DeliveryStatus.menungguDriver)
        .length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DriverProfileCard(user: widget.user, driver: driverProfile),
        const SizedBox(height: 20),
        const _SectionHeading(
          title: 'Ringkasan penugasan',
          subtitle: 'Anda dapat melihat seluruh pengiriman.',
        ),
        const SizedBox(height: 14),
        _StatGrid(
          items: [
            _StatItem(
              'Penugasan untuk saya',
              '${myAssignments.length}',
              Icons.assignment_outlined,
            ),
            _StatItem(
              'Perlu diterima',
              '$waitingForAcceptance',
              Icons.move_to_inbox_outlined,
            ),
            _StatItem(
              'Semua pengiriman',
              '${widget.deliveries.length}',
              Icons.local_shipping_outlined,
            ),
            const _StatItem('Hak akses', 'Lihat', Icons.visibility_outlined),
          ],
        ),
        const SizedBox(height: 24),
        const _SectionHeading(
          title: 'Penugasan saya',
          subtitle:
              'Hanya penugasan yang dikirim kepada Anda yang dapat diterima.',
        ),
        const SizedBox(height: 12),
        if (myAssignments.isEmpty)
          const _InfoCard(
            icon: Icons.inbox_outlined,
            title: 'Belum ada penugasan',
            message: 'Penugasan baru akan muncul di bagian ini.',
          )
        else
          for (final assignment in myAssignments)
            _DriverAssignmentCard(
              delivery: assignment,
              onAccept: () => _acceptAssignment(assignment),
            ),
        const SizedBox(height: 24),
        const _SectionHeading(
          title: 'Semua pengiriman',
          subtitle: 'Informasi pengiriman bersifat baca saja.',
        ),
        const SizedBox(height: 12),
        for (final delivery in widget.deliveries)
          _DeliveryCard(delivery: delivery),
      ],
    );
  }
}

class _DriverProfileCard extends StatelessWidget {
  const _DriverProfileCard({required this.user, required this.driver});

  final AppUser user;
  final DemoDriver? driver;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _DriverProfileAvatar(photoUrl: driver?.photoUrl ?? ''),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  const _IconText(
                    icon: Icons.local_shipping_outlined,
                    text: 'Akun pengemudi',
                  ),
                  const SizedBox(height: 4),
                  Text(
                    driver?.photoUrl.isNotEmpty == true
                        ? 'Foto profil Driver'
                        : 'Foto belum tersedia · ilustrasi bawaan',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DriverProfileAvatar extends StatelessWidget {
  const _DriverProfileAvatar({required this.photoUrl});

  final String photoUrl;

  @override
  Widget build(BuildContext context) {
    const size = 58.0;
    final fallback = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Icon(
        Icons.local_shipping_outlined,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
        size: 30,
      ),
    );
    if (photoUrl.isEmpty) return fallback;

    return ClipOval(
      child: Image.network(
        photoUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => fallback,
      ),
    );
  }
}

class _DriverAssignmentCard extends StatelessWidget {
  const _DriverAssignmentCard({required this.delivery, required this.onAccept});

  final DemoDelivery delivery;
  final VoidCallback onAccept;

  @override
  Widget build(BuildContext context) {
    final needsAcceptance = delivery.status == DeliveryStatus.menungguDriver;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
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
            const SizedBox(height: 10),
            _IconText(icon: Icons.location_on_outlined, text: delivery.address),
            const SizedBox(height: 6),
            _IconText(
              icon: Icons.propane_tank_outlined,
              text: '${delivery.cylinderCount} tabung',
            ),
            const SizedBox(height: 14),
            if (needsAcceptance)
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  key: const ValueKey('accept-driver-assignment'),
                  onPressed: onAccept,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Terima penugasan'),
                ),
              )
            else
              const _IconText(
                icon: Icons.info_outline,
                text: 'Penugasan sudah diterima. Pengiriman dalam perjalanan.',
              ),
          ],
        ),
      ),
    );
  }
}

class _PangkalanDashboard extends StatelessWidget {
  const _PangkalanDashboard({required this.deliveries});

  final List<DemoDelivery> deliveries;

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
        for (final delivery in deliveries) _DeliveryCard(delivery: delivery),
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
        delivery.shortageCylinderCount * delivery.pricePerCylinder;
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
              value: _formatRupiah(delivery.pricePerCylinder),
            ),
            const SizedBox(height: 16),
            Text(
              'Harga yang tersimpan untuk pengiriman ini. '
              'Data demo tidak disimpan.',
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
  const _RequestCard({required this.delivery, required this.onReview});

  final DemoDelivery delivery;
  final VoidCallback onReview;

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
                onPressed: onReview,
                child: Text(
                  delivery.status == DeliveryStatus.menungguDriver
                      ? 'Lihat penugasan'
                      : 'Tinjau permintaan',
                ),
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

String _formatRupiah(int value) {
  final groupedValue = value.toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => '.',
  );
  return 'Rp $groupedValue';
}
