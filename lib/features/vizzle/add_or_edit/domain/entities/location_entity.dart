class LocationEntity {
  final double? latitude;
  final double? longitude;
  final String? placeName;
  final String? address;

  const LocationEntity({
    this.latitude,
    this.longitude,
    this.placeName,
    this.address,
  });

  bool get isValid => latitude != null && longitude != null;
}
