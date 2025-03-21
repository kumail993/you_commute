import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:you_commute/app/app_textstyle/app_textstyles.dart';
import 'package:you_commute/app/app_theme/app_sizing.dart';
import 'package:you_commute/app/app_theme/ui_helper.dart';
import 'package:you_commute/imports.dart';
import 'package:you_commute/services/ttc_service.dart';
import 'package:you_commute/views/home/controller/google_maps_controller.dart';

void showRouteDetails(
  BuildContext context,
  GoogleMapsController controller,
  String routeTag,
) async {
  try {
    final routeDetails = await TTCService.getRouteDetails(routeTag);

    showModalBottomSheet(
      backgroundColor: kcLightGrey,
      context: context,
      isScrollControlled: true,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.6,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text('Select Stop', style: getBoldStyle(fontSize: 20)),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: routeDetails.length,
                    itemBuilder: (context, index) {
                      final stop = routeDetails[index];
                      return ExpansionTile(
                        title: Text(
                          stop['title'] ?? 'Unknown Stop',
                          style: getMediumStyle(fontSize: 14),
                        ),
                        subtitle: Text(
                          'Tap to see arrivals',
                          style: getRegularStyle(fontSize: 12),
                        ),
                        children: [
                          FutureBuilder<List<Map<String, dynamic>>>(
                            future: TTCService.getNextArrivals(stop['tag']),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              if (snapshot.hasError) {
                                return Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text('Error: ${snapshot.error}'),
                                );
                              }

                              final arrivals = snapshot.data ?? [];
                              if (arrivals.isEmpty) {
                                return const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text('No upcoming arrivals'),
                                );
                              }

                              return Column(
                                children: [
                                  ...arrivals.map(
                                    (arrival) => GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                        final stopLocation = LatLng(
                                          double.parse(stop['lat'].toString()),
                                          double.parse(stop['lon'].toString()),
                                        );
                                        controller.updateMarkerAndRoute(
                                          stopLocation,
                                        );
                                        // _showRouteToStop(
                                        //   context,
                                        //   controller,
                                        //   stop,
                                        // );
                                      },
                                      child: Container(
                                        width: AppSizing.width(context),
                                        padding: const EdgeInsets.all(10),
                                        margin: EdgeInsets.only(bottom: 10),
                                        decoration: BoxDecoration(
                                          color: kcWhitecolor,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          border: Border.all(
                                            color: kcBorderColor,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 5,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        Theme.of(
                                                          context,
                                                        ).primaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          4,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    '${arrival['minutes']} min',
                                                    style: getRegularStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                Builder(
                                                  builder: (
                                                    BuildContext context,
                                                  ) {
                                                    final stopLocation = LatLng(
                                                      double.parse(
                                                        stop['lat'].toString(),
                                                      ),
                                                      double.parse(
                                                        stop['lon'].toString(),
                                                      ),
                                                    );
                                                    final latLng = stopLocation;
                                                    double distance = controller
                                                        .calculateDistance(
                                                          controller
                                                              .currentPosition
                                                              .value!,
                                                          latLng,
                                                        );

                                                    return Text(
                                                      distance < 1
                                                          ? '${(distance * 1000).toStringAsFixed(0)} meters away'
                                                          : '${distance.toStringAsFixed(1)} km away',
                                                      style: getMediumStyle(
                                                        fontSize: 12,
                                                        color: kcBlackColor,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                            verticalSpaceTiny,
                                            Text(
                                              '${arrival['destination']}',
                                              style: getRegularStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                            verticalSpaceTiny,
                                            Text(
                                              'To: ${arrival['destination']}',
                                              style: getRegularBoldStyle(
                                                fontSize: 12,
                                                color: kcTextGrey,
                                              ),
                                            ),
                                            verticalSpaceTiny,
                                            Text(
                                              style: getMediumStyle(
                                                fontSize: 12,
                                              ),
                                              'Route: ${arrival['routeTitle']}',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Divider(),
                                ],
                              );
                            },
                          ),
                        ],
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
    ).showSnackBar(SnackBar(content: Text('Error loading route details: $e')));
  }
}
