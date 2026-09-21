import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:devsalesxpert/features/auth/presentation/AuthController.dart';
import 'package:devsalesxpert/features/auth/presentation/screens/login_screen.dart';
import 'package:devsalesxpert/features/check%20location%20and%20internet/presentation/screens/location_permission_screen.dart';
import 'package:devsalesxpert/features/check%20location%20and%20internet/presentation/screens/no_internet_screen.dart';
import 'package:devsalesxpert/features/common/presentation/screens/main_nav_holder.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/circular_progress_indicator.dart';

class CheckLocationInternetScreen extends StatefulWidget {
  const CheckLocationInternetScreen({super.key});

  @override
  State<CheckLocationInternetScreen> createState() => _CheckInternetState();
}

class _CheckInternetState extends State<CheckLocationInternetScreen>
    with WidgetsBindingObserver {
  bool? hasInternet;
  bool? hasLocation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initChecks();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // 🔁 When user returns from settings
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _initChecks();
    }
  }

  Future<void> _initChecks() async {
    setState(() {
      hasInternet = null;
      hasLocation = null;
    });

    await _checkInternet();

    if (hasInternet == true) {
      await _checkLocation();
    }

    if (hasInternet == true && hasLocation == true) {
      _moveToNextScreen();
    }
  }

  // // 🌐 Internet check
  // Future<void> _checkInternet() async {
  //   List<ConnectivityResult> res =
  //   await Connectivity().checkConnectivity();

  //   hasInternet = !res.contains(ConnectivityResult.none);
  //   setState(() {});
  // }

  // 🌐 Internet check (Updated Logic)
  Future<void> _checkInternet() async {
    List<ConnectivityResult> res = await Connectivity().checkConnectivity();

    // এখানে চেক করছি যে লিস্টে wifi, mobile অথবা ethernet এর কোনো একটি আছে কি না
    if (res.contains(ConnectivityResult.mobile) ||
        res.contains(ConnectivityResult.wifi) ||
        res.contains(ConnectivityResult.ethernet)) {
      hasInternet = true;
    } else {
      hasInternet = false;
    }

    setState(() {});
  }

  // 📍 Location + permission check
  Future<void> _checkLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      hasLocation = false;
      setState(() {});
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      hasLocation = false;
      setState(() {});
      return;
    }

    hasLocation = true;
    setState(() {});
  }

  // login yes or no
  Future<void> _moveToNextScreen() async {
    final bool isLoggedIn = await AuthController.isUserAlreadyLoggedIn();
    if (isLoggedIn) {
      await AuthController.getUserData();
      Get.off(() => BottomNavControllerScreen());
    } else {
      Get.off(() => LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    // ⏳ checking internet
    if (hasInternet == null) {
      return const Scaffold(
        body: Center(child: CustomCircularProgressIndicator()),
      );
    }

    // ❌ No internet
    if (hasInternet == false) {
      return NoInternetScreen(onRetry: _initChecks);
    }

    // ⏳ checking location
    if (hasLocation == null) {
      return const Scaffold(
        body: Center(child: CustomCircularProgressIndicator()),
      );
    }

    // ❌ Location issue
    if (hasLocation == false) {
      return LocationRequiredScreen(
        onRetry: () async {
          await Geolocator.openLocationSettings();
        },
      );
    }

    // ✅ All good
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [CustomCircularProgressIndicator(), SizedBox(height: 16)],
        ),
      ),
    );
  }
}
