import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:devsalesxpert/features/auth/presentation/AuthController.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/screen_background.dart';
import 'package:devsalesxpert/features/profile/presentation/screens/profile_screen.dart';

class TrackingScreen extends StatefulWidget {
  final int fromTabIndex;
  const TrackingScreen({super.key, this.fromTabIndex = 4});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  double? curlat;
  double? curlong;
  String address = "Loading...";
  String? wifiname;
  String? mackaddress;
  String? androidId;

  Future<void> _mackWifiName() async {
    String? name = await info.getWifiName();
    String? mac = await info.getWifiBSSID();
    name = name?.replaceAll('"', '').trim();

    setState(() {
      wifiname = name;
      mackaddress = mac;
    });
  }

  final NetworkInfo info = NetworkInfo();

  @override
  void initState() {
    super.initState();
    _loadAndroidId();
    _mackWifiName();
    _fetchLocationAndAddress();
  }

  // Future<void> _loadAndroidId() async {
  //   setState(() {
  //     androidId = "Fetching..."; // FIXED: Show fetching state
  //   });

  //   try {
  //     final deviceInfo = DeviceInfoPlugin();
  //     final android = await deviceInfo.androidInfo;
  //     setState(() {
  //       androidId = android.id;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       androidId = "Error: $e";
  //     });
  //   }
  // }

  Future<void> _loadAndroidId() async {
    // Get the ID from the method
    final id = await DeviceIdService.getDeviceId();

    setState(() {
      androidId = id ?? "Failed to get ID";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back(result: () => ProfileScreen());
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),

        title: Text(
          "Track",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    Text(
                      AuthController.userModel?.nameenglish ?? "No Name",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    Text(
                      AuthController.userModel?.departmentname.toString() ??
                          "No Name",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),

                    Text(
                      AuthController.userModel?.designationname.toString() ??
                          "No Name",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),

                    Text(
                      AuthController.userModel?.companyName.toString() ??
                          "No Name",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 80),

              // wifi button
              wifiname != null && mackaddress != null
                  ? Column(
                      children: [
                        Text("WIFI Name: $wifiname"),
                        Text("MAC Address: $mackaddress"),
                      ],
                    )
                  : Text(
                      "Check Wifiname and Mackaddress",
                      style: TextStyle(color: Colors.grey),
                    ),

              SizedBox(height: 10),

              GestureDetector(
                onTap: () async {
                  await _mackWifiName();
                },
                child: Container(
                  height: 45,
                  width: 110,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(
                          0.1,
                        ), // Soft shadow color
                        spreadRadius: 2, // How far the shadow spreads
                        blurRadius: 4, // How soft the shadow looks
                        offset: const Offset(
                          0,
                          4,
                        ), // Shifts shadow down (X, Y) to look raised
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
                        Image.asset(
                          "assets/images/wifi.png",
                          height: 20,
                          width: 20,
                        ),
                        Text(
                          "WIFI",
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

              SizedBox(height: 20),

              // gps button
              curlat != null && curlat != null
                  ? Column(
                      children: [
                        Text("Latitude: $curlat"),
                        Text("Longitude: $curlong"),
                        Text("Location: $address"),
                      ],
                    )
                  : Text(
                      "Check Latitude & Longitude",
                      style: TextStyle(color: Colors.grey),
                    ),
              SizedBox(height: 10),

              GestureDetector(
                onTap: () async {
                  await _fetchLocationAndAddress();
                },
                child: Container(
                  height: 45,
                  width: 110,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(
                          0.1,
                        ), // Soft shadow color
                        spreadRadius: 2, // How far the shadow spreads
                        blurRadius: 4, // How soft the shadow looks
                        offset: const Offset(
                          0,
                          4,
                        ), // Shifts shadow down (X, Y) to look raised
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
                        Image.asset(
                          "assets/images/gps.png",
                          height: 20,
                          width: 20,
                        ),
                        Text(
                          "GPS",
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

              SizedBox(height: 20),

              // andorid id button
              androidId != null
                  ? Text("Android ID: $androidId")
                  : Text(
                      "Check Android Id",
                      style: TextStyle(color: Colors.grey),
                    ),
              SizedBox(height: 10),

              GestureDetector(
                onTap: () async {
                  await _loadAndroidId();
                },
                child: Container(
                  height: 45,
                  width: 110,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(
                          0.1,
                        ), // Soft shadow color
                        spreadRadius: 2, // How far the shadow spreads
                        blurRadius: 4, // How soft the shadow looks
                        offset: const Offset(
                          0,
                          4,
                        ), // Shifts shadow down (X, Y) to look raised
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
                        Image.asset(
                          "assets/images/android.png",
                          height: 20,
                          width: 20,
                        ),
                        Text(
                          "Android ID",
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

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: CustomBottomNavigationBar(
      //   currentIndex: widget.fromTabIndex,
      // ),
    );
  }

  // Combined function: GPS + address
  Future<void> _fetchLocationAndAddress() async {
    try {
      // 1️⃣ GPS permission & service check
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) setState(() => address = "Please Turn On location");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) setState(() => address = "Location permission denied");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted)
          // ignore: curly_braces_in_flow_control_structures
          setState(() => address = "Location permission permanently denied");
        return;
      }

      // 2️⃣ Get GPS coordinates
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      double lat = pos.latitude;
      double long = pos.longitude;

      // Check mounted before modifying state after async gap
      if (!mounted) return;
      setState(() {
        curlat = lat;
        curlong = long;
      });

      // 3️⃣ Fetch address
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

      if (!mounted) return;

      if (placemarks.isNotEmpty) {
        Placemark first = placemarks.first;
        setState(() {
          address =
              "${first.street ?? ''}, ${first.subLocality ?? ''}, ${first.locality ?? ''}";
        });
      } else {
        setState(() => address = "No address found");
      }
    } catch (e) {
      if (mounted) setState(() => address = "Error fetching location");
    }
  }
}

class DeviceIdService {
  static const MethodChannel _channel = MethodChannel('device_info_channel');

  static Future<String?> getDeviceId() async {
    try {
      final String? id = await _channel.invokeMethod('getDeviceId');
      return id;
    } catch (e) {
      return null;
    }
  }
}
