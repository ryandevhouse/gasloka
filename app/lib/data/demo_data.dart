import '../models/app_user.dart';

abstract final class DemoData {
  static const users = <UserRole, AppUser>{
    UserRole.admin: AppUser(
      name: 'Nadia Putri',
      username: 'admin.demo',
      role: UserRole.admin,
    ),
    UserRole.pengawas: AppUser(
      name: 'Rizky Pratama',
      username: 'pengawas.demo',
      role: UserRole.pengawas,
    ),
    UserRole.agen: AppUser(
      name: 'Sari Wulandari',
      username: 'agen.demo',
      role: UserRole.agen,
    ),
    UserRole.driver: AppUser(
      name: 'Budi Santoso',
      username: 'driver.demo',
      role: UserRole.driver,
    ),
    UserRole.pangkalan: AppUser(
      name: 'Pangkalan Melati',
      username: 'pangkalan.demo',
      role: UserRole.pangkalan,
    ),
  };

  static const deliveries = <DemoDelivery>[
    DemoDelivery(
      baseName: 'Pangkalan Melati',
      address: 'Jl. Mawar No. 12, Bandung',
      cylinderCount: 24,
      status: DeliveryStatus.dalamPerjalanan,
    ),
    DemoDelivery(
      baseName: 'Pangkalan Sejahtera',
      address: 'Jl. Anggrek No. 8, Bandung',
      cylinderCount: 18,
      status: DeliveryStatus.terkirim,
    ),
    DemoDelivery(
      baseName: 'Pangkalan Cempaka',
      address: 'Jl. Kenanga No. 5, Cimahi',
      cylinderCount: 20,
      status: DeliveryStatus.kurang,
    ),
  ];

  static const requests = <DemoDelivery>[
    DemoDelivery(
      baseName: 'Pangkalan Melati',
      address: 'Jl. Mawar No. 12, Bandung',
      cylinderCount: 24,
      status: DeliveryStatus.permintaanBaru,
    ),
    DemoDelivery(
      baseName: 'Pangkalan Cempaka',
      address: 'Jl. Kenanga No. 5, Cimahi',
      cylinderCount: 20,
      status: DeliveryStatus.permintaanBaru,
    ),
  ];
}
