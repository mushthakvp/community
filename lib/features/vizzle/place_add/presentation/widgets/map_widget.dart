import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../pages/location_picker_page.dart';
import '../providers/place_add_provider.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaceAddProvider>(
      builder: (context, provider, child) {
        double lat = (provider.latitude ?? 11.8745) as double;
        double lng = (provider.longitude ?? 75.3704) as double;

        // Update camera position when location changes
        if (_mapController != null) {
          _mapController!.animateCamera(
            CameraUpdate.newLatLng(LatLng(lat, lng)),
          );
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: 120,
            width: double.infinity,
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                if (!_controller.isCompleted) {
                  _controller.complete(controller);
                }
                _mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(lat, lng),
                zoom: 14.0,
              ),
              markers: provider.latitude != null
                  ? {
                      Marker(
                        markerId: const MarkerId('selected_location'),
                        position: LatLng(lat, lng),
                      ),
                    }
                  : {},
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              mapToolbarEnabled: false,
              onTap: (_) => _openLocationPicker(context),
            ),
          ),
        );
      },
    );
  }

  void _openLocationPicker(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LocationPickerPage()),
    );
  }
}
