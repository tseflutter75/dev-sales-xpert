import 'package:devsalesxpert/features/check%20location%20and%20internet/presentation/screens/check_internet_screen.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/screen_background_splah.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String name = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _moveToNextScreen();
  }

  Future<void> _moveToNextScreen() async {
    await Future.delayed(Duration(seconds: 3));
    Get.off(() => CheckLocationInternetScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashScreenBackground(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Center(
                child: Image.asset("assets/images/logo.png", width: 250),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
