import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserDataModel {
  final String username;
  final String specie;
  final String specieType;
  final String subSpecie;
  final LatLng location;
  final DateTime dateTime;
  final int transect;
  final String city;
  final String state;
  final String language;

  const UserDataModel(
    this.username,
    this.specie,
    this.specieType,
    this.subSpecie,
    this.location,
    this.city,
    this.state,
    this.dateTime,
    this.transect,
    this.language,
  );
}
