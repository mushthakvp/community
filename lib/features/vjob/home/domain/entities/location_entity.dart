import 'package:equatable/equatable.dart';

class LocationEntity extends Equatable {
  final String lat;
  final String lng;

  const LocationEntity({required this.lat, required this.lng});

  LocationEntity copyWith({String? lat, String? lng}) {
    return LocationEntity(lat: lat ?? this.lat, lng: lng ?? this.lng);
  }

  @override
  List<Object?> get props => [lat, lng];
}
