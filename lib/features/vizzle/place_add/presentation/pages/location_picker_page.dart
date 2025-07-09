import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class PickedLocation {
  final double latitude;
  final double longitude;
  final String placeName;
  final String? address;
  final String? placeId;

  PickedLocation({
    required this.latitude,
    required this.longitude,
    required this.placeName,
    this.address,
    this.placeId,
  });
}

class PlacePrediction {
  final String placeId;
  final String description;
  final String mainText;
  final String? secondaryText;

  PlacePrediction({
    required this.placeId,
    required this.description,
    required this.mainText,
    this.secondaryText,
  });

  factory PlacePrediction.fromJson(Map<String, dynamic> json) {
    return PlacePrediction(
      placeId: json['place_id'],
      description: json['description'],
      mainText: json['structured_formatting']['main_text'],
      secondaryText: json['structured_formatting']['secondary_text'],
    );
  }
}

class LocationSearchView extends StatefulWidget {
  final Function(PickedLocation) onLocationSelected;
  final String googleApiKey;
  final LatLng? initialLocation;
  final double initialZoom;

  const LocationSearchView({
    super.key,
    required this.onLocationSelected,
    required this.googleApiKey,
    this.initialLocation,
    this.initialZoom = 14.0,
  });

  @override
  State<LocationSearchView> createState() => _LocationSearchViewState();
}

