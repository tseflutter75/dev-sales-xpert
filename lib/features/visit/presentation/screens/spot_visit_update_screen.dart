import 'dart:convert';
import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:devsalesxpert/app/urls.dart';
import 'package:devsalesxpert/core/services/network_caller.dart';
import 'package:devsalesxpert/features/auth/presentation/AuthController.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/circular_progress_indicator.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/screen_background.dart';
import 'package:devsalesxpert/features/visit/data/models/client_type_drop_dwon_model.dart';
import 'package:devsalesxpert/features/visit/data/models/purpose_drop_dwon_model.dart';
import 'package:devsalesxpert/features/visit/data/models/transpot_tyep_drop_dwon_model.dart';
import 'package:devsalesxpert/features/visit/data/models/visit_and_spot_visit_usermodel.dart';

class SpotVisitUpdate extends StatefulWidget {
  final VisitSpotModel item;
  final VisitSpotModel iD;
  final int fromTabIndex;
  const SpotVisitUpdate({
    super.key,
    required this.item,
    this.fromTabIndex = 3,
    required this.iD,
  });

  @override
  State<SpotVisitUpdate> createState() => _SpotVisitUpdateState();
}

class _SpotVisitUpdateState extends State<SpotVisitUpdate> {
  final TextEditingController _clientnameController = TextEditingController();
  final TextEditingController _visitPurposeController = TextEditingController();

  final TextEditingController _contactpersonController =
      TextEditingController();
  final TextEditingController _contactpersonMobileController =
      TextEditingController();

  final TextEditingController _transportController = TextEditingController();
  final TextEditingController _conveyanceController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  final GlobalKey<FormState> _fromKey = GlobalKey<FormState>();
  File? image;
  String? oldImage;

  double? curlat;
  double? curlong;
  String curAddress = "";

  bool inprogresssvisitspotstrore = false;
  bool inprogrssspotView = false;

  bool inprogresssTrasport = false;

