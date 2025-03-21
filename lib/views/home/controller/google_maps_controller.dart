//simport 'package:geolocator/geolocator.dart';

import 'dart:developer';
import 'dart:math' as math;
import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:you_commute/imports.dart';
import 'package:get/get.dart';
import 'package:you_commute/services/places_service.dart';

class GoogleMapsController extends GetxController {
  GoogleMapController? mapController;
  Rx<LatLng?> currentPosition = Rx<LatLng?>(null);
  final RxSet<Marker> markers = <Marker>{}.obs;
  final RxSet<Polyline> polylines = <Polyline>{}.obs;
  final RxBool isRouteVisible = false.obs;
  Set<Marker> stopMarkers = {};
  int _polylineIdCounter = 0;
  int _markerIdCounter = 0;
  final Rx<double?> currentDistance = Rx<double?>(null);
  RxInt totalDistance = 0.obs;

  // Add new properties for search results
  final RxList<Map<String, dynamic>> searchResults =
      <Map<String, dynamic>>[].obs;
  Timer? _debounceTimer;

  // Method to create unique polyline IDs
  String _getPolylineIdString() => 'polyline_${_polylineIdCounter++}';

  // Method to create unique marker IDs
  String _getMarkerIdString() => 'marker_${_markerIdCounter++}';

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    log('Getting current location');
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      log(serviceEnabled.toString());
      if (!serviceEnabled) {
        Get.snackbar('Error', 'Location services are disabled.');
        return;
      }
      log('Getting current location1');

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar('Error', 'Location permissions are denied.');
          return;
        }
      }
      log('Getting current location2');

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar('Error', 'Location permissions are permanently denied.');
        return;
      }
      log('Getting current location3');

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      log('Getting current location4');

      currentPosition.value = LatLng(position.latitude, position.longitude);
      log('Current Location: ${currentPosition.value}');
      markers.value = {
        Marker(
          markerId: const MarkerId('current_location'),
          position: currentPosition.value!,
          infoWindow: const InfoWindow(title: 'You are here'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      };

      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(currentPosition.value!, 15),
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to get location: $e');
      print('Location Error: $e');
    }
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    update();
  }

  void updateMarker(LatLng position) {
    try {
      markers.clear();
      markers.add(
        Marker(
          markerId: const MarkerId('selected_location'),
          position: position,
          infoWindow: const InfoWindow(title: 'Selected Location'),
        ),
      );

      mapController?.animateCamera(CameraUpdate.newLatLng(position));

      update();
    } catch (e) {
      print('Error updating marker: $e');
    }
  }

  void updateRoutePolylines(List<LatLng> points) {
    try {
      polylines.clear();
      if (points.length < 2) return;

      polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: points,
          color: Colors.blue,
          width: 5,
          patterns: [PatternItem.dash(20), PatternItem.gap(10)],
        ),
      );

      _fitBounds(points.first, points.last);
      update();
    } catch (e) {
      print('Error updating route polylines: $e');
    }
  }

  void updateMarkerAndRoute(LatLng destination) {
    try {
      // First clear existing markers and polylines
      markers.clear();
      polylines.clear();

      // Force update to ensure clearing takes effect
      update();

      // Add new markers
      markers.addAll({
        Marker(
          markerId: const MarkerId('destination'),
          position: destination,
          infoWindow: const InfoWindow(title: 'Selected Stop'),
        ),
        if (currentPosition.value != null)
          Marker(
            markerId: const MarkerId('current_location'),
            position: currentPosition.value!,
            infoWindow: const InfoWindow(title: 'Current Location'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue,
            ),
          ),
      });

      // Add polyline if we have current position
      if (currentPosition.value != null) {
        polylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            points: [currentPosition.value!, destination],
            color: Colors.blue,
            width: 5,
          ),
        );

        // Update camera to show the route
        _fitBounds(currentPosition.value!, destination);
      } else {
        mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(destination, 15),
        );
      }

      // Calculate and update distance if we have current position
      if (currentPosition.value != null) {
        double distance = calculateDistance(
          currentPosition.value!,
          destination,
        );
        currentDistance.value = distance;
      } else {
        currentDistance.value = null;
      }

      // Toggle route visibility to force update
      isRouteVisible.value = true;

      // Force update of the controller
      update();
    } catch (e) {
      print('Error updating marker and route: $e');
    }
  }

  void _fitBounds(LatLng point1, LatLng point2) {
    try {
      if (mapController == null) return;

      double minLat = math.min(point1.latitude, point2.latitude);
      double maxLat = math.max(point1.latitude, point2.latitude);
      double minLng = math.min(point1.longitude, point2.longitude);
      double maxLng = math.max(point1.longitude, point2.longitude);

      // Add padding to bounds
      final bounds = LatLngBounds(
        southwest: LatLng(minLat - 0.05, minLng - 0.05),
        northeast: LatLng(maxLat + 0.05, maxLng + 0.05),
      );

      mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    } catch (e) {
      print('Error fitting bounds: $e');
    }
  }

  void clearRoute() {
    markers.clear();
    polylines.clear();
    update();
  }

  // Update stop markers with error handling
  void updateStopMarkers(List<Map<String, dynamic>> stops) {
    try {
      stopMarkers.clear();

      for (var stop in stops) {
        if (stop['lat'] == null || stop['lon'] == null) {
          print('Warning: Stop missing coordinates: ${stop['title']}');
          continue;
        }

        final markerId = _getMarkerIdString();

        stopMarkers.add(
          Marker(
            markerId: MarkerId(markerId),
            position: LatLng(
              double.parse(stop['lat'].toString()),
              double.parse(stop['lon'].toString()),
            ),
            infoWindow: InfoWindow(
              title: stop['title'] ?? 'Unknown Stop',
              snippet: stop['tag'] ?? '',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue,
            ),
          ),
        );
      }
      update();
    } catch (e) {
      print('Error updating stop markers: $e');
    }
  }

  // Update both route and stops
  void updateRouteDisplay(
    List<LatLng> routePoints,
    List<Map<String, dynamic>> stops,
  ) {
    try {
      clearRoute();
      updateRoutePolylines(routePoints);
      updateStopMarkers(stops);
    } catch (e) {
      print('Error updating route display: $e');
    }
  }

  // Handle transit route selection
  void showTransitRoute(Map<String, dynamic> routeDetails) {
    try {
      if (routeDetails['path'] == null || routeDetails['stops'] == null) {
        print('Warning: Route details missing path or stops');
        return;
      }

      final List<LatLng> routePoints =
          (routeDetails['path'] as List).map((point) {
            return LatLng(
              double.parse(point['lat'].toString()),
              double.parse(point['lon'].toString()),
            );
          }).toList();

      final List<Map<String, dynamic>> stops = List<Map<String, dynamic>>.from(
        routeDetails['stops'],
      );

      updateRouteDisplay(routePoints, stops);
    } catch (e) {
      print('Error showing transit route: $e');
    }
  }

  // Calculate distance between two points using Haversine formula
  double calculateDistance(LatLng point1, LatLng point2) {
    var p = math.pi / 180;
    var a =
        0.5 -
        math.cos((point2.latitude - point1.latitude) * p) / 2 +
        math.cos(point1.latitude * p) *
            math.cos(point2.latitude * p) *
            (1 - math.cos((point2.longitude - point1.longitude) * p)) /
            2;

    // Return distance in kilometers
    return 12742 * math.asin(math.sqrt(a));
  }

  // Add method to search places
  void searchPlaces(String query) {
    // Debounce the search to avoid too many API calls
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      try {
        final places = await PlacesService.searchPlaces(query);
        searchResults.value = places;
      } catch (e) {
        print('Error searching places: $e');
      }
    });
  }

  @override
  void onClose() {
    mapController?.dispose();
    _debounceTimer?.cancel();
    super.onClose();
  }
}
