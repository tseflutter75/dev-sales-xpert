import 'package:flutter/material.dart';

class SplashScreenBackground extends StatelessWidget {
  const SplashScreenBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/images/loginbg.jpg',
          width: double.maxFinite,
          height: double.maxFinite,
          fit: BoxFit.cover,
        ),
        SafeArea(child: child),
      ],
    );
  }
}