class _LocationSearchViewState extends State<LocationSearchView>
    with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  LatLng? _selectedLocation;
  String _selectedPlaceName = '';
  String _selectedAddress = '';
  Set<Marker> _markers = {};

  bool _isLoading = false;
  bool _isSearching = false;
  bool _showSuggestions = false;
  List<PlacePrediction> _predictions = [];
  Timer? _debounceTimer;

  LatLng _currentMapCenter = const LatLng(37.7749, -122.4194);
  LatLng? _currentLocation;

  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;
  late AnimationController _confirmButtonController;
  late Animation<double> _confirmButtonAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeLocation();
    _setupSearchListener();
  }

  void _initializeAnimations() {
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    );

    _confirmButtonController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _confirmButtonAnimation = CurvedAnimation(
      parent: _confirmButtonController,
      curve: Curves.easeInOut,
    );
  }

  void _setupSearchListener() {
    _searchController.addListener(() {
      if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        if (_searchController.text.isNotEmpty) {
          _searchPlaces(_searchController.text);
        } else {
          setState(() {
            _predictions.clear();
            _showSuggestions = false;
          });
        }
      });
    });

    _searchFocusNode.addListener(() {
      setState(() {
        _showSuggestions = _searchFocusNode.hasFocus && _predictions.isNotEmpty;
      });
    });
  }

  Future<void> _initializeLocation() async {
    if (widget.initialLocation != null) {
      _currentMapCenter = widget.initialLocation!;
      _fabAnimationController.forward();
      return;
    }

    await _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      setState(() => _isLoading = true);

      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showLocationServiceDialog();
        setState(() => _isLoading = false);
        return;
      }

      // Check and request permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showPermissionDeniedDialog();
          setState(() => _isLoading = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showPermissionPermanentlyDeniedDialog();
        setState(() => _isLoading = false);
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _currentMapCenter = _currentLocation!;
        _isLoading = false;
      });

      // Move camera to current location
      if (_mapController != null) {
        await _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(_currentLocation!, widget.initialZoom),
        );
      }

      _fabAnimationController.forward();
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Error getting location: $e');
    }
  }

  Future<void> _searchPlaces(String query) async {
    if (query.isEmpty) return;

    setState(() => _isSearching = true);

    try {
      final String url =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json'
          '?input=${Uri.encodeComponent(query)}'
          '&key=${widget.googleApiKey}'
          '&types=establishment|geocode'
          '&components=country:ae|country:in';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          List<PlacePrediction> predictions = (data['predictions'] as List)
              .map((prediction) => PlacePrediction.fromJson(prediction))
              .toList();

          setState(() {
            _predictions = predictions;
            _showSuggestions =
                predictions.isNotEmpty && _searchFocusNode.hasFocus;
            _isSearching = false;
          });
        }
      }
    } catch (e) {
      setState(() => _isSearching = false);
      _showErrorSnackBar('Error searching places: $e');
    }
  }

  Future<void> _getPlaceDetails(String placeId, String description) async {
    setState(() => _isLoading = true);

    try {
      final String url =
          'https://maps.googleapis.com/maps/api/place/details/json'
          '?place_id=$placeId'
          '&fields=geometry,name,formatted_address'
          '&key=${widget.googleApiKey}';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final result = data['result'];
          final location = result['geometry']['location'];
          final lat = location['lat'];
          final lng = location['lng'];
          final name = result['name'] ?? description;
          final address = result['formatted_address'] ?? '';

          LatLng selectedLocation = LatLng(lat, lng);
          _setSelectedLocation(selectedLocation, name, address, placeId);
        }
      }
    } catch (e) {
      _showErrorSnackBar('Error getting place details: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // New method for reverse geocoding
  Future<void> _reverseGeocode(LatLng location) async {
    setState(() => _isLoading = true);

    try {
      final String url =
          'https://maps.googleapis.com/maps/api/geocode/json'
          '?latlng=${location.latitude},${location.longitude}'
          '&key=${widget.googleApiKey}';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          final result = data['results'][0];
          final formattedAddress = result['formatted_address'] ?? '';

          // Try to get a meaningful place name from address components
          String placeName = 'Selected Location';
          final addressComponents = result['address_components'] as List?;

          if (addressComponents != null && addressComponents.isNotEmpty) {
            // Look for establishment, point_of_interest, or premise first
            for (final component in addressComponents) {
              final types = component['types'] as List<dynamic>;
              if (types.contains('establishment') ||
                  types.contains('point_of_interest') ||
                  types.contains('premise')) {
                placeName = component['long_name'];
                break;
              }
            }

            // If no establishment found, use street number + route
            if (placeName == 'Selected Location') {
              String streetNumber = '';
              String route = '';

              for (final component in addressComponents) {
                final types = component['types'] as List<dynamic>;
                if (types.contains('street_number')) {
                  streetNumber = component['long_name'];
                } else if (types.contains('route')) {
                  route = component['long_name'];
                }
              }

              if (streetNumber.isNotEmpty && route.isNotEmpty) {
                placeName = '$streetNumber $route';
              } else if (route.isNotEmpty) {
                placeName = route;
              } else {
                // Use locality or sublocality as fallback
                for (final component in addressComponents) {
                  final types = component['types'] as List<dynamic>;
                  if (types.contains('locality') ||
                      types.contains('sublocality') ||
                      types.contains('administrative_area_level_2')) {
                    placeName = component['long_name'];
                    break;
                  }
                }
              }
            }
          }

          _setSelectedLocation(location, placeName, formattedAddress);
        } else {
          _setSelectedLocation(location, 'Selected Location');
        }
      } else {
        _setSelectedLocation(location, 'Selected Location');
      }
    } catch (e) {
      _showErrorSnackBar('Error getting location details: $e');
      _setSelectedLocation(location, 'Selected Location');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    // Move to current location if available
    if (_currentLocation != null) {
      controller.animateCamera(
        CameraUpdate.newLatLngZoom(_currentLocation!, widget.initialZoom),
      );
    }
  }

  // Updated _onMapTap method to use reverse geocoding
  void _onMapTap(LatLng location) {
    _reverseGeocode(location); // This will get the actual place name
    _searchFocusNode.unfocus();
  }

  void _setSelectedLocation(
    LatLng location,
    String placeName, [
    String? address,
    String? placeId,
  ]) {
    setState(() {
      _selectedLocation = location;
      _selectedPlaceName = placeName;
      _selectedAddress = address ?? '';
      _markers = {
        Marker(
          markerId: const MarkerId('selected'),
          position: location,
          infoWindow: InfoWindow(title: placeName, snippet: address),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      };
    });

    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(location, 16.0));
    _confirmButtonController.forward();
  }

  void _onPlaceSelected(PlacePrediction prediction) {
    _searchController.text = prediction.description;
    setState(() {
      _showSuggestions = false;
      _predictions.clear();
    });
    _searchFocusNode.unfocus();
    _getPlaceDetails(prediction.placeId, prediction.description);
  }

  void _moveToCurrentLocation() async {
    if (_currentLocation != null) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_currentLocation!, 16.0),
      );
    } else {
      await _getCurrentLocation();
    }
  }

  void _confirmSelection() {
    if (_selectedLocation != null) {
      final pickedLocation = PickedLocation(
        latitude: _selectedLocation!.latitude,
        longitude: _selectedLocation!.longitude,
        placeName: _selectedPlaceName,
        address: _selectedAddress.isNotEmpty ? _selectedAddress : null,
      );

      widget.onLocationSelected(pickedLocation);
      Navigator.of(context).pop();
    }
  }

  void _showLocationServiceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Services Disabled'),
        content: const Text(
          'Please enable location services to use this feature.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission Required'),
        content: const Text(
          'This app needs location permission to show your current location.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _getCurrentLocation();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showPermissionPermanentlyDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission Required'),
        content: const Text(
          'Location permission is permanently denied. Please enable it in app settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _fabAnimationController.dispose();
    _confirmButtonController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _currentMapCenter,
              zoom: widget.initialZoom,
            ),
            onTap: _onMapTap,
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            onCameraMove: (CameraPosition position) {
              _currentMapCenter = position.target;
            },
          ),

          // Search Bar (Google Maps Style)
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            right: 16,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black54,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                          decoration: const InputDecoration(
                            hintText: 'Search for a place',
                            hintStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 16),
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              _searchPlaces(value);
                            }
                          },
                        ),
                      ),
                      if (_searchController.text.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.clear, color: Colors.black54),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _predictions.clear();
                              _showSuggestions = false;
                            });
                          },
                        ),
                      if (_isSearching)
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                    ],
                  ),
                ),

                // Suggestions List
                if (_showSuggestions && _predictions.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    constraints: const BoxConstraints(maxHeight: 300),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: _predictions.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final prediction = _predictions[index];
                        return ListTile(
                          dense: true,
                          leading: const Icon(
                            Icons.location_on,
                            color: Colors.grey,
                            size: 20,
                          ),
                          title: Text(
                            prediction.mainText,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: prediction.secondaryText != null
                              ? Text(
                                  prediction.secondaryText!,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                )
                              : null,
                          onTap: () => _onPlaceSelected(prediction),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),

          // Current Location FAB
          Positioned(
            right: 16,
            bottom: _selectedLocation != null ? 140 : 80,
            child: ScaleTransition(
              scale: _fabAnimation,
              child: FloatingActionButton(
                heroTag: "currentLocation",
                onPressed: _moveToCurrentLocation,
                backgroundColor: Colors.white,
                elevation: 2,
                child: Icon(
                  Icons.my_location,
                  color: _currentLocation != null ? Colors.blue : Colors.grey,
                ),
              ),
            ),
          ),

          // Confirm Button
          if (_selectedLocation != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 30,
              child: ScaleTransition(
                scale: _confirmButtonAnimation,
                child: Container(
                  width: double.infinity,
                  height: 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _confirmSelection,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Confirm Location',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Loading Overlay
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Loading...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
