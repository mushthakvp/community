import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../providers/place_add_provider.dart';

class LocationPickerPage extends StatefulWidget {
  final double? initialLatitude;
  final double? initialLongitude;

  const LocationPickerPage({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
  });

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  final Completer<GoogleMapController> _controller = Completer();
  late LatLng _currentPosition;
  String _currentAddress = 'Loading...';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Use provided coordinates or default to Kannur, Kerala
    _currentPosition = LatLng(
      widget.initialLatitude ?? 11.8745,
      widget.initialLongitude ?? 75.3704,
    );

    if (widget.initialLatitude != null && widget.initialLongitude != null) {
      _isLoading = false;
      _updateAddress();
    } else {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isLoading = false;
          _currentAddress = 'Location services disabled';
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _isLoading = false;
            _currentAddress = 'Location permission denied';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _isLoading = false;
          _currentAddress = 'Location permission permanently denied';
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });

      _updateAddress();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _currentAddress = 'Failed to get location';
      });
    }
  }

  void _updateAddress() async {
    try {
      // Here you would typically use a geocoding service
      // For now, we'll use a placeholder based on coordinates
      if (_currentPosition.latitude == 11.8745 &&
          _currentPosition.longitude == 75.3704) {
        setState(() {
          _currentAddress = 'Kannur, Kerala, India';
        });
      } else {
        // You can integrate with a geocoding service here
        setState(() {
          _currentAddress = 'Selected Location';
        });
      }
    } catch (e) {
      setState(() {
        _currentAddress = 'Unable to get address';
      });
    }
  }

  void _onMapTap(LatLng position) {
    setState(() {
      _currentPosition = position;
    });
    _updateAddress();
  }

  void _confirmLocation() {
    final provider = context.read<PlaceAddProvider>();
    provider.setLocation(
      _currentPosition.latitude,
      _currentPosition.longitude,
      _currentAddress,
    );
    Navigator.pop(context);
  }

  void _useCurrentLocation() async {
    await _getCurrentLocation();
    if (_controller.isCompleted) {
      final controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLng(_currentPosition));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      body: Stack(
        children: [
          // Map
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            initialCameraPosition: CameraPosition(
              target: _currentPosition,
              zoom: 14.0,
            ),
            onTap: _onMapTap,
            markers: {
              Marker(
                markerId: const MarkerId('selected_location'),
                position: _currentPosition,
                infoWindow: const InfoWindow(title: 'Selected Location'),
              ),
            },
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
          ),

          // Custom location pin indicator
          const Center(
            child: Icon(
              Icons.location_on,
              size: 40,
              color: AppConstants.appPrimaryColor,
            ),
          ),

          // Top back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: CircleAvatar(
              backgroundColor: AppConstants.surfaceVariant,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: AppConstants.white),
              ),
            ),
          ),

          // Current location button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: CircleAvatar(
              backgroundColor: AppConstants.surfaceVariant,
              child: IconButton(
                onPressed: _useCurrentLocation,
                icon: const Icon(
                  Icons.my_location,
                  color: AppConstants.appPrimaryColor,
                ),
              ),
            ),
          ),

          // Bottom sheet
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppConstants.surfaceVariant,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CommonTextWidget(
                          text: 'Set up your location',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.close,
                            color: AppConstants.appPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                    const CommonTextWidget(
                      text: 'Drag the map to move the pin',
                      fontSize: 14,
                    ),
                    const Divider(height: 32),

                    if (_isLoading)
                      const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppConstants.appPrimaryColor,
                          ),
                        ),
                      )
                    else
                      Column(
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
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
                              text: _currentAddress,
                              fontSize: 16,
                            ),
                            subtitle: const CommonTextWidget(
                              text: 'Tap to confirm this location',
                              fontSize: 12,
                              color: AppConstants.onSurfaceVariant,
                            ),
                            onTap: _confirmLocation,
                          ),

                          const SizedBox(height: 16),

                          // Confirm button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _confirmLocation,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppConstants.appPrimaryColor,
                                foregroundColor: AppConstants.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const CommonTextWidget(
                                text: 'Confirm Location',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppConstants.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
