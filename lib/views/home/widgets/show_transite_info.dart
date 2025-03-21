import 'package:you_commute/views/home/controller/google_maps_controller.dart';
import 'package:you_commute/app/app_textstyle/app_textstyles.dart';
import 'package:you_commute/imports.dart';
import 'package:you_commute/services/ttc_service.dart';
import 'package:you_commute/views/home/widgets/stops_card.dart';

void showTransitInfo(BuildContext context, GoogleMapsController controller) {
  showModalBottomSheet(
    backgroundColor: kcBackgroundColor,

    context: context,
    isScrollControlled: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: DefaultTabController(
              length: TTCService.transitTypes.length,
              child: Column(
                children: [
                  TabBar(
                    indicatorColor: kcPrimaryColor,
                    labelColor: kcBlackColor,
                    unselectedLabelColor: kcBlackColor,

                    tabs:
                        TTCService.transitTypes.entries
                            .map(
                              (e) => Tab(
                                height: 60,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: kcWhitecolor,
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        _getTransitIcon(e.key),
                                        color: kcBlackColor,
                                      ),
                                      Text(
                                        e.value,
                                        style: getRegularStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                  Expanded(
                    child: TabBarView(
                      children:
                          TTCService.transitTypes.keys.map((transitType) {
                            return FutureBuilder<List<Map<String, dynamic>>>(
                              future: TTCService.getRoutesByType(transitType),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text('Error: ${snapshot.error}'),
                                  );
                                }

                                final routes = snapshot.data ?? [];
                                return ListView.builder(
                                  itemCount: routes.length,
                                  itemBuilder: (context, index) {
                                    final route = routes[index];
                                    return StopsCard(route: route);
                                  },
                                );
                              },
                            );
                          }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

IconData _getTransitIcon(String transitType) {
  switch (transitType) {
    case 'bus':
      return Icons.directions_bus;
    case 'streetcar':
      return Icons.tram;
    case 'subway':
      return Icons.subway;
    default:
      return Icons.directions_transit;
  }
}
