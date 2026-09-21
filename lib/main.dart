// Initail Set up
// 1. Folder structure
// 2. Firebase set up
// 3. Firebase crashlytics
// 4. Firebase analytics
// 5. Localization
// 6. Theme
// 7. Routing
// 8. Network Caller

import 'package:flutter/material.dart';
import 'package:devsalesxpert/app/app.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // background service initialization
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}
