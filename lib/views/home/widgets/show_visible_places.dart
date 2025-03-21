import 'package:flutter/material.dart';
import 'package:you_commute/views/home/controller/google_maps_controller.dart';
import 'package:you_commute/services/location_services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

void showVisiblePlaces(
  BuildContext context,
  GoogleMapsController controller,
) async {
  List<dynamic> allResults = [];
  String? nextPageToken;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Allows the bottom sheet to take more space
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: FutureBuilder<List<dynamic>>(
              future: LocationServices.getVisiblePlaces(
                mapController: Get.find<GoogleMapController>(
                  tag: 'mapController',
                ),
                pageToken: nextPageToken,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.hasData) {
                  if (nextPageToken == null) {
                    allResults
                        .clear(); // Clear previous results only on initial load
                  }
                  allResults.addAll(snapshot.data!);
                  final hasNextPage =
                      snapshot.data!.isNotEmpty &&
                      (snapshot.data!.last['next_page_token'] != null);

                  return ListView.builder(
                    itemCount: allResults.length + (hasNextPage ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == allResults.length && hasNextPage) {
                        return TextButton(
                          onPressed: () {
                            nextPageToken =
                                snapshot.data!.last['next_page_token'];
                            setState(() {}); // Trigger rebuild with next page
                          },
                          child: const Text('Load More'),
                        );
                      }

                      final place = allResults[index];
                      return ListTile(
                        title: Text(place['name'] ?? 'Unnamed Place'),
                        subtitle: Text(
                          place['formatted_address'] ?? 'No address',
                        ),
                        onTap: () {
                          final location = place['geometry']['location'];
                          final latLng = LatLng(
                            location['lat'].toDouble(),
                            location['lng'].toDouble(),
                          );
                          controller.updateMarker(latLng);
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                }
                return const Center(child: Text('No places found'));
              },
            ),
          );
        },
      );
    },
  );
}
