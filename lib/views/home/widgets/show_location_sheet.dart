import 'package:you_commute/views/home/controller/google_maps_controller.dart';
import 'package:you_commute/imports.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/cupertino.dart';

void showLocationSearch(BuildContext context, GoogleMapsController controller) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder:
        (context) => Container(
          height: MediaQuery.of(context).size.height * 0.9,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Search TextField
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search location',
                  prefixIcon: Icon(
                    CupertinoIcons.search,
                    color: kcPrimaryColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: kcPrimaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: kcPrimaryColor, width: 2),
                  ),
                ),
                onChanged: (value) {
                  // Trigger location search after user types
                  if (value.length > 2) {
                    controller.searchPlaces(value);
                  }
                },
              ),
              const SizedBox(height: 16),
              // Suggestions List
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemCount: controller.searchResults.length,
                    itemBuilder: (context, index) {
                      final place = controller.searchResults[index];
                      return ListTile(
                        leading: Icon(Icons.location_on, color: kcPrimaryColor),
                        title: Text(place['name'] ?? ''),
                        subtitle: Text(place['address'] ?? ''),
                        onTap: () {
                          // Handle location selection
                          Navigator.pop(context);
                          controller.updateMarkerAndRoute(
                            LatLng(place['lat'], place['lng']),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
  );
}
