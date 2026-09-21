import 'package:flutter/material.dart';

class ScreenBackground extends StatelessWidget {
  const ScreenBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/homebg.jpg',
            ), // Replace with your actual asset path
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(child: child),
      ),
    );
  }
}
