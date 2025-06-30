import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/buttons/primary_button.dart';
import '../../../../../core/widgets/common/app_bar.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/inputs/text_field.dart';
import '../../domain/entities/location_entity.dart';

class LocationPickerPage extends StatefulWidget {
  final LocationEntity? initialLocation;
  final Function(LocationEntity) onLocationSelected;

  const LocationPickerPage({
    super.key,
    this.initialLocation,
    required this.onLocationSelected,
  });

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  GoogleMapController? _mapController;
  LatLng _selectedLocation = const LatLng(12.2958, 76.6394);
  String _locationName = "Unknown Location";
  bool _isMapMoving = false;
  bool isSearching = false;

  final TextEditingController _searchController = TextEditingController();
  final List<PlaceSuggestion> _suggestions = [];
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    if (widget.initialLocation?.isValid == true) {
      _selectedLocation = LatLng(
        widget.initialLocation!.latitude!,
        widget.initialLocation!.longitude!,
      );
      _locationName = widget.initialLocation!.placeName ?? "Unknown Location";
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: const CommonAppBar(
        title: "Select Location",
        showBackButton: true,
      ),
      body: Column(
        children: [
          // Search Section
          Container(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            color: AppConstants.surfaceVariant,
            child: Column(
              children: [
                const CommonTextWidget(
                  text: "Set up your location",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  align: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const CommonTextWidget(
                  text: "Drag the map to move the pin or search for a place",
                  fontSize: 12,
                  color: AppConstants.onSurfaceSecondary,
                  align: TextAlign.center,
                ),
                const SizedBox(height: 16),
                CommonTextField(
                  controller: _searchController,
                  hintText: "Search for a place",
                  prefixIcon: Container(
                    margin: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: AppConstants.appPrimaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.search,
                      size: 16,
                      color: AppConstants.black,
                    ),
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            _suggestions.clear();
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.clear,
                            color: AppConstants.appPrimaryColor,
                          ),
                        )
                      : null,
                  onChanged: _onSearchChanged,
                ),
              ],
            ),
          ),

          // Map Section
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _selectedLocation,
                    zoom: 14.0,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                  onCameraMoveStarted: () {
                    setState(() {
                      _isMapMoving = true;
                    });
                  },
                  onCameraMove: (CameraPosition position) {
                    _selectedLocation = position.target;
                  },
                  onCameraIdle: () {
                    setState(() {
                      _isMapMoving = false;
                    });
                    _updateLocationName();
                  },
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  mapToolbarEnabled: false,
                  markers: _isMapMoving
                      ? {}
                      : {
                          Marker(
                            markerId: const MarkerId('selected'),
                            position: _selectedLocation,
                            infoWindow: InfoWindow(title: _locationName),
                          ),
                        },
                ),

                // Center pin indicator
                const Center(
                  child: Icon(
                    Icons.location_on,
                    size: 40,
                    color: AppConstants.appPrimaryColor,
                  ),
                ),

                // Search Results Overlay
                if (_suggestions.isNotEmpty)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      margin: const EdgeInsets.all(AppConstants.defaultPadding),
                      decoration: BoxDecoration(
                        color: AppConstants.surfaceVariant,
                        borderRadius: BorderRadius.circular(
                          AppConstants.defaultBorderRadius,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppConstants.black.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            child: const CommonTextWidget(
                              text: "Search Results",
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _suggestions.length,
                            itemBuilder: (context, index) {
                              final suggestion = _suggestions[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: AppConstants.appPrimaryColor
                                      .withOpacity(0.1),
                                  radius: 16,
                                  child: const Icon(
                                    Icons.location_on,
                                    size: 16,
                                    color: AppConstants.appPrimaryColor,
                                  ),
                                ),
                                title: CommonTextWidget(
                                  text: suggestion.name,
                                  fontSize: 14,
                                  maxLines: 1,
                                ),
                                onTap: () => _selectSuggestion(suggestion),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Bottom Section
          Container(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            decoration: const BoxDecoration(
              color: AppConstants.surfaceVariant,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppConstants.appPrimaryColor.withOpacity(
                        0.1,
                      ),
                      radius: 16,
                      child: const Icon(
                        Icons.location_on,
                        size: 16,
                        color: AppConstants.appPrimaryColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonTextWidget(
                            text: _locationName,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 2),
                          const CommonTextWidget(
                            text: "Selected Location",
                            fontSize: 12,
                            color: AppConstants.onSurfaceSecondary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  text: "Use This Location",
                  onPressed: () {
                    final location = LocationEntity(
                      latitude: _selectedLocation.latitude,
                      longitude: _selectedLocation.longitude,
                      placeName: _locationName,
                      address: _locationName,
                    );
                    widget.onLocationSelected(location);
                    Navigator.pop(context);
                  },
                  width: double.infinity,
                  prefix: const Icon(
                    Icons.check,
                    color: AppConstants.black,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        _searchPlaces(query);
      } else {
        setState(() {
          _suggestions.clear();
        });
      }
    });
  }

  Future<void> _searchPlaces(String query) async {
    setState(() {
      isSearching = true;
    });

    try {
      const String apiKey =
          'YOUR_GOOGLE_PLACES_API_KEY'; // Replace with your API key
      final String url =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json'
          '?input=$query'
          '&components=country:IN'
          '&key=$apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<PlaceSuggestion> newSuggestions = [];

        for (var prediction in data['predictions']) {
          newSuggestions.add(
            PlaceSuggestion(
              name: prediction['description'],
              placeId: prediction['place_id'],
            ),
          );
        }

        setState(() {
          _suggestions.clear();
          _suggestions.addAll(newSuggestions.take(5)); // Limit to 5 results
        });
      }
    } catch (e) {
      debugPrint('Error searching places: $e');
    } finally {
      setState(() {
        isSearching = false;
      });
    }
  }

  Future<void> _selectSuggestion(PlaceSuggestion suggestion) async {
    try {
      const String apiKey = 'YOUR_GOOGLE_PLACES_API_KEY';
      final String url =
          'https://maps.googleapis.com/maps/api/place/details/json'
          '?place_id=${suggestion.placeId}'
          '&fields=name,geometry'
          '&key=$apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final result = data['result'];
        final location = result['geometry']['location'];

        final newLocation = LatLng(location['lat'], location['lng']);

        setState(() {
          _selectedLocation = newLocation;
          _locationName = suggestion.name;
          _suggestions.clear();
          _searchController.clear();
        });

        _mapController?.animateCamera(CameraUpdate.newLatLng(newLocation));
      }
    } catch (e) {
      debugPrint('Error getting place details: $e');
    }
  }

  Future<void> _updateLocationName() async {
    try {
      setState(() {
        _locationName =
            'Lat: ${_selectedLocation.latitude.toStringAsFixed(4)}, '
            'Lng: ${_selectedLocation.longitude.toStringAsFixed(4)}';
      });
    } catch (e) {
      debugPrint('Error updating location name: $e');
    }
  }
}

class PlaceSuggestion {
  final String name;
  final String placeId;

  PlaceSuggestion({required this.name, required this.placeId});
}
