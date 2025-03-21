import 'package:you_commute/app/app_textstyle/app_textstyles.dart';
import 'package:you_commute/imports.dart';
import 'package:you_commute/views/home/controller/google_maps_controller.dart';
import 'package:you_commute/views/home/widgets/show_routes_details.dart';

class StopsCard extends StatelessWidget {
  final Map<String, dynamic> route;
  const StopsCard({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: kcWhitecolor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kcBorderColor),
      ),
      child: InkWell(
        onTap:
            () => showRouteDetails(
              context,
              Get.find<GoogleMapsController>(),
              route['tag'],
            ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getTransitIcon(route['type']),
                    color: Theme.of(context).primaryColor,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      route['title'],
                      style: getMediumStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Route ${route['tag']}',
                style: getRegularStyle(color: kcTextGrey, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
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
