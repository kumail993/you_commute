import 'package:you_commute/imports.dart';
import 'package:you_commute/views/home/models/commutes_model.dart';

class HomeController extends GetxController {
  List<CommutesModel> commutes = [
    CommutesModel(name: 'Bus', icon: 'assets/images/icon.png'),
    CommutesModel(name: 'Subway', icon: 'assets/images/icon.png'),
    CommutesModel(name: 'Steercar', icon: 'assets/images/icon.png'),
  ];
}
