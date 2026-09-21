import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:devsalesxpert/app/urls.dart';
import 'package:devsalesxpert/core/services/network_caller.dart';
import 'package:devsalesxpert/features/auth/presentation/AuthController.dart';
import 'package:devsalesxpert/features/sales/data/models/collection_list_model.dart';
import 'package:devsalesxpert/features/sales/presentation/screens/collection_update_screen.dart';

class SalesOrderCollectionList extends StatefulWidget {
  final CollectionModel item;
  final int index;
  final VoidCallback onDelete;
  final VoidCallback onEditCollection;
  const SalesOrderCollectionList({
    super.key,
    required this.item,
    required this.index,
    required this.onDelete,
    required this.onEditCollection,
  });

  @override
  State<SalesOrderCollectionList> createState() =>
      _SalesOrderCollectionListState();
}

class _SalesOrderCollectionListState extends State<SalesOrderCollectionList> {
  bool inprogresssvisitspotstrore = false;
  bool inprogrssspotView = false;
  bool deleteinprogresscollection = false;

  bool inprogresscollection = false;
  // collection list
  final List<CollectionModel> _collectionList = [];
  Future<void> _collectionListApi() async {
    inprogresscollection = true;
    setState(() {});
    ApiResponse response = await NetworkCaller.getRequest(
      url: Urls.collectionListUrl,
      token: AuthController.accessToken,
    );
    if (!mounted) return;
    if (response.isSuccess) {
      final collectiondata = response.responseData;
      _collectionList.clear();
      for (Map<String, dynamic> convenyancejson
          in collectiondata['data']['collections']) {
        final collectionmodelall = CollectionModel.fromJson(convenyancejson);
        _collectionList.add(collectionmodelall);
      }
    }

    inprogresscollection = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _collectionListApi();
  }

  @override
  Widget build(BuildContext context) {
    print("hellooooooooooooooooooooo");
    var item = widget.item;
    print(item.status);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  formatDate(item.collectionDate!),

                  style: const TextStyle(fontSize: 10),
                ),
              ),

              Expanded(
                flex: 4,
                child: Text(item.mrNo!, style: const TextStyle(fontSize: 10)),
              ),

              Expanded(
                flex: 4,
                child: Text(
                  item.partyName.toString(),

                  style: const TextStyle(fontSize: 10),
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  item.collectionMode.toString(),

                  style: const TextStyle(fontSize: 10),
                ),
              ),

              Expanded(
                flex: 4,
                child: Text(
                  item.collectionAmount.toString(),

                  style: const TextStyle(fontSize: 10),
                ),
              ),

              // status checking...
              item.status != "1"
                  ? Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              var update = await Get.to(
                                () => CollectionUpdateScreen(
                                  item: item,
                                  index: item.id,
                                ),
                              );

                              if (update == true) {
                                widget.onEditCollection();
                                setState(() {});
                              }
                            },
                            child: Icon(
                              Icons.edit,
                              size: 20,
                              color: Colors.deepPurpleAccent,
                            ),
                          ),

                          GestureDetector(
                            onTap: () async {
                              // 1️⃣ Show confirmation dialog
                              bool? confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Confirm deletion?"),
                                  content: Text(
                                    "Are you sure you want to delete this?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Get.back(result: false), // No
                                      child: Text(
                                        "No",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 22,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Get.back(result: true), // Yes
                                      child: Text(
                                        "Yes",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Color(0xFF8F66DC),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );

                              // 2️⃣ If user pressed No or dismissed dialog, return
                              if (confirm != true) return;

                              await collectionDelete(item.id.toString());

                              widget.onDelete();
                              if (mounted) {
                                setState(() {});
                              }
                            },

                            child: Icon(
                              Icons.delete,
                              size: 20,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Expanded(
                      flex: 3,
                      child: Center(
                        child: Text(
                          "Approved",

                          style: TextStyle(color: Colors.black87, fontSize: 12),
                        ),
                      ),
                    ),
            ],
          ),
        ),
        SizedBox(
          height: 5,
          child: Divider(color: Color(0xFF57F1FF), thickness: 1),
        ),
        SizedBox(height: 5),
      ],
    );
  }

  String formatDate(String dateString) {
    // 1. Prothome string-ke DateTime object-e convert koro (Input: 09 Mar, 2026)
    final DateTime date = DateFormat("dd MMM, yyyy").parse(dateString);

    // 2. Erpor formatted string return koro (Output: 09--03--2026)
    return DateFormat('dd-MM-yy').format(date);
  }

  Future<void> collectionDelete(String collectionId) async {
    deleteinprogresscollection = true;
    setState(() {});

    ApiResponse response = await NetworkCaller.deleteRequest(
      url: Urls.collectionDelete(collectionId),
      token: AuthController.accessToken,
    );

    if (response.isSuccess && response.responseData["success"] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          backgroundColor: Color(0xFF00A8AA),

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

    deleteinprogresscollection = false;
    setState(() {});
  }

  // String formatDate(String? dateStr) {
  //   if (dateStr == null || dateStr.isEmpty) return "N/A";
  //   try {
  //     DateTime inputDate = DateTime.parse(dateStr);
  //     return DateFormat('dd-MM-yyyy').format(inputDate);
  //   } catch (e) {
  //     return "Invalid Date";
  //   }
  // }

  String formatTimeAmPm(String rawDateTime) {
    DateTime dateTime = DateTime.parse(rawDateTime);
    return DateFormat('hh:mm a').format(dateTime);
  }

  // widget
  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(label, style: TextStyle(fontSize: 12)),
          ),
          Text(
            " : ",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 12),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
