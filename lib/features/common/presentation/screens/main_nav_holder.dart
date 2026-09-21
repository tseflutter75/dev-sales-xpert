import 'package:flutter/material.dart';
import 'package:devsalesxpert/features/home/presentation/screens/home_attendance_screen.dart';
import 'package:devsalesxpert/features/profile/presentation/screens/profile_screen.dart';
import 'package:devsalesxpert/features/sales/presentation/screens/sales_order_view_screen.dart';
import 'package:devsalesxpert/features/task/presentation/screens/task_view_screen.dart';
import 'package:devsalesxpert/features/visit/presentation/screens/visit_view_screen.dart';

class BottomNavControllerScreen extends StatefulWidget {
  final int initialIndex;

  const BottomNavControllerScreen({super.key, this.initialIndex = 0});

  @override
  State<BottomNavControllerScreen> createState() => _BottomNavControllerState();
}

class _BottomNavControllerState extends State<BottomNavControllerScreen> {
  late int selected;

  final List<Widget> _pages = [
    HomeScreen(),
    const TaskViewScreen(),
    const SalesOrderViewScreen(),
    const VisitScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selected = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AnimatedSwitcher for smooth transitions
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.1),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: _pages[selected],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade200, // Border color
              width: 1, // Border thickness
            ),
          ),
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: Colors.white,
            indicatorColor: Colors.white.withOpacity(0.2),

            // 🔸 Label text color customization
            labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((
              Set<WidgetState> states,
            ) {
              if (states.contains(WidgetState.selected)) {
                return const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                );
              }
              return const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
              );
            }),
          ),
          child: NavigationBar(
            selectedIndex: selected,
            elevation: 10,
            onDestinationSelected: (value) {
              setState(() => selected = value);
            },
            destinations: [
              NavigationDestination(
                icon: Image.asset(
                  "assets/images/attendance.png",

                  height: 30,
                  width: 30,
                ),
                label: "HRIS",
              ),
              NavigationDestination(
                icon: Image.asset(
                  "assets/images/task.png",

                  height: 30,
                  width: 30,
                ),
                label: "Task",
              ),

              NavigationDestination(
                icon: Image.asset(
                  "assets/images/sales.png",
                  height: 30,
                  width: 30,
                ),
                label: "Sales Order",
              ),

              NavigationDestination(
                icon: Image.asset(
                  "assets/images/visit.png",

                  height: 30,
                  width: 30,
                ),
                label: "Visit",
              ),
              NavigationDestination(
                icon: Image.asset(
                  "assets/images/profile.png",

                  height: 30,
                  width: 30,
                ),

                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}




























// // ১. ট্যাব ডাটা মডেল
// class TabConfig {
//   final String label;
//   final String iconPath;
//   final Widget screen;

//   TabConfig({
//     required this.label,
//     required this.iconPath,
//     required this.screen,
//   });
// }

// class BottomNavControllerScreen extends StatefulWidget {
//   final int initialIndex;
//   final int? companyId; // লগইন থেকে পাওয়া আইডি

//   const BottomNavControllerScreen({
//     super.key,
//     this.initialIndex = 0,
//     this.companyId,
//   });

//   @override
//   State<BottomNavControllerScreen> createState() => _BottomNavControllerState();
// }

// class _BottomNavControllerState extends State<BottomNavControllerScreen> {
//   late int selected;
//   late List<TabConfig> _activeTabs;

//   // ২. কোম্পানি অনুযায়ী কনফিগ সেটআপ
//   final Map<int, List<TabConfig>> _configs = {
//     21: [
//       TabConfig(
//         label: "HRIS",
//         iconPath: "attendance.png",
//         screen: HomeScreen(),
//       ),
//       TabConfig(
//         label: "Task",
//         iconPath: "task.png",
//         screen: const TaskViewScreen(),
//       ),
//       TabConfig(
//         label: "Sales",
//         iconPath: "sales.png",
//         screen: const SalesOrderViewScreen(),
//       ),
//       TabConfig(
//         label: "Visit",
//         iconPath: "visit.png",
//         screen: const VisitScreen(),
//       ),
//       TabConfig(
//         label: "Profile",
//         iconPath: "profile.png",
//         screen: const ProfileScreen(),
//       ),
//     ],
//     // 24: [
//     //   TabConfig(
//     //     label: "Attendance",
//     //     iconPath: "attendance.png",
//     //     screen: HomeScreen(),
//     //   ),
//     //   TabConfig(
//     //     label: "Task",
//     //     iconPath: "task.png",
//     //     screen: const TaskViewScreen(),
//     //   ),
//     //   TabConfig(
//     //     label: "Visit",
//     //     iconPath: "visit.png",
//     //     screen: const VisitScreen(),
//     //   ),
//     //   TabConfig(
//     //     label: "Profile",
//     //     iconPath: "profile.png",
//     //     screen: const ProfileScreen(),
//     //   ),
//     // ],
//     // নতুন কোম্পানি আসলে এখানে আইডি দিয়ে অ্যাড করবেন
//   };

//   @override
//   void initState() {
//     super.initState();
//     selected = widget.initialIndex;

//     // কোম্পানি আইডি অনুযায়ী ট্যাব সিলেক্ট করা, না মিললে ২১ ডিফল্ট
//     _activeTabs =
//         _configs[AuthController.userModel!.companyid] ?? _configs[21]!;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // ✅ আপনার সেই AnimatedSwitcher
//       body: AnimatedSwitcher(
//         duration: const Duration(milliseconds: 300),
//         transitionBuilder: (child, animation) {
//           return FadeTransition(
//             opacity: animation,
//             child: SlideTransition(
//               position: Tween<Offset>(
//                 begin: const Offset(0.0, 0.1),
//                 end: Offset.zero,
//               ).animate(animation),
//               child: child,
//             ),
//           );
//         },
//         child: _activeTabs[selected].screen, // ডাইনামিক স্ক্রিন
//       ),
//       bottomNavigationBar: Container(
//         decoration: const BoxDecoration(
//           border: Border(top: BorderSide(color: Color(0xFF7F2AFF), width: 1)),
//         ),
//         child: NavigationBarTheme(
//           data: NavigationBarThemeData(
//             backgroundColor: Colors.white,
//             indicatorColor: Colors.white.withOpacity(0.2),
//             labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((
//               states,
//             ) {
//               if (states.contains(WidgetState.selected)) {
//                 return const TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.w500,
//                 );
//               }
//               return const TextStyle(
//                 color: Colors.black,
//                 fontWeight: FontWeight.w400,
//               );
//             }),
//           ),
//           child: NavigationBar(
//             selectedIndex: selected,
//             elevation: 10,
//             onDestinationSelected: (value) {
//               setState(() => selected = value);
//             },
//             // ✅ ডাইনামিক ডেসটিনেশন লিস্ট
//             destinations: _activeTabs.map((tab) {
//               return NavigationDestination(
//                 icon: Image.asset(
//                   "assets/images/${tab.iconPath}",
//                   height: 30,
//                   width: 30,
//                 ),
//                 label: tab.label,
//               );
//             }).toList(),
//           ),
//         ),
//       ),
//     );
//   }
// }