  // client get api
  final List<TranspotTyepDropDwonModel> _transpotNameList = [];
  TranspotTyepDropDwonModel? selectedTransport;
  Future<void> _fetchTranspotList() async {
    inprogresssTrasport = true;
    setState(() {});
    ApiResponse response = await NetworkCaller.getRequest(
      url: Urls.visittranspotUrl,
      token: AuthController.accessToken,
    );

    if (response.isSuccess) {
      final transpottypeData = response.responseData;
      for (Map<String, dynamic> transpottypeJson in transpottypeData['data']) {
        final transpottypeModelall = TranspotTyepDropDwonModel.fromJson(
          transpottypeJson,
        );
        _transpotNameList.add(transpottypeModelall);
      }

      setState(() {
        if (_transpotNameList.isNotEmpty) {
          try {
            selectedTransport = _transpotNameList.firstWhere(
              (p) =>
                  p.vehicleType.toString() ==
                  widget.item.spotVehicleType.toString(),
            );
          } catch (e) {
            selectedTransport = null;
          }
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
          content: Center(
            child: Text(
              response.errorMessage,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }
    inprogresssTrasport = false;
    setState(() {});
  }

  // client get api
  final List<ClientTypeModel> _clientNameList = [];
  ClientTypeModel? selectedClient;
  Future<void> _fetchclintList() async {
    ApiResponse response = await NetworkCaller.getRequest(
      url: Urls.clientfromUrl,
      token: AuthController.accessToken,
    );

    if (response.isSuccess) {
      final clienttypeData = response.responseData;
      for (Map<String, dynamic> clienttypeJson in clienttypeData['data']) {
        final clienttypeModelall = ClientTypeModel.fromJson(clienttypeJson);
        _clientNameList.add(clienttypeModelall);
      }

      if (_clientNameList.isNotEmpty) {
        try {
          selectedClient = _clientNameList.firstWhere(
            (client) =>
                client.name.toString().trim() ==
                widget.item.spotClientName.toString().trim(),
          );
        } catch (e) {
          selectedClient = null;
        }
      }
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
          content: Center(
            child: Text(
              response.errorMessage,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }
  }

  // purpose meeting get api
  final List<PurposeModel> _purposeNameList = [];
  PurposeModel? selectedPurpose;
  Future<void> _fetchpurposeList() async {
    ApiResponse response = await NetworkCaller.getRequest(
      url: Urls.purposefromUrl,
      token: AuthController.accessToken,
    );

    if (response.isSuccess) {
      final purposeData = response.responseData;
      _purposeNameList.clear();
      for (Map<String, dynamic> purposeJson in purposeData['data']) {
        final purposeModelall = PurposeModel.fromJson(purposeJson);
        _purposeNameList.add(purposeModelall);
      }

      if (_purposeNameList.isNotEmpty) {
        try {
          selectedPurpose = _purposeNameList.firstWhere(
            (p) =>
                p.visitPurpose.toString() ==
                widget.item.spotVisitPurpose.toString(),
          );
        } catch (e) {
          selectedPurpose = null;
        }
      }
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
          content: Center(
            child: Text(
              response.errorMessage,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    print("Passed ID: ${widget.iD}");

    // TextField controllers
    _visitPurposeController.text = widget.item.spotVisitPurpose ?? '';
    _contactpersonController.text = widget.item.spotContactPerson ?? '';
    _contactpersonMobileController.text =
        widget.item.spotContactPersonMobile ?? '';
    _conveyanceController.text = widget.item.spotVehicleBill ?? '';
    _remarksController.text = widget.item.spotremarks ?? '';

    if (widget.item.spotImage != null && widget.item.spotImage!.isNotEmpty) {
      oldImage = widget.item.spotImage;
    }

    _fetchclintList();
    _fetchpurposeList();
    _fetchTranspotList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        centerTitle: true,

        title: const Text(
          "Spot Update",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _fromKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize:
                    MainAxisSize.min, // Essential for bottom sheet height
                children: [
                  SizedBox(height: 10),

                  // drop dwon customer name
                  // clint type x
                  DropdownSearch<ClientTypeModel>(
                    items: _clientNameList,
                    itemAsString: (ClientTypeModel t) => t.name.toString(),
                    selectedItem: selectedClient,

                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      showSelectedItems: false,
                    ),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        isDense: true,

                        hintText: "Select Customer",
                        filled: true,
                        fillColor: Colors.white,

                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),

                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    onChanged: (ClientTypeModel? client) {
                      if (client != null) {
                        setState(() {
                          selectedClient = client;
                          _contactpersonController.text =
                              client.ownerName ?? '';
                          _contactpersonMobileController.text =
                              client.mobileNo ?? '';
                        });
                      }
                    },
                    validator: (ClientTypeModel? client) =>
                        client == null ? "Please select a customer" : null,
                  ),
                  SizedBox(height: 10),

                  TextFormField(
                    key: ValueKey("Contact Person"),
                    controller: _contactpersonController,

                    keyboardType:
                        TextInputType.text, // Changed to text as it's a name
                    decoration: InputDecoration(
                      labelText: "Contact Person",
                      hintText: "Contact Person",
                      filled: true,
                      fillColor: Colors.white,

                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.0,
                        ),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.0,
                        ),
                      ),

                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.0,
                        ),
                      ),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the Contact Person";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),

                  TextFormField(
                    key: ValueKey("Mobile"),
                    controller: _contactpersonMobileController,

                    keyboardType:
                        TextInputType.number, // Changed to text as it's a name
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(11),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      labelText: "Mobile",
                      hintText: "Mobile",
                      filled: true,
                      fillColor: Colors.white,

                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.0,
                        ),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.0,
                        ),
                      ),

                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.0,
                        ),
                      ),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the Mobile";
                      } else if (value.length != 11) {
                        return "Enter valid mobile num. (11 digit)";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 10),

                  DropdownSearch<PurposeModel>(
                    key: ValueKey("purpose"),
                    items: _purposeNameList,
                    itemAsString: (PurposeModel p) => p.visitPurpose.toString(),
                    selectedItem: selectedPurpose,
                    onChanged: (PurposeModel? pur) {
                      setState(() {
                        selectedPurpose = pur;
                      });
                    },
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          hintText: "Search purpose..",
                          labelText: "Select purpose",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      showSelectedItems: false,
                    ),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "Select purpose",
                        filled: true,
                        fillColor: Colors.white,

                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),

                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    validator: (PurposeModel? pur) =>
                        pur == null ? "Please select a purpose" : null,
                  ),

                  SizedBox(height: 10),

                  DropdownSearch<TranspotTyepDropDwonModel>(
                    key: ValueKey("Transport"),
                    items: _transpotNameList,
                    itemAsString: (TranspotTyepDropDwonModel d) =>
                        d.vehicleType,
                    selectedItem: selectedTransport,
                    onChanged: (TranspotTyepDropDwonModel? tst) {
                      setState(() {
                        selectedTransport = tst;
                        _transportController.text = tst?.vehicleType ?? "";

                        if (tst?.vehicleType == "Walking") {
                          _conveyanceController.text = "0";
                        } else {
                          _conveyanceController.text = "";
                        }
                      });
                    },
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          hintText: "Search Transport..",
                          labelText: "Select Transport",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      showSelectedItems: false,
                    ),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "Select Transport",
                        filled: true,
                        fillColor: Colors.white,

                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),

                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    validator: (TranspotTyepDropDwonModel? value) {
                      if (value == null) {
                        return "Please select a transport";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),

                  TextFormField(
                    controller: _conveyanceController,
                    //  If walking, the user will not be able to type (ReadOnly), otherwise they will be able to
                    //  readOnly: selectedTransport == "Walking",
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Conveyance(Tk)",
                      hintText: "Enter amount",
                      //  If you are walking, the background will look a little gray.
                      // filled: selectedTransport == "Walking",
                      filled: true,
                      fillColor: Colors.white,

                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.0,
                        ),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.0,
                        ),
                      ),

                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.0,
                        ),
                      ),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter the amount";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _openCamera,
                        child: Container(
                          height: 70,
                          width: 70,
                          color: Colors.grey.shade300,
                          child: Icon(Icons.camera_alt_outlined, size: 40),
                        ),
                      ),
                      SizedBox(width: 20),

                      image != null
                          ? Image.file(
                              image!,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            )
                          : oldImage != null
                          ? Image.network(
                              oldImage!,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            )
                          : Text('No image'),
                    ],
                  ),

                  SizedBox(height: 10),
                  TextFormField(
                    maxLines: null,
                    key: ValueKey("Feedback"),
                    controller: _remarksController,

                    keyboardType:
                        TextInputType.text, // Changed to text as it's a name
                    decoration: InputDecoration(
                      labelText: "Feedback",
                      hintText: "Feedback",
                      filled: true,
                      fillColor: Colors.white,

                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.0,
                        ),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.0,
                        ),
                      ),

                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.0,
                        ),
                      ),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your feedback";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),

                  Visibility(
                    visible: inprogresssvisitspotstrore == false,
                    replacement: Center(
                      child: CustomCircularProgressIndicator(),
                    ),
                    child: FilledButton(
                      onPressed: () async {
                        // async add
                        if (_fromKey.currentState!.validate()) {
                          await _fetchLocationAndAddress();
                          visitSpotUpdateStore();
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.resolveWith<Color>(
                          (states) {
                            if (states.contains(WidgetState.pressed)) {
                              return Colors.orange;
                            }
                            return const Color(0xFF7F2AFF);
                          },
                        ),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        minimumSize: WidgetStateProperty.all(
                          const Size(370, 50),
                        ),
                        overlayColor: WidgetStateProperty.all(
                          Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: const Text(
                        "Update",
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      // bottomNavigationBar: CustomBottomNavigationBar(
      //   currentIndex: widget.fromTabIndex,
      // ),
    );
  }

  Future<void> _openCamera() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 25,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (pickedFile != null) {
        setState(() {
          image = File(pickedFile.path);
          oldImage = null;
        });
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> visitSpotUpdateStore() async {
    if (inprogresssvisitspotstrore) return;

    inprogresssvisitspotstrore = true;
    setState(() {});
    try {
      // ১. Multipart Request create
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(Urls.visitSpotUpdateUrl(widget.item.spotId.toString())),
      );

      // header
      request.headers.addAll({
        "Authorization": "Bearer ${AuthController.accessToken}",
        "Accept": "application/json",
      });

      // body
      request.fields['visit_id'] = widget.iD.id.toString();
      request.fields['client_id'] = selectedClient!.clientid.toString();
      request.fields['visit_purpose_id'] = selectedPurpose!.id.toString();
      request.fields['end_latitude'] = curlat.toString();
      request.fields['end_longitude'] = curlong.toString();
      request.fields['visit_to'] = curAddress;
      request.fields['contact_person'] = _contactpersonController.text.trim();
      request.fields['contact_person_mobile'] = _contactpersonMobileController
          .text
          .trim();
      request.fields['vehicle_id'] = selectedTransport!.transpotid.toString();
      request.fields['vehicle_bill'] = _conveyanceController.text.trim();
      request.fields['remarks'] = _remarksController.text.trim();

      // First check if the image file is null or not.
      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image', // Your API key name
            image!.path,
          ),
        );
      } else {
        print(
          "কোন ইমেজ সিলেক্ট করা হয়নি, তাই ফাইল ছাড়াই রিকোয়েস্ট পাঠানো হচ্ছে।",
        );
      }

      print('REQUEST FIELDS: ${request.fields}');

      // Sending requests and receiving responses
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      final Map<String, dynamic> decodedData = jsonDecode(response.body);
      String serverMessage =
          decodedData['message']?.toString() ?? "Request failed";

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          decodedData['success'] == true) {
        _clearText();

        Get.back(result: true);

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Color(0xFF00A8AA),
            content: Center(
              child: Text(
                serverMessage,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Center(
              child: Text(
                serverMessage,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() {
        inprogresssvisitspotstrore = false;
      });
    }
  }

  // Combined function: GPS + address
  Future<void> _fetchLocationAndAddress() async {
    try {
      // 1️⃣ GPS permission & service check
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => curAddress = "Location services are disabled");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => curAddress = "Location permission denied");
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() => curAddress = "Location permission permanently denied");
        return;
      }

      // 2️⃣ Get GPS coordinates
      Position pos = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high,
      );

      double lat = pos.latitude;
      double long = pos.longitude;

      setState(() {
        curlat = lat;
        curlong = long;
      });

      // 3️⃣ Fetch address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        curlat!,
        curlong!,
      );

      if (placemarks.isNotEmpty) {
        Placemark first = placemarks.first;
        setState(() {
          curAddress =
              "${first.street ?? ''}, ${first.subLocality ?? ''}, ${first.locality ?? ''}";
        });
      } else {
        setState(() => curAddress = "No address found");
      }
    } catch (e) {
      print("Error fetching location or address: $e");
      setState(() => curAddress = "Error fetching location");
    }
  }

  void _clearText() {
    _clientnameController.clear();
    _contactpersonController.clear();
    _contactpersonMobileController.clear();
    _visitPurposeController.clear();
    _transportController.clear();
    _conveyanceController.clear();
    selectedPurpose = null;
    selectedTransport = null;
    image = null;
  }

  @override
  void dispose() {
    _clientnameController.dispose();
    _contactpersonController.dispose();
    _contactpersonMobileController.dispose();
    _transportController.dispose();
    _conveyanceController.dispose();
    _visitPurposeController.dispose();

    super.dispose();
  }
}
