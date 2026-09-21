// import 'package:attendenceapp/Ui/Screens/Bottom%20Nav%20Screens/bottom_nav_controlle.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// // Get use korchen tai import rakha hoyeche

// class CustomBottomNavigationBar extends StatelessWidget {
//   final int currentIndex;

//   const CustomBottomNavigationBar({super.key, required this.currentIndex});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         border: Border(
//           top: BorderSide(
//             color: Color(0xFF7F2AFF), // Border color
//             width: 1, // Border thickness
//           ),
//         ),
//       ),
//       child: NavigationBarTheme(
//         data: NavigationBarThemeData(
//           backgroundColor: Colors.white,
//           indicatorColor: Colors.white.withOpacity(0.2),

//           // 🔸 Label text color customization (Same as your code)
//           labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((
//             Set<WidgetState> states,
//           ) {
//             if (states.contains(WidgetState.selected)) {
//               return const TextStyle(
//                 color: Colors.black,
//                 fontWeight: FontWeight.w500,
//               );
//             }
//             return const TextStyle(
//               color: Colors.black,
//               fontWeight: FontWeight.w400,
//             );
//           }),
//         ),
//         child: NavigationBar(
//           selectedIndex: currentIndex,
//           elevation: 10,
//           onDestinationSelected: (index) {
//             // Apnar exact navigation logic
//             Get.offAll(() => BottomNavControllerScreen(initialIndex: index));
//           },
//           destinations: [
//             NavigationDestination(
//               icon: Image.asset(
//                 "assets/images/attendance.png",
//                 height: 30,
//                 width: 30,
//               ),
//               label: "Attendance",
//             ),
//             NavigationDestination(
//               icon: Image.asset(
//                 "assets/images/task.png",
//                 height: 30,
//                 width: 30,
//               ),
//               label: "Task",
//             ),

//             NavigationDestination(
//               icon: Image.asset(
//                 "assets/images/sales.png",
//                 height: 30,
//                 width: 30,
//               ),
//               label: "Sales Order",
//             ),
//             NavigationDestination(
//               icon: Image.asset(
//                 "assets/images/visit.png",
//                 height: 30,
//                 width: 30,
//               ),
//               label: "Visit",
//             ),
//             NavigationDestination(
//               icon: Image.asset(
//                 "assets/images/profile.png",
//                 height: 30,
//                 width: 30,
//               ),
//               label: "Profile",
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
