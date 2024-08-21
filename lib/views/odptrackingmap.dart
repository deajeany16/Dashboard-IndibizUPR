// ignore_for_file: unused_element, unnecessary_string_interpolations, no_wildcard_variable_uses, avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:math' show atan2, cos, pi, sin, sqrt;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:webui/controller/layout/layout_controller.dart';
import 'package:webui/controller/odp_controller.dart';
import 'package:webui/helper/services/auth_service.dart';
import 'package:webui/helper/storage/local_storage.dart';
import 'package:webui/helper/theme/admin_theme.dart';
import 'package:webui/helper/theme/app_style.dart';
import 'package:webui/helper/theme/app_theme.dart';
import 'package:webui/helper/theme/theme_customizer.dart';
import 'package:webui/helper/widgets/my_button.dart';
import 'package:webui/helper/widgets/my_container.dart';
import 'package:webui/helper/widgets/my_dashed_divider.dart';
import 'package:webui/helper/widgets/my_spacing.dart';
import 'package:webui/helper/widgets/my_text.dart';
import 'package:webui/models/odp_data.dart';
import 'package:webui/views/directions.dart';
import 'package:webui/views/layout/left_bar.dart';
import 'package:webui/views/layout/top_bar.dart';
import 'package:webui/widgets/custom_pop_menu.dart';

class ODPTrackingMapScreen extends StatefulWidget {
  const ODPTrackingMapScreen({super.key});

  @override
  State<ODPTrackingMapScreen> createState() => _ODPTrackingMapScreenState();
}

