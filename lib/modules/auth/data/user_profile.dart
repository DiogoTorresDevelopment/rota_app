class UserProfile {
  final int id;
  final String name;
  final String email;
  final String type;
  final DriverProfile driver;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.type,
    required this.driver,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final user = json['user'] ?? {};
    final driver = user['driver'] ?? {};

    return UserProfile(
      id: user['id'] ?? 0,
      name: user['name'] ?? '',
      email: user['email'] ?? '',
      type: user['type'] ?? '',
      driver: DriverProfile.fromJson(driver),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': {
        'id': id,
        'name': name,
        'email': email,
        'type': type,
        'driver': driver.toJson(),
      }
    };
  }
}

class DriverProfile {
  final int id;
  final String name;
  final String phone;
  final bool status;

  DriverProfile({
    required this.id,
    required this.name,
    required this.phone,
    required this.status,
  });

  factory DriverProfile.fromJson(Map<String, dynamic> json) {
    return DriverProfile(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      status: json['status'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'status': status,
    };
  }
} 