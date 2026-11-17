import '../models/app_user.dart';
import '../models/reference_data.dart';

abstract final class DemoData {
  static const standardCylinderPrice = 20000;

  static const users = <UserRole, AppUser>{
    UserRole.admin: AppUser(
      name: 'Siti',
      username: 'admin.demo',
      role: UserRole.admin,
    ),
    UserRole.pengawas: AppUser(
      name: 'Irjen Anang Suhardi',
      username: 'pengawas.demo',
      role: UserRole.pengawas,
    ),
    UserRole.agen: AppUser(
      name: 'Ipin',
      username: 'agen.demo',
      role: UserRole.agen,
    ),
    UserRole.driver: AppUser(
      name: 'Budi Santoso',
      username: 'driver.demo',
      role: UserRole.driver,
    ),
    UserRole.pangkalan: AppUser(
      name: 'Pangkalan Simanjuntak',
      username: 'pangkalan.demo',
      role: UserRole.pangkalan,
    ),
  };

  static const adminUsers = <AppUser>[
    AppUser(name: 'Siti', username: 'admin.demo', role: UserRole.admin),
    AppUser(
      name: 'Dewi Anggraini',
      username: 'admin2.demo',
      role: UserRole.admin,
    ),
    AppUser(
      name: 'Irjen Anang Suhardi',
      username: 'pengawas.demo',
      role: UserRole.pengawas,
    ),
    AppUser(name: 'Ipin', username: 'agen.demo', role: UserRole.agen),
    AppUser(
      name: 'Budi Santoso',
      username: 'driver.demo',
      role: UserRole.driver,
    ),
    AppUser(
      name: 'Pangkalan Simanjuntak',
      username: 'pangkalan.demo',
      role: UserRole.pangkalan,
    ),
  ];

  static const bases = <DemoBase>[
    DemoBase(
      name: 'Pangkalan Simanjuntak',
      address: 'Jl. Mawar No. 12, Bandung',
    ),
    DemoBase(
      name: 'Pangkalan Sejahtera',
      address: 'Jl. Anggrek No. 8, Bandung',
    ),
    DemoBase(name: 'Pangkalan Cempaka', address: 'Jl. Kenanga No. 5, Cimahi'),
  ];

  static const drivers = <DemoDriver>[
    DemoDriver(name: 'Budi Santoso', username: 'driver.demo', available: true),
    DemoDriver(
      name: 'Andi Wijaya',
      username: 'driver.andi.demo',
      available: false,
    ),
  ];

  static const deliveries = <DemoDelivery>[
    DemoDelivery(
      baseName: 'Pangkalan Simanjuntak',
      address: 'Jl. Mawar No. 12, Bandung',
      cylinderCount: 24,
      status: DeliveryStatus.menungguDriver,
      assignedDriverName: 'Budi Santoso',
    ),
    DemoDelivery(
      baseName: 'Pangkalan Sejahtera',
      address: 'Jl. Anggrek No. 8, Bandung',
      cylinderCount: 18,
      status: DeliveryStatus.terkirim,
      receivedCylinderCount: 18,
    ),
    DemoDelivery(
      baseName: 'Pangkalan Cempaka',
      address: 'Jl. Kenanga No. 5, Cimahi',
      cylinderCount: 20,
      status: DeliveryStatus.kurang,
      receivedCylinderCount: 18,
    ),
  ];

  static const requests = <DemoDelivery>[
    DemoDelivery(
      baseName: 'Pangkalan Simanjuntak',
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
