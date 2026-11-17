import 'package:material_ui/material_ui.dart';

import '../models/app_user.dart';
import '../models/reference_data.dart';

Future<List<AppUser>?> showUserManagementDialog(
  BuildContext context,
  List<AppUser> users,
) {
  return showDialog<List<AppUser>>(
    context: context,
    builder: (_) => _UserManagementDialog(users: users),
  );
}

Future<List<DemoBase>?> showBaseManagementDialog(
  BuildContext context,
  List<DemoBase> bases,
) {
  return showDialog<List<DemoBase>>(
    context: context,
    builder: (_) => _BaseManagementDialog(bases: bases),
  );
}

Future<List<DemoDriver>?> showDriverManagementDialog(
  BuildContext context,
  List<DemoDriver> drivers,
) {
  return showDialog<List<DemoDriver>>(
    context: context,
    builder: (_) => _DriverManagementDialog(drivers: drivers),
  );
}

Future<int?> showCylinderPriceDialog(BuildContext context, int currentPrice) {
  return showDialog<int>(
    context: context,
    builder: (_) => _CylinderPriceDialog(currentPrice: currentPrice),
  );
}

class _UserManagementDialog extends StatefulWidget {
  const _UserManagementDialog({required this.users});

  final List<AppUser> users;

  @override
  State<_UserManagementDialog> createState() => _UserManagementDialogState();
}

class _UserManagementDialogState extends State<_UserManagementDialog> {
  late final List<AppUser> _users = List.of(widget.users);

  Future<void> _editUser([AppUser? user]) async {
    final result = await showDialog<AppUser>(
      context: context,
      builder: (_) => _UserFormDialog(
        user: user,
        existingUsernames: _users.map((item) => item.username).toSet(),
      ),
    );
    if (result == null || !mounted) return;

    setState(() {
      if (user == null) {
        _users.add(result);
      } else {
        _users[_users.indexOf(user)] = result;
      }
    });
  }

  Future<void> _removeUser(AppUser user) async {
    final confirmed = await _confirmDelete(
      context,
      'Hapus ${user.name} dari data contoh?',
    );
    if (confirmed && mounted) setState(() => _users.remove(user));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Kelola pengguna'),
      content: SizedBox(
        width: 520,
        height: 400,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                key: const ValueKey('add-demo-user'),
                onPressed: () => _editUser(),
                icon: const Icon(Icons.person_add_alt_1),
                label: const Text('Tambah pengguna'),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final user = _users[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(child: Icon(user.role.icon)),
                    title: Text(user.name),
                    subtitle: Text('@${user.username} · ${user.role.label}'),
                    trailing: Wrap(
                      spacing: 0,
                      children: [
                        IconButton(
                          key: ValueKey('edit-user-${user.username}'),
                          tooltip: 'Edit ${user.name}',
                          onPressed: () => _editUser(user),
                          icon: const Icon(Icons.edit_outlined),
                        ),
                        IconButton(
                          key: ValueKey('reset-password-${user.username}'),
                          tooltip: 'Atur ulang kata sandi ${user.name}',
                          onPressed: () => _showPasswordResetNotice(context),
                          icon: const Icon(Icons.lock_reset_outlined),
                        ),
                        IconButton(
                          key: ValueKey('delete-user-${user.username}'),
                          tooltip: 'Hapus ${user.name}',
                          onPressed: () => _removeUser(user),
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_users),
          child: const Text('Simpan data contoh'),
        ),
      ],
    );
  }
}

class _UserFormDialog extends StatefulWidget {
  const _UserFormDialog({required this.existingUsernames, this.user});

  final AppUser? user;
  final Set<String> existingUsernames;

