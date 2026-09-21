import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:devsalesxpert/features/check%20location%20and%20internet/presentation/screens/check_internet_screen.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/screen_background.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key, required Future<void> Function() onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off, size: 100, color: Colors.white),
              const SizedBox(height: 20),
              const Text(
                "No Internet Connection!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Please turn on your wifi or mobile data.",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // Refresh Button
              InkWell(
                onTap: () async {
                  var connectivityResult = await Connectivity()
                      .checkConnectivity();

                  if (!connectivityResult.contains(ConnectivityResult.none)) {
                    Get.offAll(() => const CheckLocationInternetScreen());
                  } else {
                    Get.snackbar(
                      "No Internet",
                      "Still no internet found. Please check again.",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Color(0xFF00A8AA),
                      colorText: Colors.white,
                    );
                  }
                },
                child: const Column(
                  children: [
                    Icon(Icons.refresh, size: 40, color: Color(0xFF7F2AFF)),
                    Text(
                      "Try Again",
                      style: TextStyle(color: Color(0xFF7F2AFF), fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
