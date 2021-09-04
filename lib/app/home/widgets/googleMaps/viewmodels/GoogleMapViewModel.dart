import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

final googleMapViewModelProvider =
    StateNotifierProvider<GoogleMapViewModel, LatLng?>(
        (_) => GoogleMapViewModel());

class GoogleMapViewModel extends StateNotifier<LatLng?> {
  Timer? timer;
  GoogleMapViewModel() : super(null);

  void init() {
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      startLocationUpdateOnTimer();
    });
  }

  Future<void> startLocationUpdateOnTimer() async {
    final currentPos = await getCurrentLocation();
    state = currentPos;
  }

  Future<LatLng> getCurrentLocation() async {
    final currentPos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    final latlng = LatLng(currentPos.latitude, currentPos.longitude);
    return latlng;
  }

  @override
  void dispose() {
    if (timer != null && timer!.isActive) timer?.cancel();
    super.dispose();
  }
}
