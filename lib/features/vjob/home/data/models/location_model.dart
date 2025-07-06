import '../../domain/entities/location_entity.dart';

class LocationModel extends LocationEntity {
  const LocationModel({required super.lat, required super.lng});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      lat: json['lat']?.toString() ?? '0',
      lng: json['lng']?.toString() ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {'lat': lat, 'lng': lng};
  }
}
