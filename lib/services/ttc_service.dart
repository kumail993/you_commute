import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TTCService {
  static const String baseUrl =
      'http://webservices.nextbus.com/service/publicJSONFeed';
  static const String agency = 'ttc';

  // Helper method to make HTTP requests with retry logic
  static Future<http.Response> _getWithRetry(
    String url, {
    int maxRetries = 3,
  }) async {
    int attempts = 0;
    while (attempts < maxRetries) {
      try {
        final response = await http
            .get(Uri.parse(url), headers: {'Accept': 'application/json'})
            .timeout(
              const Duration(seconds: 10),
              onTimeout: () {
                throw TimeoutException('Request timed out');
              },
            );
        return response;
      } catch (e) {
        attempts++;
        if (attempts == maxRetries) {
          throw Exception('Failed after $maxRetries attempts: $e');
        }
        // Wait before retrying, with exponential backoff
        await Future.delayed(Duration(seconds: attempts * 2));
      }
    }
    throw Exception('Unexpected error in _getWithRetry');
  }

  // Transit type enum
  static const Map<String, String> transitTypes = {
    'bus': 'Bus Routes',
    'streetcar': 'Streetcar Routes',
    'subway': 'Subway Lines',
  };

  // Get routes by transit type
  static Future<List<Map<String, dynamic>>> getRoutesByType(
    String transitType,
  ) async {
    try {
      final response = await _getWithRetry(
        '$baseUrl?command=routeList&a=$agency',
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Map<String, dynamic>> routes = [];

        if (data['route'] != null) {
          List<dynamic> allRoutes =
              data['route'] is List ? data['route'] : [data['route']];

          for (var route in allRoutes) {
            // Filter routes based on type
            bool isCorrectType = false;
            switch (transitType) {
              case 'bus':
                isCorrectType =
                    !route['tag'].toString().contains('5') &&
                    !route['title'].toString().toLowerCase().contains(
                      'streetcar',
                    );
                break;
              case 'streetcar':
                isCorrectType = route['title']
                    .toString()
                    .toLowerCase()
                    .contains('streetcar');
                break;
              case 'subway':
                isCorrectType = route['tag'].toString().startsWith('5');
                break;
            }

            if (isCorrectType) {
              routes.add({
                'tag': route['tag'],
                'title': route['title'],
                'type': transitType,
              });
            }
          }
        }
        return routes;
      } else {
        throw Exception('Failed to load routes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching routes: $e');
    }
  }

  // Get route details including path for map
  static Future<List<Map<String, dynamic>>> getRouteDetails(
    String routeTag,
  ) async {
    try {
      final response = await _getWithRetry(
        '$baseUrl?command=routeConfig&a=$agency&r=$routeTag',
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['route'] != null) {
          final route = data['route'];
          List<Map<String, dynamic>> stops = [];

          // Parse stops
          if (route['stop'] != null) {
            List<dynamic> stopsData =
                route['stop'] is List ? route['stop'] : [route['stop']];
            for (var stop in stopsData) {
              stops.add({
                'tag': stop['tag'],
                'title': stop['title'],
                'lat': double.parse(stop['lat']),
                'lon': double.parse(stop['lon']),
                'routeTag': routeTag,
                'routeTitle': route['title'],
              });
            }
          }
          return stops;
        }
        return [];
      } else {
        throw Exception('Failed to load route details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching route details: $e');
    }
  }

  // Get all TTC stops for a specific route
  static Future<List<Map<String, dynamic>>> getAllStops() async {
    try {
      // First, get all routes
      final routesResponse = await http.get(
        Uri.parse('$baseUrl?command=routeList&a=$agency'),
        headers: {'Accept': 'application/json'},
      );

      if (routesResponse.statusCode == 200) {
        final routesData = json.decode(routesResponse.body);
        List<Map<String, dynamic>> allStops = [];

        if (routesData['route'] != null) {
          List<dynamic> routes =
              routesData['route'] is List
                  ? routesData['route']
                  : [routesData['route']];

          // Get first 5 routes for testing (remove this limitation for production)
          for (var route in routes.take(5)) {
            // Get stops for each route
            final stopResponse = await http.get(
              Uri.parse(
                '$baseUrl?command=routeConfig&a=$agency&r=${route['tag']}',
              ),
              headers: {'Accept': 'application/json'},
            );

            if (stopResponse.statusCode == 200) {
              final stopData = json.decode(stopResponse.body);
              if (stopData['route'] != null &&
                  stopData['route']['stop'] != null) {
                List<dynamic> stops =
                    stopData['route']['stop'] is List
                        ? stopData['route']['stop']
                        : [stopData['route']['stop']];

                for (var stop in stops) {
                  // Add stop if it's not already in the list
                  if (!allStops.any((s) => s['stopId'] == stop['tag'])) {
                    allStops.add({
                      'stopId': stop['tag'],
                      'title': stop['title'],
                      'lat': double.parse(stop['lat']),
                      'lon': double.parse(stop['lon']),
                      'routeTag': route['tag'],
                      'routeTitle': route['title'],
                    });
                  }
                }
              }
            }
          }
        }
        return allStops;
      } else {
        throw Exception('Failed to load routes: ${routesResponse.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching stops: $e');
    }
  }

  // Get next arrivals for a specific stop
  static Future<List<Map<String, dynamic>>> getNextArrivals(
    String stopId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?command=predictions&a=$agency&stopId=$stopId'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Map<String, dynamic>> arrivals = [];

        if (data['predictions'] != null && data['predictions'] is! String) {
          var predictions =
              data['predictions'] is List
                  ? data['predictions']
                  : [data['predictions']];

          for (var pred in predictions) {
            if (pred['direction'] != null) {
              var directions =
                  pred['direction'] is List
                      ? pred['direction']
                      : [pred['direction']];

              for (var direction in directions) {
                if (direction['prediction'] != null) {
                  var predictionList =
                      direction['prediction'] is List
                          ? direction['prediction']
                          : [direction['prediction']];

                  for (var prediction in predictionList) {
                    arrivals.add({
                      'routeTitle': pred['routeTitle'] ?? 'Unknown Route',
                      'destination':
                          direction['title'] ?? 'Unknown Destination',
                      'minutes': prediction['minutes'] ?? '?',
                      'vehicle': prediction['vehicle'] ?? 'Unknown',
                      'isDeparture': prediction['isDeparture'] == "true",
                    });
                  }
                }
              }
            }
          }
        }

        // Sort arrivals by minutes
        arrivals.sort(
          (a, b) => int.parse(
            a['minutes'].toString(),
          ).compareTo(int.parse(b['minutes'].toString())),
        );

        return arrivals;
      } else {
        throw Exception('Failed to load arrivals: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching next arrivals: $e');
    }
  }

  // Get all routes
  static Future<List<Map<String, dynamic>>> getRoutes() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?command=routeList&a=$agency'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['route'] != null) {
          return List<Map<String, dynamic>>.from(data['route']);
        }
        return [];
      } else {
        throw Exception('Failed to load routes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching routes: $e');
    }
  }

  // Add this method to your TTCService class
  static Future<Map<String, dynamic>> getDirectionsToStop(
    LatLng origin,
    LatLng destination,
  ) async {
    try {
      final String url =
          'https://maps.googleapis.com/maps/api/directions/json'
          '?origin=${origin.latitude},${origin.longitude}'
          '&destination=${destination.latitude},${destination.longitude}'
          '&mode=walking'
          '&key=AIzaSyAqzPmL6JDXRSYyVAIKAnFW6BSXiUfVJPw';

      final response = await _getWithRetry(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          // Decode the polyline points from the response
          List<LatLng> points = [];
          if (data['routes'].isNotEmpty) {
            String encodedPoints =
                data['routes'][0]['overview_polyline']['points'];
            points = _decodePolyline(encodedPoints);
          }
          return {
            'points': points,
            'distance': data['routes'][0]['legs'][0]['distance']['text'],
            'duration': data['routes'][0]['legs'][0]['duration']['text'],
          };
        }
        throw Exception('Directions API error: ${data['status']}');
      }
      throw Exception('Failed to get directions: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error getting directions: $e');
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
