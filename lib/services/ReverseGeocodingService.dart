import 'package:fawnora/constants/kmlAssets.dart';
import 'package:flutter/services.dart';
import 'package:xml/xml.dart';
import 'dart:io';
import 'package:geocoding/geocoding.dart';

class ReverseGeocodingService {
  Future<MapEntry<String, String>> findDistrict(
      double posLat, double posLong) async {
    MapEntry<String, String>? location;
    final locMap = KMLAssets.kmlMap;
    for (var elem in locMap.entries) {
      final kmlFile = await _loadAsset(elem.value);
      final kmlParsed = XmlDocument.parse(kmlFile);
      final name = kmlParsed.findAllElements('name').elementAt(1).innerText;
      final coordinates =
          kmlParsed.findAllElements('coordinates').first.innerText.split(' ');
      final lat = <double>[];
      final longt = <double>[];
      coordinates.forEach((element) {
        final elemParts = element.split(',');
        if (elemParts.length == 3) {
          lat.add(double.tryParse(elemParts[1]) ?? 0);
          longt.add(double.tryParse(elemParts[0]) ?? 0);
        }
      });
      if (_pnpoly(lat.length, lat, longt, posLat, posLong)) {
        location = MapEntry('Uttar Pradesh', name);
        break;
      }
    }
    if (location == null) {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(posLat, posLong);
      final state = placemarks.first.administrativeArea;
      final city = placemarks.first.locality;
      location = MapEntry(state ?? 'Unknown', city ?? 'Unknown');
    }
    return location;
  }

  Future<String> _loadAsset(String asset) async {
    final file = await rootBundle.loadString(asset);
    return file;
  }

  bool _pnpoly(int nvert, List<double> vertx, List<double> verty, double testx,
      double testy) {
    var c = false;
    for (var i = 0, j = nvert - 1; i < nvert; j = i++) {
      if (((verty[i] > testy) != (verty[j] > testy)) &&
          (testx <
              (vertx[j] - vertx[i]) *
                      (testy - verty[i]) /
                      (verty[j] - verty[i]) +
                  vertx[i])) {
        c = !c;
      }
    }
    return c;
  }
}
