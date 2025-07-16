import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../core/constants/app_constants.dart';

class ProductLocationSection extends StatelessWidget {
  final String address;
  final double? latitude;
  final double? longitude;

  const ProductLocationSection({
    super.key,
    required this.address,
    this.latitude,
    this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Location',
          style: TextStyle(
            color: AppConstants.appPrimaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),

        // Address
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.location_on,
              color: AppConstants.appPrimaryColor,
              size: 16,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                address,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),

        // Map
        if (latitude != null && longitude != null) ...[
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(latitude!, longitude!),
                  zoom: 15,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('product_location'),
                    position: LatLng(latitude!, longitude!),
                  ),
                },
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
