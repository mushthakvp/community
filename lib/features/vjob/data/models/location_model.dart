import 'package:livera/features/vjob/domain/entities/job_entity.dart';

class LocationModel extends LocationEntity {
  const LocationModel({required super.latitude, required super.longitude});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: json['lat']?.toString() ?? '0',
      longitude: json['lng']?.toString() ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {'lat': latitude, 'lng': longitude};
  }
}
