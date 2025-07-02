import '../../domain/entities/city.dart';

class CityModel extends City {
  const CityModel({
    required super.name,
    super.state,
    super.country,
    super.latitude,
    super.longitude,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      name: json['name'] ?? '',
      state: json['state'],
      country: json['country'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
    );
  }

  factory CityModel.fromString(String cityName) {
    return CityModel(name: cityName);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'state': state,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
