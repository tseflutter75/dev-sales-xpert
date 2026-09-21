import 'package:get/get.dart';
import 'package:devsalesxpert/features/auth/presentation/screens/login_screen.dart';
import 'package:devsalesxpert/features/auth/presentation/screens/splash_screen.dart';
import 'package:devsalesxpert/features/common/presentation/screens/main_nav_holder.dart';

// app_routes.dart
abstract class Routes {
  // ignore: constant_identifier_names
  static const SPLASH = '/splash';
  // ignore: constant_identifier_names
  static const BOTTOM = '/bottom';
  // ignore: constant_identifier_names
  static const LOGIN = '/login';
  // ignore: constant_identifier_names
  static const SIGNUP = '/signup';
}

// app_pages.dart
class AppPages {
  // ignore: constant_identifier_names
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(name: Routes.SPLASH, page: () => SplashScreen()),
    GetPage(name: Routes.LOGIN, page: () => LoginScreen()),

    GetPage(name: Routes.BOTTOM, page: () => BottomNavControllerScreen()),
  ];
}
