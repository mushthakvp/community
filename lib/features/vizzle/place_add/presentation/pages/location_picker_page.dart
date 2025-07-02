import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../providers/place_add_provider.dart';

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({super.key});

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng _currentPosition = const LatLng(11.8745, 75.3704); // Kannur, Kerala
  String _currentAddress = 'Loading...';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });

      _updateAddress();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateAddress() async {
    // Here you would typically use a geocoding service
    // For now, we'll use a placeholder
    setState(() {
      _currentAddress = 'Kannur, Kerala, India';
    });
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
                  ],
                ),
              ),
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
        ],
      ),
    );
  }
}
