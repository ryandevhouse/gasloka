import 'package:material_ui/material_ui.dart';

enum UserRole { admin, pengawas, agen, driver, pangkalan }

extension UserRolePresentation on UserRole {
  String get label => switch (this) {
    UserRole.admin => 'Admin',
    UserRole.pengawas => 'Pengawas',
    UserRole.agen => 'Agen',
    UserRole.driver => 'Driver',
    UserRole.pangkalan => 'Pangkalan',
  };

  Color get accentColor => switch (this) {
    UserRole.admin => const Color(0xFF198754),
    UserRole.pengawas => const Color(0xFFA16207),
    UserRole.agen => const Color(0xFF2563EB),
    UserRole.driver => const Color(0xFF7E3AF2),
    UserRole.pangkalan => const Color(0xFFC2410C),
  };

  IconData get icon => switch (this) {
    UserRole.admin => Icons.admin_panel_settings_outlined,
    UserRole.pengawas => Icons.visibility_outlined,
    UserRole.agen => Icons.inventory_2_outlined,
    UserRole.driver => Icons.local_shipping_outlined,
    UserRole.pangkalan => Icons.storefront_outlined,
  };
}

class AppUser {
  const AppUser({
    required this.name,
    required this.username,
    required this.role,
  });

  final String name;
  final String username;
  final UserRole role;
}

enum DeliveryStatus {
  permintaanBaru,
  menungguDriver,
  dalamPerjalanan,
  terkirim,
  kurang,
}

extension DeliveryStatusPresentation on DeliveryStatus {
  String get label => switch (this) {
    DeliveryStatus.permintaanBaru => 'Permintaan baru',
    DeliveryStatus.menungguDriver => 'Menunggu Driver',
    DeliveryStatus.dalamPerjalanan => 'Dalam perjalanan',
    DeliveryStatus.terkirim => 'Terkirim',
    DeliveryStatus.kurang => 'Kurang',
  };

  IconData get icon => switch (this) {
    DeliveryStatus.permintaanBaru => Icons.inbox_outlined,
    DeliveryStatus.menungguDriver => Icons.person_search_outlined,
    DeliveryStatus.dalamPerjalanan => Icons.local_shipping_outlined,
    DeliveryStatus.terkirim => Icons.check_circle_outline,
    DeliveryStatus.kurang => Icons.warning_amber_rounded,
  };
}

class DemoDelivery {
  const DemoDelivery({
    required this.baseName,
    required this.address,
    required this.cylinderCount,
    required this.status,
    this.receivedCylinderCount,
    this.pricePerCylinder = 20000,
    this.assignedDriverName,
  });

  final String baseName;
  final String address;
  final int cylinderCount;
  final DeliveryStatus status;
  final int? receivedCylinderCount;
  final int pricePerCylinder;
  final String? assignedDriverName;

  int get shortageCylinderCount {
    final received = receivedCylinderCount;
    if (received == null || received >= cylinderCount) return 0;
    return cylinderCount - received;
  }
}
