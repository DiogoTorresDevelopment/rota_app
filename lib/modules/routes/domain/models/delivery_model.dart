class DeliveryModel {
  final int id;
  final String status;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? notes;
  final RouteModel route;
  final DriverModel driver;
  final TruckModel truck;
  final StopModel? currentStop;
  final List<StopModel> stops;

  DeliveryModel({
    required this.id,
    required this.status,
    required this.createdAt,
    this.completedAt,
    this.notes,
    required this.route,
    required this.driver,
    required this.truck,
    this.currentStop,
    required this.stops,
  });

  factory DeliveryModel.fromJson(Map<String, dynamic> json) {
    return DeliveryModel(
      id: json['id'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at']) : null,
      notes: json['notes'],
      route: RouteModel.fromJson(json['route']),
      driver: DriverModel.fromJson(json['driver']),
      truck: TruckModel.fromJson(json['truck']),
      currentStop: json['current_stop'] != null ? StopModel.fromJson(json['current_stop']) : null,
      stops: (json['stops'] as List).map((e) => StopModel.fromJson(e)).toList(),
    );
  }
}

class RouteModel {
  final int id;
  final String name;
  final String status;

  RouteModel({required this.id, required this.name, required this.status});

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      id: json['id'],
      name: json['name'],
      status: json['status'],
    );
  }
}

class DriverModel {
  final int id;
  final String name;
  final String phone;
  final String email;

  DriverModel({required this.id, required this.name, required this.phone, required this.email});

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
    );
  }
}

class TruckModel {
  final int id;
  final String plate;
  final String model;
  final String brand;
  final int year;
  final String color;
  final String fuelType;
  final String loadCapacity;
  final String chassis;
  final String mileage;
  final String lastReview;
  final bool status;

  TruckModel({
    required this.id,
    required this.plate,
    required this.model,
    required this.brand,
    required this.year,
    required this.color,
    required this.fuelType,
    required this.loadCapacity,
    required this.chassis,
    required this.mileage,
    required this.lastReview,
    required this.status,
  });

  factory TruckModel.fromJson(Map<String, dynamic> json) {
    return TruckModel(
      id: json['id'],
      plate: json['plate'],
      model: json['model'],
      brand: json['brand'],
      year: json['year'],
      color: json['color'],
      fuelType: json['fuel_type'],
      loadCapacity: json['load_capacity'],
      chassis: json['chassis'],
      mileage: json['mileage'],
      lastReview: json['last_review'],
      status: json['status'],
    );
  }
}

class StopModel {
  final int id;
  final String name;
  final int order;
  final String status;
  final DateTime? completedAt;
  final List<dynamic> photos;
  final String latitude;
  final String longitude;
  final AddressModel address;

  StopModel({
    required this.id,
    required this.name,
    required this.order,
    required this.status,
    this.completedAt,
    required this.photos,
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  factory StopModel.fromJson(Map<String, dynamic> json) {
    return StopModel(
      id: json['id'],
      name: json['name'],
      order: json['order'],
      status: json['status'],
      completedAt: json['completed_at'] != null ? DateTime.tryParse(json['completed_at']) : null,
      photos: json['photos'] ?? [],
      latitude: json['latitude'],
      longitude: json['longitude'],
      address: AddressModel.fromJson(json['address']),
    );
  }
}

class AddressModel {
  final String street;
  final String number;
  final String city;
  final String state;
  final String cep;

  AddressModel({required this.street, required this.number, required this.city, required this.state, required this.cep});

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      street: json['street'],
      number: json['number'],
      city: json['city'],
      state: json['state'],
      cep: json['cep'],
    );
  }
} 