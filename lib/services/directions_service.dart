import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionsService {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json';
  static const String apiKey =
      'AIzaSyAqzPmL6JDXRSYyVAIKAnFW6BSXiUfVJPw'; // Replace with your API key

  static Future<List<LatLng>> getRouteCoordinates(
    LatLng origin,
    LatLng destination,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl?origin=${origin.latitude},${origin.longitude}'
          '&destination=${destination.latitude},${destination.longitude}'
          '&mode=walking'
          '&key=$apiKey',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          // Decode polyline points
          final points = _decodePolyline(
            data['routes'][0]['overview_polyline']['points'],
          );
          return points;
        }
      }
      throw Exception('Failed to fetch route');
    } catch (e) {
      throw Exception('Error getting route: $e');
    }
  }

  // Helper method to decode Google's polyline encoding
  static List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }
}
