import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:devsalesxpert/app/app_color.dart.dart';
import 'package:devsalesxpert/app/app_rountes.dart';
import 'package:devsalesxpert/main.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // handel font size dafult small or larage in android system...
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: child!,
        );
      },
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'HR Time',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.themeColor),
        useMaterial3: true,

        // for appbar
        // for appbar.................
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),

      initialRoute: '/splash',
      getPages: AppPages.routes,
    );
  }
}










// class AppTheme {
//   static ThemeData get lightTheme {
//     return ThemeData(
//       brightness: Brightness.light,
//       colorSchemeSeed: AppColors.themeColor,
//       scaffoldBackgroundColor: Colors.white,
//       progressIndicatorTheme: ProgressIndicatorThemeData(
//         color: AppColors.themeColor,
//       ),
//       inputDecorationTheme: _getInputDecorationTheme(),
//       filledButtonTheme: _getFilledButtonTheme(),
//     );
//   }

//   static ThemeData get darkTheme {
//     return ThemeData(
//       brightness: Brightness.dark,
//       colorSchemeSeed: AppColors.themeColor,

//       progressIndicatorTheme: ProgressIndicatorThemeData(
//         color: AppColors.themeColor,
//       ),
//       inputDecorationTheme: _getInputDecorationTheme(),
//       filledButtonTheme: _getFilledButtonTheme(),
//     );
//   }

//   //... light dart theme done.....................................................

//   static InputDecorationTheme _getInputDecorationTheme() {
//     return InputDecorationTheme(
//       hintStyle: TextStyle(fontWeight: FontWeight.w300),
//       contentPadding: EdgeInsets.symmetric(horizontal: 12),
//       border: OutlineInputBorder(
//         borderSide: BorderSide(color: AppColors.themeColor),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderSide: BorderSide(color: AppColors.themeColor),
//       ),

//       focusedBorder: OutlineInputBorder(
//         borderSide: BorderSide(color: AppColors.themeColor, width: 2),
//       ),

//       errorBorder: OutlineInputBorder(
//         borderSide: BorderSide(color: Colors.red, width: 2),
//       ),
//     );
//   }

//   static FilledButtonThemeData _getFilledButtonTheme() {
//     return FilledButtonThemeData(
//       style: FilledButton.styleFrom(
//         fixedSize: Size.fromWidth(double.maxFinite),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         backgroundColor: AppColors.themeColor,
//         textStyle: TextStyle(fontWeight: FontWeight.w700),
//       ),
//     );
//   }
// }