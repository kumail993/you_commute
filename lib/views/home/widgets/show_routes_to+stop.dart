import 'package:you_commute/views/home/controller/google_maps_controller.dart';
import 'package:you_commute/services/ttc_service.dart';
import 'package:you_commute/imports.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void sshowRouteToStop(
  BuildContext context,
  GoogleMapsController controller,
  Map<String, dynamic> stop,
) {
  try {
    final stopLocation = LatLng(
      double.parse(stop['lat'].toString()),
      double.parse(stop['lon'].toString()),
    );

    // Update map and calculate distance
    controller.updateMarkerAndRoute(stopLocation);

    showModalBottomSheet(
      backgroundColor: kcWhitecolor,
      context: context,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  stop['title'] ?? 'Stop Details',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Add distance information
                Obx(() {
                  final distance = controller.currentDistance.value;
                  if (distance != null) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.directions_walk, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(
                            distance < 1
                                ? '${(distance * 1000).toStringAsFixed(0)} meters away'
                                : '${distance.toStringAsFixed(1)} km away',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox();
                }),
                const Divider(),
                Expanded(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: TTCService.getNextArrivals(stop['tag']),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      final arrivals = snapshot.data ?? [];
                      if (arrivals.isEmpty) {
                        return const Center(
                          child: Text('No upcoming arrivals'),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: arrivals.length,
                        itemBuilder: (context, index) {
                          final arrival = arrivals[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${arrival['minutes']} min',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(arrival['destination'] ?? ''),
                              subtitle: Row(
                                children: [
                                  Text('Route: ${arrival['routeTitle']}'),
                                  const SizedBox(width: 8),
                                  // Add estimated walking time based on distance
                                  Obx(() {
                                    final distance =
                                        controller.currentDistance.value;
                                    if (distance != null) {
                                      // Assume average walking speed of 5 km/h
                                      final walkingMinutes =
                                          (distance / 5 * 60).round();
                                      return Text(
                                        '• ${walkingMinutes} min walk',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontStyle: FontStyle.italic,
                                        ),
                                      );
                                    }
                                    return const SizedBox();
                                  }),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
    );
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Error showing route: $e')));
  }
}
