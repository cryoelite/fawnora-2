import 'package:fawnora/app/home/widgets/googleMaps/viewmodels/GoogleMapViewModel.dart';
import 'package:fawnora/constants/DefaultLocation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapWidget extends StatefulWidget {
  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  GoogleMapController? _controller;

  void _init(GoogleMapController controller, BuildContext context) {
    _controller = controller;
    context.read(googleMapViewModelProvider.notifier).init();
  }

  void _updateMap(LatLng? val) {
    if (val != null && _controller != null) {
      _controller?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: val,
            tilt: 0,
            zoom: 13,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: Consumer(builder: (context, watch, child) {
        final watchGoogleMapProvider = watch(googleMapViewModelProvider);

        _updateMap(watchGoogleMapProvider);
        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(DefaultLocation.defaultLatitude,
                DefaultLocation.defaultLongitude),
            bearing: 0,
            tilt: 0,
            zoom: 13,
          ),
          compassEnabled: true,
          //TODO: Enable at release         myLocationEnabled: true,

          mapType: MapType.hybrid,
          myLocationButtonEnabled: true,
          onMapCreated: (controller) => _init(controller, context),
          zoomControlsEnabled: false,
        );
      }),
    );
  }
}
