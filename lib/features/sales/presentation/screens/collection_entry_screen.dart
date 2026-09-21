import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:devsalesxpert/app/urls.dart';
import 'package:devsalesxpert/core/services/network_caller.dart';
import 'package:devsalesxpert/features/auth/presentation/AuthController.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/circular_progress_indicator.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/screen_background.dart';
import 'package:devsalesxpert/features/visit/data/models/client_type_drop_dwon_model.dart';
import 'package:devsalesxpert/features/visit/data/models/purpose_drop_dwon_model.dart';

class CollectionEntryScreen extends StatefulWidget {
  final int fromTabIndex;
  const CollectionEntryScreen({super.key, this.fromTabIndex = 2});

  @override
  State<CollectionEntryScreen> createState() => _CollectionEntryScreenState();
}

class _CollectionEntryScreenState extends State<CollectionEntryScreen> {
  // Controllers
  final _customerNameController = TextEditingController();
  final _collectiondateController = TextEditingController();

  final _amountController = TextEditingController();
  final _collectionmodeController = TextEditingController();

  // colelction mood bank
  final _banknameController = TextEditingController();
  final _accountDetailsController = TextEditingController();
  final _chequeNoController = TextEditingController();
  final _chequedateController = TextEditingController();

  // colelction mood  Bikash
  final _bikashmobilenumberController = TextEditingController();
  // colelction mood Nagad
  final _nagadmobilenumberController = TextEditingController();
  // colelction mood rocket
  final _rocketmobilenumberController = TextEditingController();

  final _transactionIdController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  File? image;
  String? imageName;

  List<Map<String, String>> salesList = [];
  bool inprogressssalesorderentry = false;

