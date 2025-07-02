import 'package:equatable/equatable.dart';

class City extends Equatable {
  final String name;
  final String? state;
  final String? country;
  final double? latitude;
  final double? longitude;

  const City({
    required this.name,
    this.state,
    this.country,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [name, state, country, latitude, longitude];
}
