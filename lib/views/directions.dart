import 'package:dio/dio.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:webui/app_constant.dart';

class DirectionsLine {
  static const String _directionsBaseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';
  static const String _distanceMatrixBaseUrl =
      'https://maps.googleapis.com/maps/api/distancematrix/json?';
  static const String _roadsBaseUrl =
      'https://roads.googleapis.com/v1/snapToRoads?';

  final Dio _dio;
  DirectionsLine({required Dio dio}) : _dio = dio;

  Future<Directions?> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    try {
      final response = await _dio.get(_directionsBaseUrl, queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'key': apikey,
      });

      if (response.statusCode == 200) {
        final directions = Directions.fromMap(response.data);
        final hasHighway = await _checkHighway(directions.polylinePoints);
        return Directions(
          bounds: directions.bounds,
          polylinePoints: directions.polylinePoints,
          roadNames: directions.roadNames,
          hasHighway: hasHighway,
          totalDistance: directions.totalDistance,
        );
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching directions: $e');
      return null;
    }
  }

  Future<DistanceMatrix?> getDistanceMatrix({
    required LatLng origin,
    required List<LatLng> destinations,
  }) async {
    try {
      final destinationStr = destinations
          .map((dest) => '${dest.latitude},${dest.longitude}')
          .join('|');

      final response = await _dio.get(_distanceMatrixBaseUrl, queryParameters: {
        'origins': '${origin.latitude},${origin.longitude}',
        'destinations': destinationStr,
        'key': apikey,
      });

      if (response.statusCode == 200) {
        return DistanceMatrix.fromMap(response.data);
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching distance matrix: $e');
      return null;
    }
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

class DistanceMatrix {
  final List<DistanceMatrixElement> elements;

  DistanceMatrix({required this.elements});

  factory DistanceMatrix.fromMap(Map<String, dynamic> map) {
    if (map['rows'] == null || (map['rows'] as List).isEmpty) {
      return DistanceMatrix(elements: []);
    }

    final elements = (map['rows'][0]['elements'] as List)
        .map((e) => DistanceMatrixElement.fromMap(e))
        .toList();

    return DistanceMatrix(elements: elements);
  }
}

class DistanceMatrixElement {
  final int distance; // in meters
  final int duration; // in seconds

  DistanceMatrixElement({
    required this.distance,
    required this.duration,
  });

  factory DistanceMatrixElement.fromMap(Map<String, dynamic> map) {
    return DistanceMatrixElement(
      distance: map['distance']['value'],
      duration: map['duration']['value'],
    );
  }
}

class Directions {
  final LatLngBounds bounds;
  final List<PointLatLng> polylinePoints;
  final List<String> roadNames;
  final bool hasHighway;
  final int totalDistance;

  static List<String> highwayRoadNames = [
    'Jl. Cilik Riwut',
    'Jl. Rajawali',
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
    'Jl. Trans Kalimantan',
    'Jl. Adonis Samad',
    'Jl. RTA Milono'
  ];

  Directions({
    required this.bounds,
    required this.polylinePoints,
    required this.roadNames,
    required this.hasHighway,
    required this.totalDistance,
  });

  factory Directions.fromMap(Map<String, dynamic> map) {
    if (map['routes'] == null || (map['routes'] as List).isEmpty) {
      return Directions(
        bounds: LatLngBounds(northeast: LatLng(0, 0), southwest: LatLng(0, 0)),
        polylinePoints: [],
        roadNames: [],
        totalDistance: 0,
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
    int distance = 0;

    if (data['legs'] != null) {
      for (var leg in data['legs']) {
        distance = leg['distance']['value'];
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
      totalDistance: distance,
      hasHighway: highwayPresent,
    );
  }

  static bool _containsHighwayRoadName(String instruction) {
    final pattern = highwayRoadNames
        .map((name) =>
            RegExp(r'\b' + RegExp.escape(name) + r'\b', caseSensitive: false))
        .toList();

    return pattern.any((regex) => regex.hasMatch(instruction));
  }
}