  @override
  State<_UserFormDialog> createState() => _UserFormDialogState();
}

class _UserFormDialogState extends State<_UserFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(
    text: widget.user?.name ?? '',
  );
  late final _usernameController = TextEditingController(
    text: widget.user?.username ?? '',
  );
  late UserRole _role = widget.user?.role ?? UserRole.pengawas;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.of(context).pop(
      AppUser(
        name: _nameController.text.trim(),
        username: _usernameController.text.trim(),
        role: _role,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text(widget.user == null ? 'Tambah pengguna' : 'Edit pengguna'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              key: const ValueKey('admin-user-name'),
              controller: _nameController,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Nama lengkap'),
              validator: _requiredValidator,
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const ValueKey('admin-user-username'),
              controller: _usernameController,
              autocorrect: false,
              decoration: const InputDecoration(labelText: 'Nama pengguna'),
              validator: (value) {
                final username = value?.trim() ?? '';
                if (username.isEmpty) return 'Nama pengguna wajib diisi.';
                final isDuplicate = widget.existingUsernames.any(
                  (existing) =>
                      existing.toLowerCase() == username.toLowerCase() &&
                      existing.toLowerCase() !=
                          widget.user?.username.toLowerCase(),
                );
                if (isDuplicate) return 'Nama pengguna sudah digunakan.';
                return null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<UserRole>(
              key: const ValueKey('admin-user-role'),
              initialValue: _role,
              decoration: const InputDecoration(labelText: 'Tipe pengguna'),
              items: UserRole.values
                  .map(
                    (role) =>
                        DropdownMenuItem(value: role, child: Text(role.label)),
                  )
                  .toList(),
              onChanged: (role) {
                if (role != null) setState(() => _role = role);
              },
            ),
            const SizedBox(height: 12),
            const _DemoOnlyNotice(
              message: 'Data akun ini hanya contoh. Kata sandi tidak diminta atau disimpan.',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        FilledButton(
          key: const ValueKey('save-demo-user'),
          onPressed: _save,
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}

class _BaseManagementDialog extends StatefulWidget {
  const _BaseManagementDialog({required this.bases});

  final List<DemoBase> bases;

  @override
  State<_BaseManagementDialog> createState() => _BaseManagementDialogState();
}

class _BaseManagementDialogState extends State<_BaseManagementDialog> {
  late final List<DemoBase> _bases = List.of(widget.bases);

  Future<void> _editBase([DemoBase? base]) async {
    final result = await showDialog<DemoBase>(
      context: context,
      builder: (_) => _BaseFormDialog(
        base: base,
        existingNames: _bases.map((item) => item.name).toSet(),
      ),
    );
    if (result == null || !mounted) return;

    setState(() {
      if (base == null) {
        _bases.add(result);
      } else {
        _bases[_bases.indexOf(base)] = result;
      }
    });
  }

  Future<void> _removeBase(DemoBase base) async {
    final confirmed = await _confirmDelete(
      context,
      'Hapus ${base.name} dari data contoh?',
    );
    if (confirmed && mounted) setState(() => _bases.remove(base));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Kelola Pangkalan'),
      content: SizedBox(
        width: 520,
        height: 400,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                key: const ValueKey('add-demo-base'),
                onPressed: () => _editBase(),
                icon: const Icon(Icons.add_business_outlined),
                label: const Text('Tambah Pangkalan'),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _bases.length,
                itemBuilder: (context, index) {
                  final base = _bases[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(
                      child: Icon(Icons.storefront_outlined),
                    ),
                    title: Text(base.name),
                    subtitle: Text(base.address),
                    trailing: Wrap(
                      children: [
                        IconButton(
                          key: ValueKey('edit-base-${base.name}'),
                          tooltip: 'Edit ${base.name}',
                          onPressed: () => _editBase(base),
                          icon: const Icon(Icons.edit_outlined),
                        ),
                        IconButton(
                          key: ValueKey('delete-base-${base.name}'),
                          tooltip: 'Hapus ${base.name}',
                          onPressed: () => _removeBase(base),
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_bases),
          child: const Text('Simpan data contoh'),
        ),
      ],
    );
  }
}

class _BaseFormDialog extends StatefulWidget {
  const _BaseFormDialog({required this.existingNames, this.base});

  final DemoBase? base;
  final Set<String> existingNames;

  @override
  State<_BaseFormDialog> createState() => _BaseFormDialogState();
}

class _BaseFormDialogState extends State<_BaseFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(
    text: widget.base?.name ?? '',
  );
  late final _addressController = TextEditingController(
    text: widget.base?.address ?? '',
  );

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.of(context).pop(
      DemoBase(
        name: _nameController.text.trim(),
        address: _addressController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text(widget.base == null ? 'Tambah Pangkalan' : 'Edit Pangkalan'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              key: const ValueKey('admin-base-name'),
              controller: _nameController,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Nama Pangkalan'),
              validator: (value) {
                final error = _requiredValidator(value);
                if (error != null) return error;
                final name = value!.trim();
                final duplicate = widget.existingNames.any(
                  (existing) =>
                      existing.toLowerCase() == name.toLowerCase() &&
                      existing.toLowerCase() != widget.base?.name.toLowerCase(),
                );
                return duplicate ? 'Nama Pangkalan sudah digunakan.' : null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const ValueKey('admin-base-address'),
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Alamat'),
              validator: _requiredValidator,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        FilledButton(
          key: const ValueKey('save-demo-base'),
          onPressed: _save,
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}

class _DriverManagementDialog extends StatefulWidget {
  const _DriverManagementDialog({required this.drivers});

  final List<DemoDriver> drivers;

  @override
  State<_DriverManagementDialog> createState() =>
      _DriverManagementDialogState();
}

class _DriverManagementDialogState extends State<_DriverManagementDialog> {
  late final List<DemoDriver> _drivers = List.of(widget.drivers);

  Future<void> _editDriver([DemoDriver? driver]) async {
    final result = await showDialog<DemoDriver>(
      context: context,
      builder: (_) => _DriverFormDialog(
        driver: driver,
        existingUsernames: _drivers.map((item) => item.username).toSet(),
      ),
    );
    if (result == null || !mounted) return;

    setState(() {
      if (driver == null) {
        _drivers.add(result);
      } else {
        _drivers[_drivers.indexOf(driver)] = result;
      }
    });
  }

  Future<void> _removeDriver(DemoDriver driver) async {
    final confirmed = await _confirmDelete(
      context,
      'Hapus ${driver.name} dari data contoh?',
    );
    if (confirmed && mounted) setState(() => _drivers.remove(driver));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Kelola Driver'),
      content: SizedBox(
        width: 520,
        height: 400,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                key: const ValueKey('add-demo-driver'),
                onPressed: () => _editDriver(),
                icon: const Icon(Icons.person_add_alt_1),
                label: const Text('Tambah Driver'),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _drivers.length,
                itemBuilder: (context, index) {
                  final driver = _drivers[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: _DriverAvatar(photoUrl: driver.photoUrl, size: 40),
                    title: Text(driver.name),
                    subtitle: Text(
                      '@${driver.username} · '
                      '${driver.available ? 'Tersedia' : 'Tidak tersedia'}',
                    ),
                    trailing: Wrap(
                      children: [
                        IconButton(
                          key: ValueKey('edit-driver-${driver.username}'),
                          tooltip: 'Edit ${driver.name}',
                          onPressed: () => _editDriver(driver),
                          icon: const Icon(Icons.edit_outlined),
                        ),
                        IconButton(
                          key: ValueKey('delete-driver-${driver.username}'),
                          tooltip: 'Hapus ${driver.name}',
                          onPressed: () => _removeDriver(driver),
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_drivers),
          child: const Text('Simpan data contoh'),
        ),
      ],
    );
  }
}

class _DriverFormDialog extends StatefulWidget {
  const _DriverFormDialog({required this.existingUsernames, this.driver});

  final DemoDriver? driver;
  final Set<String> existingUsernames;

  @override
  State<_DriverFormDialog> createState() => _DriverFormDialogState();
}

class _DriverFormDialogState extends State<_DriverFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(
    text: widget.driver?.name ?? '',
  );
  late final _usernameController = TextEditingController(
    text: widget.driver?.username ?? '',
  );
  late final _photoUrlController = TextEditingController(
    text: widget.driver?.photoUrl ?? '',
  );
  late bool _available = widget.driver?.available ?? true;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _photoUrlController.dispose();
    super.dispose();
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.of(context).pop(
      DemoDriver(
        name: _nameController.text.trim(),
        username: _usernameController.text.trim(),
        available: _available,
        photoUrl: _photoUrlController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text(widget.driver == null ? 'Tambah Driver' : 'Edit Driver'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              key: const ValueKey('admin-driver-name'),
              controller: _nameController,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Nama Driver'),
              validator: _requiredValidator,
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const ValueKey('admin-driver-username'),
              controller: _usernameController,
              autocorrect: false,
              decoration: const InputDecoration(labelText: 'Nama pengguna'),
              validator: (value) {
                final username = value?.trim() ?? '';
                if (username.isEmpty) return 'Nama pengguna wajib diisi.';
                final duplicate = widget.existingUsernames.any(
                  (existing) =>
                      existing.toLowerCase() == username.toLowerCase() &&
                      existing.toLowerCase() !=
                          widget.driver?.username.toLowerCase(),
                );
                return duplicate ? 'Nama pengguna sudah digunakan.' : null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const ValueKey('admin-driver-photo'),
              controller: _photoUrlController,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'URL foto (opsional)',
                hintText: 'https://...',
                prefixIcon: Icon(Icons.image_outlined),
              ),
              validator: (value) {
                final url = value?.trim() ?? '';
                if (url.isEmpty) return null;
                final uri = Uri.tryParse(url);
                if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) {
                  return 'Gunakan URL foto HTTPS yang valid.';
                }
                return null;
              },
            ),
            SwitchListTile(
              key: const ValueKey('admin-driver-availability'),
              contentPadding: EdgeInsets.zero,
              title: const Text('Driver tersedia'),
              value: _available,
              onChanged: (value) => setState(() => _available = value),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        FilledButton(
          key: const ValueKey('save-demo-driver'),
          onPressed: _save,
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}

class _CylinderPriceDialog extends StatefulWidget {
  const _CylinderPriceDialog({required this.currentPrice});

  final int currentPrice;

  @override
  State<_CylinderPriceDialog> createState() => _CylinderPriceDialogState();
}

class _CylinderPriceDialogState extends State<_CylinderPriceDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _priceController = TextEditingController(
    text: widget.currentPrice.toString(),
  );

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.of(context).pop(int.parse(_priceController.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('Harga per tabung'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Harga baru hanya berlaku untuk pengiriman berikutnya. '
              'Harga historis tetap pada transaksi.',
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const ValueKey('admin-cylinder-price'),
              controller: _priceController,
              autofocus: true,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Harga (rupiah)',
                prefixText: 'Rp ',
              ),
              validator: (value) {
                final price = int.tryParse(value?.trim() ?? '');
                if (price == null) return 'Masukkan harga dalam angka.';
                if (price < 1) return 'Harga harus lebih dari Rp 0.';
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        FilledButton(
          key: const ValueKey('save-cylinder-price'),
          onPressed: _save,
          child: const Text('Simpan harga'),
        ),
      ],
    );
  }
}

class _DriverAvatar extends StatelessWidget {
  const _DriverAvatar({required this.photoUrl, required this.size});

  final String photoUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final fallback = CircleAvatar(
      radius: size / 2,
      child: const Icon(Icons.local_shipping_outlined),
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

class _DemoOnlyNotice extends StatelessWidget {
  const _DemoOnlyNotice({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3D9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodySmall
            ?.copyWith(color: const Color(0xFF624600)),
      ),
    );
  }
}

String? _requiredValidator(String? value) {
  if (value == null || value.trim().isEmpty) return 'Bagian ini wajib diisi.';
  return null;
}

Future<bool> _confirmDelete(BuildContext context, String message) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Konfirmasi hapus'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Hapus'),
        ),
      ],
    ),
  );
  return result ?? false;
}

Future<void> _showPasswordResetNotice(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Pengaturan kata sandi'),
      content: const Text(
        'Autentikasi belum terhubung. Kata sandi tidak disimpan di aplikasi '
        'demo. Pengaturan ulang hanya dapat dilakukan setelah backend '
        'autentikasi disiapkan.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Mengerti'),
        ),
      ],
    ),
  );
}
