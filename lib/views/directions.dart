import 'package:dio/dio.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:webui/app_constant.dart';

class DirectionsLine {
  static const String _directionsBaseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';
  static const String _roadsBaseUrl =
      'https://roads.googleapis.com/v1/snapToRoads?';

  final Dio _dio;

  DirectionsLine({required Dio dio}) : _dio = dio;

  Future<Directions?> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final directionsResponse =
        await _dio.get(_directionsBaseUrl, queryParameters: {
      'origin': '${origin.latitude},${origin.longitude}',
      'destination': '${destination.latitude},${destination.longitude}',
      'key': apikey,
    });

    if (directionsResponse.statusCode == 200) {
      final directions = Directions.fromMap(directionsResponse.data);
      final hasHighway = await _checkHighway(directions.polylinePoints);
      return Directions(
        bounds: directions.bounds,
        polylinePoints: directions.polylinePoints,
        roadNames: directions.roadNames,
        hasHighway: hasHighway,
      );
    }
    return null;
  }

  Future<bool> _checkHighway(List<PointLatLng> polylinePoints) async {
    final snappedPoints = await _snapToRoads(polylinePoints);

    for (var point in snappedPoints) {
      if (point['roadType'] == 'HIGHWAY') {
        return true;
      }
    }
    return false;
  }

  Future<List<dynamic>> _snapToRoads(List<PointLatLng> polylinePoints) async {
    final points = polylinePoints
        .map((point) => '${point.latitude},${point.longitude}')
        .join('|');

    final response = await _dio.get(_roadsBaseUrl, queryParameters: {
      'path': points,
      'key': apikey,
    });

    if (response.statusCode == 200) {
      return response.data['snappedPoints'];
    }
    return [];
  }
}

class Directions {
  final LatLngBounds bounds;
  final List<PointLatLng> polylinePoints;
  final List<String> roadNames;
  final bool hasHighway;

  static List<String> highwayRoadNames = [
    'Jl. Cilik Riwut',
    'Jl. Ahmad Yani',
    'Jl. Murjani',
    'Jl. Tilung',
    'Jl. Yos Sudarso',
    'Jl. Mahir Mahar',
    'Jl. G.Obos',
    'Jl. Garuda',
    'Jl. K.S. Tubun',
    'Jl. Imam Bonjol',
    'Jl. Diponegoro',
    'Jl. Sethadji',
    'Jl. Kinibalu',
    'Jl. Beliang',
    'Jl. Trans Kalimantan'
  ];

  Directions({
    required this.bounds,
    required this.polylinePoints,
    required this.roadNames,
    required this.hasHighway,
  });

  factory Directions.fromMap(Map<String, dynamic> map) {
    if (map['routes'] == null || (map['routes'] as List).isEmpty) {
      return Directions(
        bounds: LatLngBounds(northeast: LatLng(0, 0), southwest: LatLng(0, 0)),
        polylinePoints: [],
        roadNames: [],
        hasHighway: false,
      );
    }

    final data = Map<String, dynamic>.from(map['routes'][0]);

    final boundsData = data['bounds'];
    final northeast = boundsData != null ? boundsData['northeast'] : null;
    final southwest = boundsData != null ? boundsData['southwest'] : null;

    LatLngBounds bounds;
    if (northeast != null && southwest != null) {
      bounds = LatLngBounds(
        northeast: LatLng(northeast['lat'], northeast['lng']),
        southwest: LatLng(southwest['lat'], southwest['lng']),
      );
    } else {
      bounds = LatLngBounds(northeast: LatLng(0, 0), southwest: LatLng(0, 0));
    }

    bool highwayPresent = false;
    List<String> roadNames = [];

    if (data['legs'] != null) {
      for (var leg in data['legs']) {
        for (var step in leg['steps']) {
          if (step['maneuver'] == 'merge' || step['maneuver'] == 'ramp') {
            highwayPresent = true;
          }
          if (step['html_instructions'] != null) {
            final instruction = step['html_instructions'].toString();
            roadNames.add(instruction);
            // Check if any highway road name matches the instruction
            if (_containsHighwayRoadName(instruction)) {
              highwayPresent = true;
            }
          }
        }
      }
    }

    return Directions(
      bounds: bounds,
      polylinePoints:
          PolylinePoints().decodePolyline(data['overview_polyline']['points']),
      roadNames: roadNames,
      hasHighway: highwayPresent,
    );
  }

  static bool _containsHighwayRoadName(String instruction) {
    // Check if any highway road name matches the instruction
    for (var roadName in highwayRoadNames) {
      if (instruction.toLowerCase().contains(roadName.toLowerCase())) {
        return true;
      }
    }
    return false;
  }
}
