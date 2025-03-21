import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:you_commute/app/app_textstyle/app_textstyles.dart';
import 'package:you_commute/app/app_theme/ui_helper.dart';
import 'package:you_commute/imports.dart';
import 'package:you_commute/views/home/controller/google_maps_controller.dart';
import 'package:you_commute/views/home/controller/home_controller.dart';
import 'package:you_commute/views/home/widgets/show_location_sheet.dart';
import 'package:you_commute/views/home/widgets/show_transite_info.dart';
import 'package:you_commute/widgets/app_textfield.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final GoogleMapsController controller = Get.put(GoogleMapsController());
    Get.put(HomeController());

    return Scaffold(
      backgroundColor: kcWhitecolor,
      body: Stack(
        children: [
          Obx(
            () => GoogleMap(
              onMapCreated: (GoogleMapController mapController) {
                controller.onMapCreated(mapController);
              },
              initialCameraPosition: CameraPosition(
                target:
                    controller.currentPosition.value ??
                    const LatLng(43.6532, -79.3832),
                zoom: 12,
              ),
              markers: controller.markers.value,
              polylines: controller.polylines.value,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
          ),
          // Optional loading indicator
          Obx(
            () =>
                controller.isRouteVisible.value
                    ? const SizedBox()
                    : const Center(child: SizedBox()),
          ),
          Positioned(
            bottom: 40,
            left: 10,
            child: GestureDetector(
              onTap: () => showTransitInfo(context, controller),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: kcWhitecolor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Icon(CupertinoIcons.location_fill, color: kcPrimaryColor),
                    horizontalSpaceTiny,
                    Text('Find a stop', style: getBoldStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 90,
            left: 10,
            child: GetBuilder<GoogleMapsController>(
              builder: (controller) {
                final double? distance =
                    controller.currentDistance.value ?? 0.0;
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: kcWhitecolor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    distance != null && distance < 1
                        ? '${(distance * 1000).toStringAsFixed(0)} meters away'
                        : '${distance!.toStringAsFixed(1)} km away',
                    style: getMediumStyle(fontSize: 12, color: kcBlackColor),
                  ),
                );
              },
            ),
          ),

          Positioned(
            top: 70,
            left: 10,
            right: 10,
            child: GestureDetector(
              onTap: () => showLocationSearch(context, controller),
              child: AppTextField(
                labelText: 'Select Your location you want to travel',
                prefixIcon: Icon(CupertinoIcons.search, color: kcPrimaryColor),
                onChanged: (value) {
                  controller.searchPlaces(value);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
