class DemoBase {
  const DemoBase({required this.name, required this.address});

  final String name;
  final String address;
}

class DemoDriver {
  const DemoDriver({
    required this.name,
    required this.username,
    required this.available,
    this.photoUrl = '',
  });

  final String name;
  final String username;
  final bool available;
  final String photoUrl;
}
