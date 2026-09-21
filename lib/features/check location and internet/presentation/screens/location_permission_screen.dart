import 'package:flutter/material.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/screen_background.dart';

class LocationRequiredScreen extends StatelessWidget {
  final VoidCallback onRetry;

  const LocationRequiredScreen({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_off, size: 80, color: Colors.white),
                const SizedBox(height: 16),
                const Text(
                  "Turn On Location & continue",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),

                GestureDetector(
                  onTap: onRetry,
                  child: Container(
                    height: 45,
                    width: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF8F66DC),
                          Color(0xFFDED0FD),
                          Color(0xFF8F66DC),
                        ],
                      ),
                      boxShadow: [
                        // inner glow
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: const Color(0xFF9161FF).withOpacity(0.2),
                          blurRadius: 15,
                          spreadRadius: -2,
                          offset: const Offset(0, 0),
                        ),
                        // outter glow
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: const Color(0xFF9161FF).withOpacity(0.20),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(1.5),

                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 3),
                          Image.asset(
                            "assets/images/gps.png",
                            height: 17,
                            width: 17,
                          ),
                          Text(
                            "Enable Location",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