class _ODPTrackingMapScreenState extends State<ODPTrackingMapScreen> {
  final locationController = Location();
  final Completer<GoogleMapController> _controller = Completer();
  late ODPController odpController;
  LatLng? currentPosition;
  LatLng? userPosition;
  List<ODP> odpData = [];
  LatLng? nearestODPPosition;
  LatLng? selectedODPPosition;
  List<LatLng> polylineCoordinates = [];
  late BitmapDescriptor personIcon;
  late BitmapDescriptor personIconMobi;
  bool checkhighway = false;
  bool isRecommended = false;
  List<String> roadRoutesNames = [];
  int distanceroute = 0;
  int distanceroutes = 0;
  List<dynamic> odpInRadius = [];
  static const double radarRadius250m = 250;
  List<dynamic> recommendations = [];
  LatLng? lastMarkerPosition;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPersonIcon();
    odpController = Get.put(ODPController());
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchLocationUpdates();
      await loadODPData();
      _findNearestODP();
      _scrollLeft();
      _scrollRight();
    });
  }

  Future<void> fetchLocationUpdates() async {
    bool serviceEnabled = await locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationController.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted =
        await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    locationController.onLocationChanged.listen((LocationData currentLocation) {
      if (mounted) {
        setState(() {
          if (lastMarkerPosition == null) {
            currentPosition =
                LatLng(currentLocation.latitude!, currentLocation.longitude!);
            userPosition = currentPosition;
          }
        });
        detectDataInRadius();
      }
    });
  }

  Future<void> loadODPData() async {
    await odpController.getAllODP();
    setState(() {
      odpData = odpController.semuaODP;
    });
  }

  Future<void> _findNearestODP() async {
    if (currentPosition == null || odpData.isEmpty) return;

    double closestDistance = double.infinity;
    LatLng closestODP = odpData.first.getLatLng();

    for (var odp in odpData) {
      LatLng odpPosition = odp.getLatLng();
      double distance = calculateDistance(currentPosition!, odpPosition);

      // Find the closest ODP
      if (distance < closestDistance) {
        closestDistance = distance;
        closestODP = odpPosition;
      }
    }

    setState(() {
      nearestODPPosition = closestODP;
      if (currentPosition != null && nearestODPPosition != null) {
        _getPolyline(currentPosition!, nearestODPPosition!);
      }
    });
    detectDataInRadius();
  }

  Future<void> detectDataInRadius() async {
    if (currentPosition == null || odpData.isEmpty) return;

    // Initialize odpInRadius list
    odpInRadius.clear();

    // Loop through each ODP
    for (var item in odpData) {
      LatLng position = item.getLatLng();
      double distance = calculateDistance(currentPosition!, position);

      if (distance <= 250) {
        int distances = await getDistanceFromAPI(currentPosition!, position);

        if (kIsWeb) {
          odpInRadius.add({
            'idodp': item.idodp,
            'namaodp': item.namaodp,
            'kategori': item.kategori,
            'latitude': item.latitude,
            'longitude': item.longitude,
            'jarak': distance,
            'checkhighway': checkhighway,
          });
        } else {
          odpInRadius.add({
            'idodp': item.idodp,
            'namaodp': item.namaodp,
            'kategori': item.kategori,
            'latitude': item.latitude,
            'longitude': item.longitude,
            'jarak': distances,
            'checkhighway': checkhighway,
          });
        }
      }
    }
    recommendedProcess(odpInRadius, currentPosition);
  }

  Future<int> getDistanceFromAPI(LatLng origin, LatLng destination) async {
    final directionsLine = DirectionsLine(dio: Dio());
    try {
      final directions = await directionsLine.getDirections(
        origin: origin,
        destination: destination,
      );

      final distanceroutes = directions?.totalDistance ?? 0;
      // Returning the total distance from API in meters
      return distanceroutes;
    } catch (e) {
      print('Error fetching directions: $e');
      return 0;
    }
  }

  Future<void> _getPolyline(LatLng origin, LatLng destination) async {
    if (kIsWeb) {
      setState(() {
        checkhighway = false;
      });
      _calculatePolylineForWeb(origin, destination);
    } else {
      final directionsLine = DirectionsLine(dio: Dio());
      final directions = await directionsLine.getDirections(
        origin: origin,
        destination: destination,
      );

      bool hasHighway = false;
      List<String> roadNames = directions?.roadNames ?? [];
      int distancemaps = directions?.totalDistance ?? 0;

      // Clean up road names
      List<String> cleanedRoadNames = roadNames.map((roadName) {
        return _cleanUpRoadName(roadName);
      }).toList();

      // Check if any road name matches the highway road names
      for (var roadName in cleanedRoadNames) {
        if (_containsHighwayRoadName(roadName)) {
          hasHighway = true;
          break;
        }
      }

      setState(() {
        polylineCoordinates = directions?.polylinePoints
                .map((point) => LatLng(point.latitude, point.longitude))
                .toList() ??
            [];
        checkhighway = hasHighway;
        roadRoutesNames = cleanedRoadNames;
        distanceroute = distancemaps; // Update distances with polyline result
      });

      // print('Road names along the route: ${roadRoutesNames.join(', ')}');
      // print('Route includes highway: $checkhighway');
      // print('Distance : $distanceroute');
    }
  }

  String _cleanUpRoadName(String roadName) {
    // Replace <div> with newlines and remove other HTML tags and entities
    return roadName.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ');
  }

  bool _containsHighwayRoadName(String roadName) {
    // Check if any highway road name matches the given road name
    for (var highwayName in Directions.highwayRoadNames) {
      if (roadName.toLowerCase().contains(highwayName.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  void _calculatePolylineForWeb(LatLng origin, LatLng destination) {
    setState(() {
      polylineCoordinates = [
        origin,
        destination,
      ];
    });
  }

  void _onODPMarkerTapped(LatLng position) {
    // Cari ODP yang sesuai dengan selectedODPPosition saat ini
    ODP? selectedODP;
    for (var odp in odpData) {
      if (odp.getLatLng() == selectedODPPosition) {
        selectedODP = odp;
        break;
      }
    }

    if (selectedODP != null) {
      isRecommended = recommendations.any((recommendation) =>
          recommendation['namaodp'] == selectedODP?.namaodp);
    } else {
      isRecommended = false;
    }

    // Debugging: Print isRecommended status
    // print('isRecommended: $isRecommended');

    if (selectedODPPosition == position) {
      if (selectedODP != null) {
        _showPointDetails(
            context,
            selectedODP.namaodp,
            selectedODP.kapasitas.toString(),
            selectedODP.isi.toString(),
            selectedODP.kosong.toString(),
            selectedODP.reserved.toString(),
            selectedODP.kategori,
            isRecommended);
      }
    } else {
      setState(() {
        selectedODPPosition = position;
      });

      if (currentPosition != null) {
        _getPolyline(currentPosition!, position);
      }
    }
    detectDataInRadius();
  }

  void _scrollToSelectedODP(int idodp) {
    int index = odpInRadius
        .indexWhere((recommendation) => recommendation['idodp'] == idodp);
    if (index != -1) {
      _scrollController.animateTo(index * 100.0,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  Future<void> recommendedProcess(
      List<dynamic> odpInRadius, LatLng? currentPosition) async {
    // URL backend (replace with your backend URL)
    String backendUrl =
        'https://xj9wv6w0-3000.asse.devtunnels.ms/recommend/processrecommend';

    try {
      // Add currentPosition data to the payload
      Map<String, dynamic> payload = {
        'currentPosition': {
          'latitude': currentPosition!.latitude,
          'longitude': currentPosition.longitude,
        },
        'odpInRadius': odpInRadius,
      };

      // Clear previous recommendations
      recommendations.clear();

      // Send POST request to backend
      http.Response response = await http.post(
        Uri.parse(backendUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      // Handle response from backend
      if (response.statusCode == 200) {
        // Parse JSON response
        var responseData = jsonDecode(response.body);
        recommendations = List<dynamic>.from(responseData['recommendations']);
        // Filter out data with 'kategori' as 'hitam'
        recommendations = recommendations
            .where((item) => item['kategori'] != 'HITAM')
            .map((item) {
          return {
            'idodp': item['idodp'],
            'namaodp': item['nama'],
            'kategori': item['kategori'],
            'jarak': item['jarak'],
            'similarity': item['similarity'],
            'highway': item['highway'],
            'distanceScore': item['distanceScore'],
            'categoryScore': item['categoryScore'],
            'latitude': item['latitude'],
            'longitude': item['longitude']
          };
        }).toList();

        print("Data sudah diproses : $recommendations");
      } else {
        print(
            'Failed to send data. Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error sending data to backend: $e');
      // Handle error
    }
  }

  void _updatePolyline(LatLng destination) async {
    if (kIsWeb) {
      setState(() {
        polylineCoordinates = [
          currentPosition!,
          destination,
        ];
      });
    } else {
      final directionsLine = DirectionsLine(dio: Dio());
      final directions = await directionsLine.getDirections(
        origin: currentPosition!,
        destination: destination,
      );

      if (directions != null) {
        setState(() {
          polylineCoordinates = directions.polylinePoints
              .map((point) => LatLng(point.latitude, point.longitude))
              .toList();
        });
      } else {
        setState(() {
          // Handle the case when directions are not available or error occurs
          polylineCoordinates.clear();
        });
      }
    }
  }

  void _loadPersonIcon() async {
    try {
      if (kIsWeb) {
        personIcon = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), 'assets/images/person.png');
      } else {
        personIcon = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), 'assets/images/personMobi.png');
      }
    } catch (e) {
      print('Error loading or resizing person icon: $e');
    }
  }

  // Future<Uint8List> _resizeImage(Uint8List data, int size) async {
  //   try {
  //     final img.Image? image = img.decodeImage(data);
  //     if (image == null) return data;

  //     final img.Image resized =
  //         img.copyResize(image, width: size, height: size);
  //     return Uint8List.fromList(img.encodePng(resized));
  //   } catch (e) {
  //     print('Error resizing image: $e');
  //     return data; // Return original data in case of error
  //   }
  // }

  void _updateCameraPosition(LatLng position) async {
    if (_controller.isCompleted) {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLngZoom(position, 17));
    }
  }

  void _resetPolyline() {
    setState(() {
      polylineCoordinates.clear();
    });
  }

  void _moveToLocation(LatLng latLng) {
    setState(() {
      currentPosition = latLng;
      _updateCameraPosition(currentPosition!);
      _resetPolyline();
    });
    _findNearestODP();
    detectDataInRadius();
  }

  void _handleSearch() {
    String? input = _searchController.text;
    if (input.isNotEmpty) {
      List<String> coordinates = input.split(',');
      if (coordinates.length == 2) {
        double lat = double.tryParse(coordinates[0]) ?? 0.0;
        double lng = double.tryParse(coordinates[1]) ?? 0.0;
        _moveToLocation(LatLng(lat, lng));
        _findNearestODP();
        detectDataInRadius();
      } else {
        // Handle invalid input format
        print('Invalid input format. Please enter "lat,lng".');
      }
    }
  }

  int _lastClickedIndex = -1;
  final ScrollController _scrollController = ScrollController();

  void _scrollLeft() {
    _scrollController.animateTo(
      _scrollController.position.pixels - 100,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    _scrollController.animateTo(
      _scrollController.position.pixels + 100,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = !kIsWeb && MediaQuery.of(context).size.width < 600;
    String? nama = LocalStorage.getNama();

    if (isMobile) {
      return Scaffold(
        appBar: AppBar(
          actions: [
            CustomPopupMenu(
              backdrop: true,
              onChange: (_) {},
              offsetX: -180,
              menu: Padding(
                padding: MySpacing.xy(8, 8),
                child: Center(
                  child: Icon(
                    Icons.notifications,
                    size: 18,
                  ),
                ),
              ),
              menuBuilder: (_) => buildNotifications(),
            ),
            MySpacing.width(8),
            CustomPopupMenu(
              backdrop: true,
              onChange: (_) {},
              offsetX: -90,
              offsetY: 4,
              hideFn: (_) => accountHideFn = _,
              menu: Padding(
                padding: MySpacing.xy(8, 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MyContainer.rounded(
                        paddingAll: 0,
                        child: Icon(Icons.account_circle_outlined)),
                    MySpacing.width(8),
                    MyText.labelLarge(nama ?? 'user')
                  ],
                ),
              ),
              menuBuilder: (_) => buildAccountMenu(),
            ),
            MySpacing.width(20)
          ],
        ),
        drawer: LeftBar(),
        body: Stack(
          children: [
            if (currentPosition != null)
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: currentPosition ?? LatLng(0, 0),
                  zoom: 14.0,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  if (currentPosition != null) {
                    _moveToLocation(currentPosition!);
                  }
                },
                markers: {
                  if (currentPosition != null)
                    Marker(
                      markerId: const MarkerId('currentLocation'),
                      icon: personIcon,
                      position: currentPosition!,
                      draggable: true,
                      onDragEnd: (newPosition) {
                        setState(() {
                          lastMarkerPosition = newPosition;
                          currentPosition = newPosition;
                        });
                        _moveToLocation(newPosition);
                      },
                    ),
                  for (var odp in odpData)
                    Marker(
                      markerId: MarkerId(odp.idodp.toString()),
                      icon: BitmapDescriptor.defaultMarker,
                      position: odp.getLatLng(),
                      onTap: () {
                        _onODPMarkerTapped(odp.getLatLng());
                      },
                    ),
                },
                circles: <Circle>{
                  Circle(
                    circleId: CircleId('radarZone250m'),
                    center: currentPosition!,
                    radius: radarRadius250m,
                    strokeWidth: 2,
                    strokeColor: Colors.blue.withOpacity(0.5),
                    fillColor: Colors.blue.withOpacity(0.2),
                  ),
                },
                polylines: <Polyline>{
                  if (polylineCoordinates.isNotEmpty)
                    Polyline(
                      polylineId: PolylineId('routeToODP'),
                      points: polylineCoordinates,
                      color: Colors.green,
                      width: 5,
                    ),
                },
              ),
            Positioned(
              top: 16.0,
              left: MediaQuery.of(context).size.width * 0.1,
              right: MediaQuery.of(context).size.width * 0.1,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.1,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5.0,
                      spreadRadius: 2.0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Lat,Lng (-1.2345,3.4567)',
                            hintStyle: TextStyle(
                              fontSize: isMobile ? 14 : 18,
                              // Ukuran font dinamis
                            ),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _handleSearch,
                      icon: const Icon(Icons.search),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                bottom: 100,
                left: MediaQuery.of(context).size.width * 0.05,
                child: Text('List Rekomendasi')),
            Positioned(
              bottom: 20,
              left: 5,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.85,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios,
                          size: 16, color: Colors.grey[800]),
                      onPressed: _scrollLeft,
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            recommendations.length, // Use recommendations here
                        itemBuilder: (context, index) {
                          final recommendation = recommendations[index];
                          final odpDetail = odpData.firstWhere(
                              (odp) => odp.idodp == recommendation['idodp']);

                          return GestureDetector(
                            onTap: () {
                              if (_lastClickedIndex == index) {
                                _showPointDetails(
                                  context,
                                  odpDetail.namaodp,
                                  odpDetail.kapasitas.toString(),
                                  odpDetail.isi.toString(),
                                  odpDetail.kosong.toString(),
                                  odpDetail.reserved.toString(),
                                  odpDetail.kategori,
                                  isRecommended,
                                );
                              } else {
                                _updatePolyline(LatLng(
                                  recommendation['latitude'],
                                  recommendation['longitude'],
                                ));
                                _lastClickedIndex = index;
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 10),
                              height: MediaQuery.of(context).size.height * 0.2,
                              width: 120,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 5.0,
                                    spreadRadius: 2.0,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '${recommendation['namaodp']}',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    '${recommendation['kategori']}',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                  Text(
                                    'Jarak: ${recommendation['jarak'].toStringAsFixed(2)} meter',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward_ios,
                          size: 16, color: Colors.grey[800]),
                      onPressed: _scrollRight,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: Container(
          margin: EdgeInsets.only(bottom: 80.0),
          child: FloatingActionButton(
            onPressed: () {
              if (userPosition != null) {
                _moveToLocation(userPosition!);
                _findNearestODP();
              }
            },
            backgroundColor: Colors.grey[800],
            child: const Icon(Icons.gps_fixed),
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Row(
          children: [
            LeftBar(isCondensed: ThemeCustomizer.instance.leftBarCondensed),
            Expanded(
              child: Column(
                children: [
                  TopBar(),
                  Expanded(
                    child: Stack(
                      children: [
                        if (currentPosition != null)
                          GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: currentPosition ?? LatLng(0, 0),
                              zoom: 14.0,
                            ),
                            onMapCreated: (GoogleMapController controller) {
                              _controller.complete(controller);
                              if (currentPosition != null) {
                                _moveToLocation(currentPosition!);
                              }
                            },
                            markers: {
                              if (currentPosition != null)
                                Marker(
                                  markerId: const MarkerId('currentLocation'),
                                  icon: personIcon,
                                  position: currentPosition!,
                                  draggable: true,
                                  onDragEnd: (newPosition) {
                                    setState(() {
                                      lastMarkerPosition = newPosition;
                                      currentPosition = newPosition;
                                    });
                                    _moveToLocation(newPosition);
                                  },
                                ),
                              for (var odp in odpData)
                                Marker(
                                  markerId: MarkerId(odp.idodp.toString()),
                                  icon: BitmapDescriptor.defaultMarker,
                                  position: odp.getLatLng(),
                                  onTap: () {
                                    _onODPMarkerTapped(odp.getLatLng());
                                  },
                                ),
                            },
                            circles: <Circle>{
                              Circle(
                                circleId: CircleId('radarZone250m'),
                                center: currentPosition!,
                                radius: radarRadius250m,
                                strokeWidth: 2,
                                strokeColor: Colors.blue.withOpacity(0.5),
                                fillColor: Colors.blue.withOpacity(0.2),
                              ),
                            },
                            polylines: <Polyline>{
                              if (polylineCoordinates.isNotEmpty)
                                Polyline(
                                  polylineId: PolylineId('routeToODP'),
                                  points: polylineCoordinates,
                                  color: Colors.green,
                                  width: 5,
                                ),
                            },
                          ),
                        Positioned(
                          top: 16.0,
                          left: MediaQuery.of(context).size.width * 0.1,
                          right: MediaQuery.of(context).size.width * 0.1,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 5.0,
                                  spreadRadius: 2.0,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: TextField(
                                      controller: _searchController,
                                      decoration: InputDecoration(
                                        hintText: 'Lat,Lng (-1.2345,3.4567)',
                                        hintStyle: TextStyle(
                                          fontSize: isMobile
                                              ? 14
                                              : 18, // Ukuran font dinamis
                                        ),
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: _handleSearch,
                                  icon: const Icon(Icons.search),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                            bottom: 90,
                            left: MediaQuery.of(context).size.width * 0.05,
                            child: Text('List Rekomendasi')),
                        Positioned(
                          bottom: 20,
                          left: 5,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.arrow_back_ios,
                                      size: 16, color: Colors.grey[800]),
                                  onPressed: _scrollLeft,
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    controller: _scrollController,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: recommendations.length,
                                    itemBuilder: (context, index) {
                                      final recommendation =
                                          recommendations[index];
                                      final odpDetail = odpData.firstWhere(
                                          (odp) =>
                                              odp.idodp ==
                                              recommendation['idodp']);

                                      return GestureDetector(
                                        onTap: () {
                                          if (_lastClickedIndex == index) {
                                            _showPointDetails(
                                              context,
                                              odpDetail.namaodp,
                                              odpDetail.kapasitas.toString(),
                                              odpDetail.isi.toString(),
                                              odpDetail.kosong.toString(),
                                              odpDetail.reserved.toString(),
                                              odpDetail.kategori,
                                              isRecommended,
                                            );
                                          } else {
                                            _updatePolyline(LatLng(
                                              recommendation['latitude'],
                                              recommendation['longitude'],
                                            ));
                                            _lastClickedIndex = index;
                                          }
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(right: 10),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.1,
                                          width: 120,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black26,
                                                blurRadius: 5.0,
                                                spreadRadius: 2.0,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '${recommendation['namaodp']}',
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                                Text(
                                                  '${recommendation['kategori']}',
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                ),
                                                Text(
                                                  'Jarak: ${recommendation['jarak'].toStringAsFixed(2)} meter',
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.arrow_forward_ios,
                                      size: 16, color: Colors.grey[800]),
                                  onPressed: _scrollRight,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: Container(
          margin: EdgeInsets.only(bottom: 80.0),
          child: FloatingActionButton(
            onPressed: () {
              if (userPosition != null) {
                _moveToLocation(userPosition!);
                _findNearestODP();
              }
            },
            backgroundColor: Colors.grey[800],
            child: const Icon(Icons.gps_fixed),
          ),
        ),
      );
    }
  }

  void _showPointDetails(
      BuildContext context,
      String name,
      String kapasitas,
      String isi,
      String kosong,
      String reserved,
      String kategori,
      bool isRecommended) {
    final textStyleWeb = TextStyle(
      fontSize: 14,
      color: Colors.black,
      decoration: TextDecoration.none,
    );
    final textStyleMobile = TextStyle(
      fontSize: 12,
      color: Colors.black,
      decoration: TextDecoration.none,
    );

    if (MediaQuery.of(context).size.width < 600) {
      // Tampilan mobile: tampilkan sebagai modal bottom sheet
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height / 2,
            ),
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Text(
                      isRecommended
                          ? 'Titik ini direkomendasikan untuk digunakan oleh calon pelanggan'
                          : 'Titik ini TIDAK direkomendasikan untuk digunakan oleh calon pelanggan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isRecommended ? Colors.green : Colors.red,
                        decoration: TextDecoration.none,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                      height: 20,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Nama : $name',
                      style: textStyleMobile,
                    ),
                    SizedBox(height: 7),
                    Text(
                      'Latitude : ${currentPosition!.latitude}',
                      style: textStyleMobile,
                    ),
                    SizedBox(height: 7),
                    Text(
                      'Longitude : ${currentPosition!.longitude}',
                      style: textStyleMobile,
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Status ODP',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(height: 7),
                    Text(
                      'Kapasitas : $kapasitas',
                      style: textStyleMobile,
                    ),
                    SizedBox(height: 7),
                    Text(
                      'Isi : $isi',
                      style: textStyleMobile,
                    ),
                    SizedBox(height: 7),
                    Text(
                      'Kosong : $kosong',
                      style: textStyleMobile,
                    ),
                    SizedBox(height: 7),
                    Text(
                      'Reserved : $reserved',
                      style: textStyleMobile,
                    ),
                    SizedBox(height: 7),
                    Text(
                      'Kategori : $kategori',
                      style: textStyleMobile,
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Informasi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(height: 7),
                    if (currentPosition != null)
                      Text(
                        'Jarak: $distanceroute meter',
                        style: textStyleMobile,
                      ),
                    SizedBox(height: 10),
                    Text(
                      'Saran Wilayah Prioritas Promosi : ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(height: 5),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/ordersurveimap');
                      },
                      child: Text(
                        'Klik disini',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Jalan Protokol : ${checkhighway ? 'Lewat' : 'Tidak'}', // Tampilkan status highway
                      style: textStyleMobile,
                    ),
                    SizedBox(height: 10),
                    Text('Roads along the route:', style: textStyleMobile),
                    for (var road in roadRoutesNames)
                      Text(road, style: textStyleMobile),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else {
      // Tampilan web: tampilkan sebagai popup di sisi kanan layar
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Align(
            alignment: Alignment.centerRight,
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width / 3,
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      isRecommended
                          ? 'Titik ini direkomendasikan untuk digunakan oleh calon pelanggan'
                          : 'Titik ini TIDAK direkomendasikan untuk digunakan oleh calon pelanggan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isRecommended ? Colors.green : Colors.red,
                        decoration: TextDecoration.none,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                      height: 20,
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Nama : $name',
                      style: textStyleWeb,
                    ),
                    SizedBox(height: 7),
                    Text(
                      'Latitude : ${currentPosition!.latitude}',
                      style: textStyleWeb,
                    ),
                    SizedBox(height: 7),
                    Text(
                      'Longitude : ${currentPosition!.longitude}',
                      style: textStyleWeb,
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Status ODP',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Kapasitas : $kapasitas',
                      style: textStyleWeb,
                    ),
                    SizedBox(height: 7),
                    Text(
                      'Isi : $isi',
                      style: textStyleWeb,
                    ),
                    SizedBox(height: 7),
                    Text(
                      'Kosong : $kosong',
                      style: textStyleWeb,
                    ),
                    SizedBox(height: 7),
                    Text(
                      'Reserved : $reserved',
                      style: textStyleWeb,
                    ),
                    SizedBox(height: 7),
                    Text(
                      'Kategori : $kategori',
                      style: textStyleWeb,
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Informasi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(height: 15),
                    if (currentPosition != null)
                      Text(
                        'Jarak: ${calculateDistance(currentPosition!, selectedODPPosition!).toStringAsFixed(2)} meter',
                        style: textStyleWeb,
                      ),
                    SizedBox(height: 30),
                    Text(
                      'Saran Wilayah Prioritas Promosi : ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(height: 5),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/ordersurveimap');
                      },
                      child: Text(
                        'Klik disini',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }

  double calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadius = 6371000;
    double lat1 = point1.latitude;
    double lon1 = point1.longitude;
    double lat2 = point2.latitude;
    double lon2 = point2.longitude;
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degrees) {
    return degrees * (pi / 180);
  }
}

// Layout Appbar //

final LayoutController controller = LayoutController();
final topBarTheme = AdminTheme.theme.topBarTheme;
final contentTheme = AdminTheme.theme.contentTheme;
late Function accountHideFn;

Widget buildNotifications() {
  Widget buildNotification(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText.labelLarge(title),
        MySpacing.height(4),
        MyText.bodySmall(description)
      ],
    );
  }

  return MyContainer.bordered(
    paddingAll: 0,
    width: 250,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: MySpacing.xy(16, 12),
          child: MyText.titleMedium("Notification", fontWeight: 600),
        ),
        MyDashedDivider(
            height: 1, color: theme.dividerColor, dashSpace: 4, dashWidth: 6),
        Padding(
          padding: MySpacing.xy(16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              // buildNotification("Your order is received",
              //     "Order #1232 is ready to deliver"),
              // MySpacing.height(12),
              // buildNotification("Account Security ",
              //     "Your account password changed 1 hour ago"),
            ],
          ),
        ),
        MyDashedDivider(
            height: 1, color: theme.dividerColor, dashSpace: 4, dashWidth: 6),
        Padding(
          padding: MySpacing.xy(16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyButton.text(
                onPressed: () {},
                splashColor: contentTheme.primary.withAlpha(28),
                child: MyText.labelSmall(
                  "View All",
                  color: contentTheme.primary,
                ),
              ),
              MyButton.text(
                onPressed: () {},
                splashColor: contentTheme.danger.withAlpha(28),
                child: MyText.labelSmall(
                  "Clear",
                  color: contentTheme.danger,
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}

Widget buildAccountMenu() {
  return MyContainer.bordered(
    paddingAll: 0,
    width: 150,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: MySpacing.xy(8, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyButton(
                elevation: 0,
                onPressed: () => {},
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                borderRadiusAll: AppStyle.buttonRadius.medium,
                padding: MySpacing.xy(8, 4),
                splashColor: theme.colorScheme.onSurface.withAlpha(20),
                backgroundColor: Colors.transparent,
                child: Row(
                  children: [
                    Icon(
                      Icons.person_2_outlined,
                      size: 14,
                      color: contentTheme.onBackground,
                    ),
                    MySpacing.width(8),
                    MyText.labelMedium(
                      "My Account",
                      fontWeight: 600,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 1,
          thickness: 1,
        ),
        Padding(
          padding: MySpacing.xy(8, 8),
          child: MyButton(
            elevation: 0,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onPressed: () {
              AuthService.isLoggedIn = false;
              LocalStorage.setLoggedInUser(false);
              LocalStorage.setToken('');
              Get.offAllNamed('/auth/login');
              accountHideFn.call();
            },
            borderRadiusAll: AppStyle.buttonRadius.medium,
            padding: MySpacing.xy(8, 4),
            splashColor: contentTheme.danger.withAlpha(28),
            backgroundColor: Colors.transparent,
            child: Row(
              children: [
                Icon(
                  Icons.logout,
                  size: 14,
                  color: contentTheme.danger,
                ),
                MySpacing.width(8),
                MyText.labelMedium(
                  "Log out",
                  fontWeight: 600,
                  color: contentTheme.danger,
                )
              ],
            ),
          ),
        )
      ],
    ),
  );
}
