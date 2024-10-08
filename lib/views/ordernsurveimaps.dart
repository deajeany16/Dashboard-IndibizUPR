// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:math' show atan2, cos, pi, sin, sqrt;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show ByteData, Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:location/location.dart';
import 'package:webui/controller/alternatif_controller.dart';
import 'package:webui/controller/inputan_controller.dart';
import 'package:webui/controller/odp_controller.dart';
import 'package:webui/controller/survei_controller.dart';
import 'package:webui/helper/storage/local_storage.dart';
import 'package:webui/helper/theme/theme_customizer.dart';
import 'package:webui/helper/widgets/my_container.dart';
import 'package:webui/helper/widgets/my_spacing.dart';
import 'package:webui/helper/widgets/my_text.dart';
import 'package:webui/models/inputan_data.dart';
import 'package:webui/models/odp_data.dart';
import 'package:webui/models/survei_data.dart';
import 'package:webui/models/wpalternatif_data.dart';
import 'package:webui/views/directions.dart';
import 'package:webui/views/layout/left_bar.dart';
import 'package:webui/views/layout/top_bar.dart';
import 'package:webui/views/odptrackingmap.dart';
import 'package:webui/widgets/custom_pop_menu.dart';

class OrderSurveiMapScreen extends StatefulWidget {
  const OrderSurveiMapScreen({super.key});

  @override
  State<OrderSurveiMapScreen> createState() => _OrderSurveiMapScreenState();
}

class _OrderSurveiMapScreenState extends State<OrderSurveiMapScreen> {
  final locationController = Location();
  final Completer<GoogleMapController> _controller = Completer();
  late ODPController odpController;
  LatLng? currentPosition;
  LatLng? userPosition;
  List<ODP> odpData = [];
  LatLng? nearestODPPosition;
  LatLng? selectedODPPosition;
  LatLng? selectedSurveiPosition;
  LatLng? selectedOrderPosition;
  List<LatLng> polylineCoordinates = [];
  late BitmapDescriptor personIcon;
  bool checkhighway = false;
  bool isRecommended = false;
  List<String> roadRoutesNames = [];
  List<dynamic> odpInRadius = [];
  List<dynamic> orderInRadius = [];
  List<dynamic> surveiInRadius = [];

  late BitmapDescriptor surveipin;
  late BitmapDescriptor orderpin;
  late InputanController orderController;
  late SurveiController surveiController;
  List<Survei> surveiData = [];
  List<Inputan> orderData = [];

  static const double radarRadius250m = 250;
  static const double radarRadius1000m = 1000;
  static const double radarRadius500m = 500;
  static const double radarRadius750m = 750;

  List<dynamic> detectedData250mnorth = [];
  List<dynamic> detectedData250msouth = [];
  List<dynamic> detectedData500mnorth = [];
  List<dynamic> detectedData500msouth = [];
  List<dynamic> detectedData750mnorth = [];
  List<dynamic> detectedData750msouth = [];
  List<dynamic> detectedData1000mnorth = [];
  List<dynamic> detectedData1000msouth = [];

  List<String> polygonCodes = [];
  String? firstPolygonCode;

  List<dynamic> alternativesData = [];
  List<Alternatif> altData = [];
  late AlternatifController altController;

