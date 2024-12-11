import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:my_heart_son/screens/setting.dart';
import 'package:my_heart_son/screens/splash.dart';
import 'package:my_heart_son/screens/tree.dart';

const Transition transition = Transition.fade; // Transition
const transitionDuration = Duration(milliseconds: 300);

List<GetPage> route() {
  return [
    GetPage(
      name: Setting.routeName,
      transition: transition,
      transitionDuration: transitionDuration,
      page: () => const Setting(),
    ),
    GetPage(
      name: Tree.routeName,
      transition: transition,
      transitionDuration: transitionDuration,
      page: () => const Tree(),
    ),
    GetPage(
      name: Splash.routeName,
      transition: transition,
      transitionDuration: transitionDuration,
      page: () => const Splash(),
    ),
  ];
}
