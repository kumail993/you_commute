import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationServices {
  static final Dio dio = Dio();

  // Replace this with your actual Google Places API key
  static const String apiKey = 'YOUR_GOOGLE_PLACES_API_KEY';

  static Future<List<dynamic>> getVisiblePlaces({
    required GoogleMapController mapController,
    String? pageToken,
  }) async {
    try {
      final LatLngBounds bounds = await mapController.getVisibleRegion();
      final LatLng center = LatLng(
        (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
        (bounds.northeast.longitude + bounds.southwest.longitude) / 2,
      );

      final Map<String, dynamic> queryParameters = {
        'location': '${center.latitude},${center.longitude}',
        'radius': '1500', // Search radius in meters
        'type': 'point_of_interest',
        'key': apiKey,
      };

      if (pageToken != null) {
        queryParameters['pagetoken'] = pageToken;
      }

      final response = await dio.get(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json',
        queryParameters: queryParameters,
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        if (response.data['status'] == 'OK') {
          return response.data['results'] ?? [];
        } else if (response.data['status'] == 'ZERO_RESULTS') {
          return [];
        } else {
          throw Exception('Places API error: ${response.data['status']}');
        }
      }
      throw Exception('Failed to fetch places: ${response.statusCode}');
    } catch (e) {
      print('Error fetching places: $e');
      throw Exception('Error fetching places: $e');
    }
  }
}