  LatLng? lastMarkerPosition;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPersonIcon();
    _loadSurvei();
    _loadOrder();
    odpController = Get.put(ODPController());
    orderController = Get.put(InputanController());
    surveiController = Get.put(SurveiController());
    altController = Get.put(AlternatifController());
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
        // detectDataInRadius();
      }
    });
  }

  Future<void> loadODPData() async {
    await odpController.getAllODP();
    await orderController.getAllOrder();
    await surveiController.getAllSurvei();
    await altController.getallAlternatif();
    setState(() {
      odpData = odpController.semuaODP;
      orderData = orderController.semuaInputan;
      surveiData = surveiController.allSurvei;
      altData = altController.allAlternatif;
    });
  }

  void _findNearestODP() {
    if (currentPosition == null || odpData.isEmpty) return;

    double closestDistance = double.infinity;
    LatLng closestODP = odpData.first.getLatLng();

    for (var odp in odpData) {
      LatLng odpPosition = odp.getLatLng();
      double distance = calculateDistance(currentPosition!, odpPosition);
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
      });

      // print('Road names along the route: ${roadRoutesNames.join(', ')}');
      // print('Route includes highway: $checkhighway');
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

  void _onODPMarkerTapped(LatLng odpposition) {
    // Cari ODP yang sesuai dengan selectedODPPosition saat ini
    ODP? selectedODP;
    for (var odp in odpData) {
      if (odp.getLatLng() == selectedODPPosition) {
        selectedODP = odp;
        break;
      }
    }

    if (selectedODPPosition == odpposition) {
      if (selectedODP != null) {
        _showPointDetails(
          context,
          selectedODP.namaodp,
          selectedODP.kapasitas.toString(),
          selectedODP.isi.toString(),
          selectedODP.kosong.toString(),
          selectedODP.reserved.toString(),
          selectedODP.kategori,
        );
      }
    } else {
      setState(() {
        selectedODPPosition = odpposition;
      });

      if (currentPosition != null) {
        _getPolyline(currentPosition!, odpposition);
      }
      detectDataInRadius();
    }
  }

  void _onSurveiMarkerTapped(LatLng surveiposition) {
    // Cari survei yang sesuai dengan selectedSurveiPosition saat ini
    print("Survei marker tapped at: $surveiposition");

    Survei? selectedSurvei;
    for (var survei in surveiData) {
      if (survei.getLatLng() == selectedSurveiPosition) {
        selectedSurvei = survei;
        break;
      }
    }

    if (selectedSurveiPosition == surveiposition) {
      if (selectedSurvei != null) {
        _showSurveiDetails(
            context, selectedSurvei.namausaha, selectedSurvei.jenisusaha);
      }
    } else {
      setState(() {
        selectedSurveiPosition = surveiposition;
      });

      if (currentPosition != null) {
        _getPolyline(currentPosition!, surveiposition);
      }
      detectDataInRadius();
    }
  }

  void _onOrderMarkerTapped(LatLng orderposition) {
    // Cari order yang sesuai dengan selectedOrderPosition saat ini
    print("Order marker tapped at: $orderposition");

    Inputan? selectedOrder;
    for (var order in orderData) {
      if (order.getLatLng() == selectedOrderPosition) {
        selectedOrder = order;
        break;
      }
    }

    if (selectedOrderPosition == orderposition) {
      if (selectedOrder != null) {
        _showOrderDetails(context, selectedOrder.namaperusahaan);
      }
    } else {
      setState(() {
        selectedOrderPosition = orderposition;
      });

      if (currentPosition != null) {
        _getPolyline(currentPosition!, orderposition);
      }
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

  bool isWithinRadius(LatLng center, LatLng point, double radiusInMeters) {
    const double earthRadius = 6371000; // Radius bumi dalam meter

    double dLat = (point.latitude - center.latitude) * pi / 180;
    double dLng = (point.longitude - center.longitude) * pi / 180;

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(center.latitude * pi / 180) *
            cos(point.latitude * pi / 180) *
            sin(dLng / 2) *
            sin(dLng / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double distance = earthRadius * c;
    return distance <= radiusInMeters;
  }

  bool isWithinNorthRadius(LatLng center, LatLng point, double radiusInMeters) {
    return point.latitude > center.latitude &&
        isWithinRadius(center, point, radiusInMeters);
  }

  bool isWithinSouthRadius(LatLng center, LatLng point, double radiusInMeters) {
    return point.latitude < center.latitude &&
        isWithinRadius(center, point, radiusInMeters);
  }

  void detectDataInRadius() {
    if (currentPosition == null) return;

    detectedData250mnorth.clear(); // Clear previous data
    detectedData500mnorth.clear(); // Clear previous data
    detectedData750mnorth.clear();
    detectedData1000mnorth.clear();
    detectedData250msouth.clear(); // Clear previous data
    detectedData500msouth.clear(); // Clear previous data
    detectedData750msouth.clear();
    detectedData1000msouth.clear();

    // Data yang akan dikirim
    Map<String, List<dynamic>> detectedData = {
      "detectedData250mnorth": [],
      "detectedData250msouth": [],
      "detectedData500mnorth": [],
      "detectedData500msouth": [],
      "detectedData750mnorth": [],
      "detectedData750msouth": [],
      "detectedData1000mnorth": [],
      "detectedData1000msouth": []
    };

    void addDetectedData(List<dynamic> data, String type) {
      for (var item in data) {
        LatLng position = item.getLatLng();
        double distance = calculateDistance(currentPosition!, position);
        String direction =
            (position.latitude > currentPosition!.latitude) ? "north" : "south";

        Map<String, dynamic> detectedItem = {
          "type": type,
          // Assign the correct key name and value based on the type
          if (type == "ODP") "idodp": item.idodp,
          if (type == "Order") "orderid": item.orderid,
          if (type == "Survei") "idsurvei": item.idsurvei,
          "position": direction,
        };

        if (distance <= 250) {
          if (direction == "north") {
            detectedData["detectedData250mnorth"]!.add(detectedItem);
          } else {
            detectedData["detectedData250msouth"]!.add(detectedItem);
          }
        } else if (distance > 250 && distance <= 500) {
          if (direction == "north") {
            detectedData["detectedData500mnorth"]!.add(detectedItem);
          } else {
            detectedData["detectedData500msouth"]!.add(detectedItem);
          }
        } else if (distance > 500 && distance <= 750) {
          if (direction == "north") {
            detectedData["detectedData750mnorth"]!.add(detectedItem);
          } else {
            detectedData["detectedData750msouth"]!.add(detectedItem);
          }
        } else if (distance > 750 && distance <= 1000) {
          if (direction == "north") {
            detectedData["detectedData1000mnorth"]!.add(detectedItem);
          } else {
            detectedData["detectedData1000msouth"]!.add(detectedItem);
          }
        }
      }
    }

    // Deteksi ODP
    addDetectedData(odpData, "ODP");
    // Deteksi Order
    addDetectedData(orderData, "Order");
    // Deteksi Survei
    addDetectedData(surveiData, "Survei");

    print("Detected Data: ${jsonEncode(detectedData)}\n");

    sendDetectedDataToProcessStrategic(detectedData);
  }

  Future<void> sendDetectedDataToProcessStrategic(
      Map<String, List<dynamic>> detectedData) async {
    final apiUrl =
        'https://xj9wv6w0-3000.asse.devtunnels.ms/strategic/processstrategic';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(detectedData),
      );

      if (response.statusCode == 200) {
        print('Data berhasil dikirim.');
        setState(() {
          var responseData = jsonDecode(response.body);
          if (responseData != null &&
              responseData['data'] != null &&
              responseData['data'].isNotEmpty) {
            // Process the response data here
            // For example, store the first alternative code in a variable
            firstPolygonCode = responseData['data'][0]['kode'];

            // Example of processing the complete response data
            alternativesData = responseData['data'];
          }
        });
      } else {
        print('Gagal mengirim data: ${response.statusCode}');
      }
    } catch (e) {
      print('Terjadi kesalahan saat mengirim data: $e');
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

  void _loadSurvei() async {
    try {
      if (kIsWeb) {
        surveipin = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), 'assets/images/pin1.png');
      } else {
        surveipin = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), 'assets/images/pin1Mobi.png');
      }
    } catch (e) {
      print('Error loading or resizing person icon: $e');
      // Handle error, e.g., show default icon or retry loading
    }
  }

  void _loadOrder() async {
    try {
      if (kIsWeb) {
        orderpin = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), 'assets/images/pin2.png');
      } else {
        orderpin = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), 'assets/images/pin2Mobi.png');
      }
    } catch (e) {
      print('Error loading or resizing person icon: $e');
      // Handle error, e.g., show default icon or retry loading
    }
  }

  Future<Uint8List> _resizeImage(Uint8List data, int size) async {
    try {
      final img.Image? image = img.decodeImage(data);
      if (image == null) return data;

      final img.Image resized =
          img.copyResize(image, width: size, height: size);
      return Uint8List.fromList(img.encodePng(resized));
    } catch (e) {
      print('Error resizing image: $e');
      return data; // Return original data in case of error
    }
  }

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
      } else {
        // Handle invalid input format
        print('Invalid input format. Please enter "lat,lng".');
      }
    }
  }

  List<LatLng> _createSemiCircle(
      LatLng center, double innerRadius, double outerRadius, bool isNorth) {
    List<LatLng> points = [];
    final int segments = 180; // Banyaknya titik dalam setengah lingkaran

    // Membuat setengah lingkaran luar
    for (int i = 0; i <= segments; i++) {
      double theta = (i * 1.0 / segments) *
          3.14159; // 0 hingga pi untuk setengah lingkaran
      if (!isNorth) {
        theta +=
            3.14159; // Jika setengah lingkaran selatan, geser theta sebesar pi
      }
      double dx = outerRadius * 0.0000089 * cos(theta);
      double dy = outerRadius * 0.0000089 * sin(theta);
      points.add(LatLng(center.latitude + dy, center.longitude + dx));
    }

    // Membuat setengah lingkaran dalam secara terbalik
    for (int i = segments; i >= 0; i--) {
      double theta = (i * 1.0 / segments) *
          3.14159; // 0 hingga pi untuk setengah lingkaran
      if (!isNorth) {
        theta +=
            3.14159; // Jika setengah lingkaran selatan, geser theta sebesar pi
      }
      double dx = innerRadius * 0.0000089 * cos(theta);
      double dy = innerRadius * 0.0000089 * sin(theta);
      points.add(LatLng(center.latitude + dy, center.longitude + dx));
    }

    return points;
  }

  Set<Polygon> _buildPolygons() {
    Set<Polygon> polygons = {};
    final center = currentPosition!;

    if (firstPolygonCode != null) {
      if (firstPolygonCode == 'A1') {
        polygons.add(Polygon(
          polygonId: PolygonId('A1'),
          points: _createSemiCircle(center, 0, 250, true),
          fillColor: Colors.red.withOpacity(0.5),
          strokeColor: Colors.red,
          strokeWidth: 2,
        ));
      } else if (firstPolygonCode == 'A2') {
        polygons.add(Polygon(
          polygonId: PolygonId('A2'),
          points: _createSemiCircle(center, 0, 250, false),
          fillColor: Colors.green.withOpacity(0.5),
          strokeColor: Colors.green,
          strokeWidth: 2,
        ));
      } else if (firstPolygonCode == 'A3') {
        polygons.add(Polygon(
          polygonId: PolygonId('A3'),
          points: _createSemiCircle(center, 250, 500, true),
          fillColor: Colors.blue.withOpacity(0.5),
          strokeColor: Colors.blue,
          strokeWidth: 2,
        ));
      } else if (firstPolygonCode == 'A4') {
        polygons.add(Polygon(
          polygonId: PolygonId('A4'),
          points: _createSemiCircle(center, 250, 500, false),
          fillColor: Colors.yellow.withOpacity(0.5),
          strokeColor: Colors.yellow,
          strokeWidth: 2,
        ));
      } else if (firstPolygonCode == 'A5') {
        polygons.add(Polygon(
          polygonId: PolygonId('A5'),
          points: _createSemiCircle(center, 500, 750, true),
          fillColor: Colors.purple.withOpacity(0.5),
          strokeColor: Colors.purple,
          strokeWidth: 2,
        ));
      } else if (firstPolygonCode == 'A6') {
        polygons.add(Polygon(
          polygonId: PolygonId('A6'),
          points: _createSemiCircle(center, 500, 750, false),
          fillColor: Colors.orange.withOpacity(0.5),
          strokeColor: Colors.orange,
          strokeWidth: 2,
        ));
      } else if (firstPolygonCode == 'A7') {
        polygons.add(Polygon(
          polygonId: PolygonId('A7'),
          points: _createSemiCircle(center, 750, 1000, true),
          fillColor: Colors.cyan.withOpacity(0.5),
          strokeColor: Colors.cyan,
          strokeWidth: 2,
        ));
      } else if (firstPolygonCode == 'A8') {
        polygons.add(Polygon(
          polygonId: PolygonId('A8'),
          points: _createSemiCircle(center, 750, 1000, false),
          fillColor: Colors.brown.withOpacity(0.5),
          strokeColor: Colors.brown,
          strokeWidth: 2,
        ));
      }
    }

    return polygons;
  }

  void _updatePolygon(String kode) {
    setState(() {
      firstPolygonCode = kode;
    });
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
              // ignore: no_wildcard_variable_uses
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
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                initialCameraPosition:
                    CameraPosition(target: currentPosition!, zoom: 15),
                markers: <Marker>{
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
                  for (var order in orderData)
                    Marker(
                      markerId: MarkerId(order.orderid.toString()),
                      icon: orderpin,
                      position: order.getLatLng(),
                      onTap: () {
                        _onOrderMarkerTapped(order.getLatLng());
                      },
                    ),
                  for (var survei in surveiData)
                    Marker(
                      markerId: MarkerId(survei.idsurvei.toString()),
                      icon: surveipin,
                      position: survei.getLatLng(),
                      onTap: () {
                        _onSurveiMarkerTapped(survei.getLatLng());
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
                  Circle(
                    circleId: CircleId('radarZone500m'),
                    center: currentPosition!,
                    radius: radarRadius500m,
                    strokeWidth: 2,
                    strokeColor: Colors.red.withOpacity(0.5),
                  ),
                  Circle(
                    circleId: CircleId('radarZone750m'),
                    center: currentPosition!,
                    radius: radarRadius750m,
                    strokeWidth: 2,
                    strokeColor: Colors.red.withOpacity(0.5),
                  ),
                  Circle(
                    circleId: CircleId('radarZone1000m'),
                    center: currentPosition!,
                    radius: radarRadius1000m,
                    strokeWidth: 2,
                    strokeColor: Colors.red.withOpacity(0.5),
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
                polygons: _buildPolygons(),
              ),
            Positioned(
              top: 16.0,
              left:
                  MediaQuery.of(context).size.width * 0.1, // 10% from the left
              right:
                  MediaQuery.of(context).size.width * 0.1, // 10% from the right
              child: Container(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.height *
                    0.85, // 10% of the screen height
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
                              fontSize:
                                  isMobile ? 14 : 18, // Ukuran font dinamis
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
              child: Text(
                'List Wilayah Promosi',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 5,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.09,
                width: MediaQuery.of(context).size.width * 0.8,
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
                        itemCount: alternativesData.length,
                        itemBuilder: (context, index) {
                          final alternative = alternativesData[index];
                          final criteria = alternative['criteria'] ?? {};

                          return GestureDetector(
                            onTap: () {
                              if (_lastClickedIndex == index) {
                                _updatePolygon(alternative['kode']);
                              } else {
                                setState(() {
                                  _lastClickedIndex = index;
                                });
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 10),
                              height: MediaQuery.of(context).size.height *
                                  0.2, // Adjusted height
                              width: 220, // Increased width to fit more content
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8),
                                    child: Text(
                                      alternative['namaalternatif'] ??
                                          'Nama Alternatif',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      'Total Usaha: ${criteria['totalUsaha'] ?? '-'}',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey[700]),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      'Jenis Usaha Terbanyak: ${criteria['jenisUsahaTerbanyak'] ?? '-'}',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey[700]),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      'Total ODP: ${criteria['totalODP'] ?? '-'}',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey[700]),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      'Kategori Terbanyak: ${criteria['kategoriTerbanyak'] ?? '-'}',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey[700]),
                                    ),
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
            )
          ],
        ),
        floatingActionButton: Container(
          width: 50.0, // Ubah lebar Container sesuai kebutuhan
          height: 50.0, // Ubah tinggi Container sesuai kebutuhan
          margin: EdgeInsets.only(
              bottom: 90.0,
              right: 0), // Sesuaikan margin untuk posisi yang diinginkan
          child: FloatingActionButton(
            onPressed: () {
              if (userPosition != null) {
                _moveToLocation(userPosition!);
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
                    child: Stack(children: [
                      if (currentPosition != null)
                        GoogleMap(
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                          initialCameraPosition: CameraPosition(
                              target: currentPosition!, zoom: 17),
                          markers: <Marker>{
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
                                _resetPolyline();
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
                            for (var order in orderData)
                              Marker(
                                markerId: MarkerId(order.orderid.toString()),
                                icon: orderpin,
                                position: order.getLatLng(),
                                onTap: () {
                                  _onOrderMarkerTapped(order.getLatLng());
                                },
                              ),
                            for (var survei in surveiData)
                              Marker(
                                markerId: MarkerId(survei.idsurvei.toString()),
                                icon: surveipin,
                                position: survei.getLatLng(),
                                onTap: () {
                                  _onSurveiMarkerTapped(survei.getLatLng());
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
                            ),
                            Circle(
                              circleId: CircleId('radarZone500m'),
                              center: currentPosition!,
                              radius: radarRadius500m,
                              strokeWidth: 2,
                              strokeColor: Colors.red.withOpacity(0.5),
                            ),
                            Circle(
                              circleId: CircleId('radarZone750m'),
                              center: currentPosition!,
                              radius: radarRadius750m,
                              strokeWidth: 2,
                              strokeColor: Colors.red.withOpacity(0.5),
                            ),
                            Circle(
                              circleId: CircleId('radarZone1000m'),
                              center: currentPosition!,
                              radius: radarRadius1000m,
                              strokeWidth: 2,
                              strokeColor: Colors.red.withOpacity(0.5),
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
                            Polyline(
                              polylineId: PolylineId('horizontalLine'),
                              points: [
                                LatLng(currentPosition!.latitude,
                                    currentPosition!.longitude - 0.01),
                                LatLng(currentPosition!.latitude,
                                    currentPosition!.longitude + 0.01),
                              ],
                              color: Colors.black,
                              width: 2,
                            ),
                          },
                          polygons: _buildPolygons(),
                        ),
                      Positioned(
                        top: 16.0,
                        left: MediaQuery.of(context).size.width *
                            0.1, // 10% from the left
                        right: MediaQuery.of(context).size.width *
                            0.1, // 10% from the right
                        child: Container(
                          height: MediaQuery.of(context).size.height *
                              0.1, // 10% of the screen height
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
                        bottom: 160,
                        left: 50,
                        child: Text(
                          'List Wilayah Promosi',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 5,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height *
                              0.2, // Increased height to accommodate criteria
                          width: MediaQuery.of(context).size.width * 0.75,
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
                                  itemCount: alternativesData.length,
                                  itemBuilder: (context, index) {
                                    final alternative = alternativesData[index];
                                    final criteria =
                                        alternative['criteria'] ?? {};

                                    return InkWell(
                                      onTap: () {
                                        if (_lastClickedIndex == index) {
                                          _updatePolygon(alternative['kode']);
                                        } else {
                                          setState(() {
                                            _lastClickedIndex = index;
                                          });
                                        }
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(right: 10),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.2, // Adjusted height
                                        width:
                                            200, // Increased width to fit more content
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
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                alternative['namaalternatif'] ??
                                                    'Nama Alternatif',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Text(
                                                'Total Usaha: ${criteria['totalUsaha'] ?? '-'}',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[700]),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Text(
                                                'Jenis Usaha Terbanyak: ${criteria['jenisUsahaTerbanyak'] ?? '-'}',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[700]),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Text(
                                                'Total ODP: ${criteria['totalODP'] ?? '-'}',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[700]),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Text(
                                                'Kategori Terbanyak: ${criteria['kategoriTerbanyak'] ?? '-'}',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[700]),
                                              ),
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
                      )
                    ]),
                  )
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: Container(
          width: 50.0, // Ubah lebar Container sesuai kebutuhan
          height: 50.0, // Ubah tinggi Container sesuai kebutuhan
          margin: EdgeInsets.only(
              bottom: 100.0), // Sesuaikan margin untuk posisi yang diinginkan
          child: FloatingActionButton(
            onPressed: () {
              if (userPosition != null) {
                _moveToLocation(userPosition!);
              }
            },
            backgroundColor: Colors.grey[800],
            child: const Icon(Icons.gps_fixed),
          ),
        ),
      );
    }
  }

  void _showPointDetails(BuildContext context, String name, String kapasitas,
      String isi, String kosong, String reserved, String kategori) {
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
                        'Jarak: ${calculateDistance(currentPosition!, selectedODPPosition!).toStringAsFixed(2)} meter',
                        style: textStyleMobile,
                      ),
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
                      'Saran : ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Perlu peningkatan promosi paket A di wilayah ini',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        decoration: TextDecoration.none,
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

  void _showSurveiDetails(
    BuildContext context,
    String namausaha,
    String jenisusaha,
  ) {
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
                    SizedBox(height: 10),
                    Text(
                      'Nama Usaha : $namausaha',
                      style: textStyleMobile,
                    ),
                    SizedBox(height: 7),
                    Text(
                      'Jenis Usaha : $jenisusaha',
                      style: textStyleMobile,
                    ),
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
                    SizedBox(height: 30),
                    Text(
                      'Nama Usaha : $namausaha',
                      style: textStyleWeb,
                    ),
                    SizedBox(height: 7),
                    Text(
                      'Jenis Usaha : $jenisusaha',
                      style: textStyleWeb,
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

  void _showOrderDetails(
    BuildContext context,
    String namaperusahaan,
  ) {
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
                    SizedBox(height: 10),
                    Text(
                      'Nama Usaha : $namaperusahaan',
                      style: textStyleMobile,
                    ),
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
                    SizedBox(height: 30),
                    Text(
                      'Nama Usaha : $namaperusahaan',
                      style: textStyleWeb,
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
