// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:math' show atan2, cos, pi, sin, sqrt;

import 'package:dio/dio.dart';
// Conditional import untuk web
import 'package:flutter/foundation.dart' show ByteData, Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:webui/controller/inputan_controller.dart';
import 'package:webui/controller/odp_controller.dart';
import 'package:webui/controller/survei_controller.dart';
import 'package:webui/models/inputan_data.dart';
import 'package:webui/models/odp_data.dart';
import 'package:webui/models/survei_data.dart';
import 'package:webui/views/directions.dart';

class OrderSurveiMapScreen extends StatefulWidget {
  const OrderSurveiMapScreen({super.key});

  @override
  State<OrderSurveiMapScreen> createState() => _OrderSurveiMapScreenState();
}

class _OrderSurveiMapScreenState extends State<OrderSurveiMapScreen> {
  final locationController = Location();
  final Completer<GoogleMapController> _controller = Completer();
  late ODPController odpController;
  late InputanController orderController;
  late SurveiController surveiController;
  LatLng? currentPosition;
  List<ODP> odpData = [];
  List<Survei> surveiData = [];
  List<Inputan> orderData = [];
  LatLng? nearestODPPosition;
  LatLng? selectedODPPosition;
  List<LatLng> polylineCoordinates = [];
  late BitmapDescriptor personIcon;
  late BitmapDescriptor pin1;
  late BitmapDescriptor pin2;

  static const double radarRadius250m = 250;
  static const double radarRadius1000m = 1000;

  @override
  void initState() {
    super.initState();
    odpController = Get.put(ODPController());
    orderController = Get.put(InputanController());
    surveiController = Get.put(SurveiController());
    _loadPersonIcon();
    _loadPin1();
    _loadPin2();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchLocationUpdates();
      await loadODPData();
      _findNearestODP();
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
          currentPosition =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });
      }
    });
  }

  Future<void> loadODPData() async {
    await odpController.getAllODP();
    await orderController.getAllOrder();
    await surveiController.getAllSurvei();
    setState(() {
      odpData = odpController.semuaODP;
      orderData = orderController.semuaInputan;
      surveiData = surveiController.allSurvei;
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
  }

  void _getPolyline(LatLng origin, LatLng destination) async {
    if (kIsWeb) {
      // Implementasi polyline untuk Flutter web
      _calculatePolylineForWeb(origin, destination);
    } else {
      // Implementasi polyline menggunakan Directions API untuk Flutter mobile
      final directionsLine = DirectionsLine(dio: Dio());
      final directions = await directionsLine.getDirections(
        origin: origin,
        destination: destination,
      );
      setState(() {
        polylineCoordinates = directions?.polylinePoints
                .map((point) => LatLng(point.latitude, point.longitude))
                .toList() ??
            [];
      });
    }
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
        );
      }
    } else {
      setState(() {
        selectedODPPosition = position;
      });

      if (currentPosition != null) {
        _getPolyline(currentPosition!, position);
      }
    }
  }

  void _loadPersonIcon() async {
    final ByteData byteData = await rootBundle.load('assets/images/person.png');
    final Uint8List list = byteData.buffer.asUint8List();
    personIcon = BitmapDescriptor.fromBytes(list,
        size: Size(50, 50) // Ubah tinggi sesuai kebutuhan
        );
    pin1 = BitmapDescriptor.fromBytes(list,
        size: Size(50, 50) // Ubah tinggi sesuai kebutuhan
        );
    pin2 = BitmapDescriptor.fromBytes(list,
        size: Size(50, 50) // Ubah tinggi sesuai kebutuhan
        );
  }

  void _loadPin1() async {
    final ByteData byteData = await rootBundle.load('assets/images/pin1.png');
    final Uint8List list = byteData.buffer.asUint8List();
    pin1 = BitmapDescriptor.fromBytes(list,
        size: Size(50, 50) // Ubah tinggi sesuai kebutuhan
        );
  }

  void _loadPin2() async {
    final ByteData byteData = await rootBundle.load('assets/images/pin2.png');
    final Uint8List list = byteData.buffer.asUint8List();
    pin2 = BitmapDescriptor.fromBytes(list,
        size: Size(50, 50) // Ubah tinggi sesuai kebutuhan
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Map ODP")),
      body: currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              initialCameraPosition:
                  CameraPosition(target: currentPosition!, zoom: 17),
              markers: <Marker>{
                Marker(
                  markerId: const MarkerId('currentLocation'),
                  icon: personIcon,
                  position: currentPosition!,
                ),
                for (var order in orderData)
                  Marker(
                    markerId: MarkerId(order.orderid.toString()),
                    icon: pin2,
                    position: order.getLatLng(),
                  ),
                for (var survei in surveiData)
                  Marker(
                    markerId: MarkerId(survei.idsurvei.toString()),
                    icon: pin1,
                    position: survei.getLatLng(),
                  ),
                for (var odp in odpData)
                  Marker(
                    markerId: MarkerId(odp.idodp.toString()),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueBlue),
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
            ),
    );
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
                    SizedBox(height: 5),
                    Text(
                      'Titik ini direkomendasikan untuk digunakan oleh calon pelanggan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
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
                        'Jarak: ${calculateDistance(currentPosition!, selectedODPPosition!).toStringAsFixed(2)} meter',
                        style: textStyleMobile,
                      ),
                    SizedBox(height: 10),
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
                      'Titik ini direkomendasikan untuk digunakan oleh calon pelanggan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
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