  // purpose get visit api
  final List<PurposeModel> _visitpurposeNameList = [];
  PurposeModel? selectedVisitPurpose;
  Future<void> _fetchvisitpurposeList() async {
    ApiResponse response = await NetworkCaller.getRequest(
      url: Urls.purposefromUrl,
      token: AuthController.accessToken,
    );

    if (response.isSuccess) {
      final purposeData = response.responseData;
      for (Map<String, dynamic> purposeJson in purposeData['data']) {
        final purposeModelall = PurposeModel.fromJson(purposeJson);
        _visitpurposeNameList.add(purposeModelall);
      }
      setState(() {});
    } else {
      // ignore: use_build_context_synchronously
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

  final List<String> collectionModes = [
    'cash',
    'bank',
    'bkash',
    'nagad',
    'rocket',
  ];
  String? selectedCollectionMode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _collectiondateController.text = DateFormat(
      'dd-MM-yyyy',
    ).format(DateTime.now());
    _fetchvisitpurposeList();
    _fetchclintList();
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
        title: Text(
          "Collection Entry",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
      body: ScreenBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                /// start
                ///
                TextFormField(
                  controller: _collectiondateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    isDense: true,

                    hintText: "Collection Date",
                    suffixIcon: const Icon(Icons.calendar_today_outlined),
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
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );

                    if (pickedDate != null) {
                      String formattedDate = DateFormat(
                        'dd-MM-yyyy',
                      ).format(pickedDate);

                      _collectiondateController.text = formattedDate;
                    }
                  },

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please select a collection date";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                DropdownSearch<ClientTypeModel>(
                  items: _clientNameList,
                  itemAsString: (ClientTypeModel t) => t.name.toString(),
                  selectedItem: selectedClient,
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search), // এখানে search icon
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
                      labelText: "Customer",
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
                      });
                    }
                  },
                  validator: (ClientTypeModel? client) =>
                      client == null ? "Please select a customer" : null,
                ),
                SizedBox(height: 10),

                TextFormField(
                  controller: _amountController,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'amount is required'
                      : null,
                  decoration: InputDecoration(
                    labelText: "Amount",
                    isDense: true,
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
                const SizedBox(height: 10),

                // TextFormField(
                //   controller: _MrNoController,
                //   validator: (v) => v == null || v.trim().isEmpty
                //       ? 'amount is required'
                //       : null,
                //   decoration: InputDecoration(
                //     labelText: "Mr NO",
                //     isDense: true,
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(15),
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 10),

                // collection mode
                // DropdownSearch<PurposeModel>(
                //   key: ValueKey("visit purpose"),
                //   items: _visitpurposeNameList,
                //   itemAsString: (PurposeModel p) => p.visitPurpose.toString(),
                //   selectedItem: selectedVisitPurpose,
                //   onChanged: (PurposeModel? pur) {
                //     setState(() {
                //       selectedVisitPurpose = pur;
                //     });
                //   },
                //   popupProps: PopupProps.menu(
                //     showSearchBox: true,
                //     searchFieldProps: TextFieldProps(
                //       decoration: InputDecoration(
                //         prefixIcon: const Icon(
                //           Icons.search,
                //         ), // এখানে search icon
                //         hintText: "Collection Mood",
                //         labelText: "Collection Mood",
                //         border: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(12),
                //         ),
                //       ),
                //     ),

                //     showSelectedItems: false, // true দিলে compareFn লাগবে
                //   ),
                //   dropdownDecoratorProps: DropDownDecoratorProps(
                //     // v5 এ সরাসরি decoration দিতে হবে না, বরং
                //     dropdownSearchDecoration: InputDecoration(
                //       labelText: "Select Collection Mood",
                //       border: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(15),
                //       ),
                //     ),
                //   ),
                //   validator: (PurposeModel? pur) =>
                //       pur == null ? "Please select a collection mood" : null,
                // ),

                // // collection mood
                DropdownButtonFormField<String>(
                  value: selectedCollectionMode,
                  items: collectionModes
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCollectionMode = value;
                      _collectionmodeController.text = value ?? '';
                    });
                  },
                  validator: (value) =>
                      value == null ? 'collection mode is required' : null,
                  decoration: InputDecoration(
                    labelText: 'Collection Mode',
                    isDense: true,
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
                const SizedBox(height: 12),

                if (selectedCollectionMode == 'bank') ...[
                  // if mood bank
                  TextFormField(
                    controller: _banknameController,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'bank name & branch name is required'
                        : null,
                    decoration: InputDecoration(
                      labelText: "Bank Name & Branch Name",
                      isDense: true,
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
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: _accountDetailsController,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'account details is required'
                        : null,
                    decoration: InputDecoration(
                      labelText: "Account Details",
                      isDense: true,
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
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: _chequeNoController,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'cheque no is required'
                        : null,
                    decoration: InputDecoration(
                      labelText: "Cheque No",
                      isDense: true,
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
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: _chequedateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      isDense: true,

                      hintText: "Cheque Date",
                      suffixIcon: const Icon(Icons.calendar_today_outlined),

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
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );

                      if (pickedDate != null) {
                        String formattedDate = DateFormat(
                          'dd-MM-yyyy',
                        ).format(pickedDate);
                        _chequedateController.text = formattedDate;
                      }
                    },

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please select a chqque date";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                ],

                if (selectedCollectionMode == 'bkash') ...[
                  // if mood BKASH
                  TextFormField(
                    controller: _bikashmobilenumberController,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'bikash mobile is required'
                        : null,
                    decoration: InputDecoration(
                      labelText: "Bikash Mobile No",
                      isDense: true,
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
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: _transactionIdController,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'transaction id is required'
                        : null,
                    decoration: InputDecoration(
                      labelText: "Transaction Id",
                      isDense: true,
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
                  const SizedBox(height: 10),
                ],
                if (selectedCollectionMode == 'nagad') ...[
                  // if mood NAGAD
                  TextFormField(
                    controller: _nagadmobilenumberController,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'nagad mobile is required'
                        : null,
                    decoration: InputDecoration(
                      labelText: "Nagad Mobile No",
                      isDense: true,
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
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: _transactionIdController,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'transaction id is required'
                        : null,
                    decoration: InputDecoration(
                      labelText: "Transaction Id",
                      isDense: true,
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
                  const SizedBox(height: 10),
                ],
                if (selectedCollectionMode == 'rocket') ...[
                  // if mood Rocket
                  TextFormField(
                    controller: _rocketmobilenumberController,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'rocket mobile is required'
                        : null,
                    decoration: InputDecoration(
                      labelText: "Rocket Mobile No",
                      isDense: true,
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
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: _transactionIdController,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'transaction id is required'
                        : null,
                    decoration: InputDecoration(
                      labelText: "Transaction Id",
                      isDense: true,
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
                  const SizedBox(height: 10),
                ],
                SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _openGallery();
                        print(image!.path);
                      },

                      child: Container(
                        height: 30,
                        width: 95,
                        color: Colors.grey.shade300,
                        child: Center(child: Text("Choose File")),
                      ),
                    ),
                    SizedBox(width: 20),
                    image == null ? Text('No image taken') : Text(imageName!),
                  ],
                ),
                SizedBox(height: 16),

                // submit button
                Visibility(
                  visible: inprogressssalesorderentry == false,
                  replacement: Center(child: CustomCircularProgressIndicator()),
                  child: FilledButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Map<String, String> newSale = {};
                        salesList.add(newSale);
                        _collectionEntry();
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>((
                        states,
                      ) {
                        if (states.contains(WidgetState.pressed)) {
                          return Colors.orange;
                        }
                        return const Color(0xFF7F2AFF);
                      }),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      minimumSize: WidgetStateProperty.all(const Size(370, 50)),
                      overlayColor: WidgetStateProperty.all(
                        Colors.white.withOpacity(0.2),
                      ),
                    ),
                    child: const Text(
                      "Submit",
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
      // bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 2),
    );
  }

  Future<void> _openGallery() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile == null) return;

    setState(() {
      image = File(pickedFile.path);
      imageName = pickedFile.name;
    });
    // Safe print
    print("Image Path: ${image!.path}");
  }

  Future<void> _collectionEntry() async {
    if (inprogressssalesorderentry) return;

    setState(() {
      inprogressssalesorderentry = true;
    });

    try {
      final user = AuthController.userModel!;

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(Urls.collectionEntryUrl),
      );

      // Headers
      request.headers.addAll({
        'Authorization': 'Bearer ${AuthController.accessToken}',
        'Accept': 'application/json',
      });

      // ================= BASIC FIELDS =================
      request.fields['company_id'] = user.companyid.toString();
      request.fields['employee_id'] = user.empoloyeeid.toString();
      request.fields['collection_amount'] = _amountController.text.trim();
      request.fields['collection_date'] = _collectiondateController.text.trim();
      request.fields['collection_mode'] = selectedCollectionMode ?? "";

      if (selectedClient != null) {
        request.fields['party_id'] = selectedClient!.clientid.toString();
      }

      // ================= BANK =================
      if (selectedCollectionMode == 'bank') {
        request.fields['bank_name'] = _banknameController.text.trim();
        request.fields['acc_name'] = _accountDetailsController.text.trim();
        request.fields['cheque_no'] = _chequeNoController.text.trim();
        request.fields['cheque_date'] = _collectiondateController.text.trim();
      }

      // ================= MOBILE BANKING =================
      if (selectedCollectionMode == 'bkash' ||
          selectedCollectionMode == 'nagad' ||
          selectedCollectionMode == 'rocket') {
        request.fields['mobile'] = selectedCollectionMode == 'bkash'
            ? _bikashmobilenumberController.text.trim()
            : selectedCollectionMode == 'nagad'
            ? _nagadmobilenumberController.text.trim()
            : _rocketmobilenumberController.text.trim();

        request.fields['trx_id'] = _transactionIdController.text.trim();
      }

      // ================= IMAGE =================
      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'attachment', // backend field name
            image!.path,
          ),
        );
      }

      // ================= SEND REQUEST =================
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      final Map<String, dynamic> decodedData = jsonDecode(response.body);

      String serverMessage =
          decodedData['message']?.toString() ?? "Request failed";

      print(decodedData);
      print(response.statusCode);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          decodedData['success'] == true) {
        clearText();
        Get.back(result: true);

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
        inprogressssalesorderentry = false;
      });
    }
  }

  // Future<void> _collectionEntry() async {
  //   if (inprogressssalesorderentry) return;

  //   inprogressssalesorderentry = true;

  //   setState(() {});

  //   final Map<String, dynamic> requestBody = {
  //     "company_id": AuthController.userModel!.companyid,
  //     "employee_id": AuthController.userModel!.empoloyeeid,
  //     "collection_amount": _amountController.text.trim(),
  //     "collection_date": _collectiondateController.text.trim(),
  //     "collection_mode": selectedCollectionMode,
  //     "attachment" : image!.path,
  //   };

  //   if (selectedClient != null) {
  //     requestBody["party_id"] = selectedClient!.clientid;
  //   }

  //   // ================= BANK =================
  //   if (selectedCollectionMode == 'bank') {
  //     requestBody.addAll({
  //       "bank_name": _banknameController.text.trim(),
  //       "acc_name": _accountDetailsController.text.trim(),
  //       "cheque_no": _chequeNoController.text.trim(),
  //       "cheque_date": _collectiondateController.text.trim(),
  //     });
  //   }

  //   // ================= MOBILE BANKING =================
  //   if (selectedCollectionMode == 'bkash' ||
  //       selectedCollectionMode == 'nagad' ||
  //       selectedCollectionMode == 'rocket') {
  //     requestBody.addAll({
  //       "mobile": selectedCollectionMode == 'bkash'
  //           ? _bikashmobilenumberController.text.trim()
  //           : selectedCollectionMode == 'nagad'
  //           ? _nagadmobilenumberController.text.trim()
  //           : _rocketmobilenumberController.text.trim(),
  //       "trx_id": _transactionIdController.text.trim(),
  //     });
  //   }

  //   ApiResponse response = await NetworkCaller.postRequest(
  //     url: Urls.collectionEntryUrl,
  //     body: requestBody,
  //     token: AuthController.accessToken,
  //   );

  //   print(response.responseData);
  //   print(response.responseCode);

  //   if (response.isSuccess && response.responseData["success"] == true) {
  //     clearText();
  //     // Get.offAll(() => const BottomNavControllerScreen(initialIndex: 2));
  //     // ignore: use_build_context_synchronously
  //     Get.back(result: true);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         duration: const Duration(seconds: 2),
  //         backgroundColor: Color(0xFF00A8AA),

  //         content: Center(
  //           child: Text(
  //             response.errorMessage,
  //             style: TextStyle(
  //               fontSize: 18,
  //               color: Colors.white,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ),
  //       ),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         duration: const Duration(seconds: 2),
  //         backgroundColor: Colors.red,

  //         content: Center(
  //           child: Text(
  //             response.errorMessage,
  //             style: TextStyle(
  //               fontSize: 18,
  //               color: Colors.white,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ),
  //       ),
  //     );
  //   }
  //   inprogressssalesorderentry = false;
  //   setState(() {});
  // }

  void clearText() {
    _customerNameController.clear();
    _collectiondateController.clear();
    _amountController.clear();
    _collectionmodeController.clear();

    // Bank
    _banknameController.clear();
    _accountDetailsController.clear();
    _chequeNoController.clear();
    _chequedateController.clear();

    // Bikash
    _bikashmobilenumberController.clear();

    // Nagad
    _nagadmobilenumberController.clear();

    // Rocket
    _rocketmobilenumberController.clear();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _customerNameController.dispose();
    _collectiondateController.dispose();
    _amountController.dispose();
    _collectionmodeController.dispose();

    // Bank
    _banknameController.dispose();
    _accountDetailsController.dispose();
    _chequeNoController.dispose();
    _chequedateController.dispose();

    // Bikash
    _bikashmobilenumberController.dispose();

    // Nagad
    _nagadmobilenumberController.dispose();

    // Rocket
    _rocketmobilenumberController.dispose();
  }
}
