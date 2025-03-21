import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class PlacesService {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json';
  static const String apiKey =
      'AIzaSyAqzPmL6JDXRSYyVAIKAnFW6BSXiUfVJPw'; // Replace with your API key

  static Future<List<Map<String, dynamic>>> searchPlaces(String query) async {
    log('Searching for places: $query');
    try {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl?input=$query'
          '&key=$apiKey'
          '&components=country:ca', // Limit to Canada
        ),
      );

      log('Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final predictions = data['predictions'] as List;

          // Get details for each prediction
          List<Map<String, dynamic>> places = [];
          for (var prediction in predictions) {
            final details = await getPlaceDetails(prediction['place_id']);
            places.add(details);
          }
          return places;
        }
      }
      return [];
    } catch (e) {
      print('Error searching places: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> getPlaceDetails(String placeId) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://maps.googleapis.com/maps/api/place/details/json'
          '?place_id=$placeId'
          '&key=$apiKey',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final result = data['result'];
          return {
            'name': result['name'],
            'address': result['formatted_address'],
            'lat': result['geometry']['location']['lat'],
            'lng': result['geometry']['location']['lng'],
          };
        }
      }
      return {};
    } catch (e) {
      print('Error getting place details: $e');
      return {};
    }
  }
}
